//
//  AKPickerView.m
//  AKPickerViewSample
//
//  Created by Akio Yasui on 3/29/14.
//  Copyright (c) 2014 Akio Yasui. All rights reserved.
//

#import "AKPickerView.h"

#import <Availability.h>

@interface AKCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@end

@interface AKCollectionViewLayout : UICollectionViewFlowLayout
@end

@interface AKPickerView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger selectedItem;
- (CGFloat)offsetForItem:(NSUInteger)item;
- (void)didEndScrolling;
@end

@implementation AKPickerView

- (void)initialize
{
    
	self.font = self.font ?: [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
	self.textColor = self.textColor ?: [UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:240.0/255.0 alpha:1];
	self.highlightedTextColor = self.highlightedTextColor ?: [UIColor whiteColor];

	[self.collectionView removeFromSuperview];
	self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
											 collectionViewLayout:[AKCollectionViewLayout new]];
	self.collectionView.showsHorizontalScrollIndicator = NO;
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
	self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.collectionView registerClass:[AKCollectionViewCell class]
			forCellWithReuseIdentifier:NSStringFromClass([AKCollectionViewCell class])];
	[self addSubview:self.collectionView];

	CAGradientLayer *maskLayer = [CAGradientLayer layer];
	maskLayer.frame = self.collectionView.bounds;
    NSLog(@"w=%.1f",maskLayer.frame.size.width);
    NSLog(@"x=%.1f",maskLayer.frame.origin.x);
	maskLayer.colors = @[(id)[[UIColor clearColor] CGColor],
                         (id)[[UIColor clearColor] CGColor],
						 (id)[[UIColor whiteColor] CGColor],
						 (id)[[UIColor whiteColor] CGColor],
						 (id)[[UIColor clearColor] CGColor],
                         (id)[[UIColor clearColor] CGColor],];
	maskLayer.locations = @[@0.0, @0.23,@0.33, @0.63, @0.83,@1.0];
	maskLayer.startPoint = CGPointMake(0.0, 0.0);
	maskLayer.endPoint = CGPointMake(1.0, 0.0);
	self.collectionView.layer.mask = maskLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}

#pragma mark -

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self.collectionView.collectionViewLayout invalidateLayout];
	[self scrollToItem:self.selectedItem animated:NO];
	self.collectionView.layer.mask.frame = self.collectionView.bounds;
}

#pragma mark -

- (void)setFont:(UIFont *)font
{
	if (![_font isEqual:font]) {
		_font = font;
		[self initialize];
	}
}

#pragma mark -

- (void)reloadData
{
    [self.collectionView.collectionViewLayout invalidateLayout];
	[self.collectionView reloadData];
}

- (CGFloat)offsetForItem:(NSUInteger)item
{
	CGFloat offset = 0.0;
	for (NSInteger i = 0; i < item; i++) {
		NSIndexPath *_indexPath = [NSIndexPath indexPathForItem:i inSection:0];
		AKCollectionViewCell *cell = (AKCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:_indexPath];
		offset += cell.bounds.size.width;
	}

	NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
	CGSize firstSize = [self.collectionView cellForItemAtIndexPath:firstIndexPath].bounds.size;
	NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
	CGSize selectedSize = [self.collectionView cellForItemAtIndexPath:selectedIndexPath].bounds.size;
	offset -= (firstSize.width - selectedSize.width) / 2;

	offset += self.interitemSpacing * item;
	return offset;
}

- (void)scrollToItem:(NSUInteger)item animated:(BOOL)animated
{
	[self.collectionView setContentOffset:CGPointMake([self offsetForItem:item],
													  self.collectionView.contentOffset.y)
								 animated:animated];
}

- (void)selectItem:(NSUInteger)item animated:(BOOL)animated
{
	[self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]
									  animated:animated
								scrollPosition:UICollectionViewScrollPositionNone];
	[self scrollToItem:item animated:animated];

	self.selectedItem = item;

	if ([self.delegate respondsToSelector:@selector(pickerView:didSelectItem:)])
		[self.delegate pickerView:self didSelectItem:item];
}

- (void)didEndScrolling
{
	if ([self.delegate numberOfItemsInPickerView:self]) {
		for (NSUInteger i = 0; i < [self collectionView:self.collectionView numberOfItemsInSection:0]; i++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
			AKCollectionViewCell *cell = (AKCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
			if ([self offsetForItem:i] + cell.bounds.size.width / 2 > self.collectionView.contentOffset.x) {
				[self selectItem:i animated:YES];
				break;
			}
		}
	}
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return ([self.delegate numberOfItemsInPickerView:self] > 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.delegate numberOfItemsInPickerView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *title = [self.delegate pickerView:self titleForItem:indexPath.item];

	AKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AKCollectionViewCell class])
																		   forIndexPath:indexPath];
	cell.label.textColor = self.textColor;
	cell.label.highlightedTextColor = self.highlightedTextColor;
	cell.label.font = self.font;
	
	if ([cell.label respondsToSelector:@selector(setAttributedText:)]) {
		cell.label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: self.font}];
	} else {
		cell.label.text = title;
	}

	[cell.label sizeToFit];

	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *title = [self.delegate pickerView:self titleForItem:indexPath.item];
	CGSize size;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0) {
		size = [title sizeWithAttributes:@{NSFontAttributeName: self.font}];
	} else {
		size = [title sizeWithFont:self.font];
	}
	return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return self.interitemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	NSInteger number = [self collectionView:collectionView numberOfItemsInSection:section];
	NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
	CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
	NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:number - 1 inSection:section];
	CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
	return UIEdgeInsetsMake((collectionView.bounds.size.height - ceilf(self.font.lineHeight)) / 2,
							(collectionView.bounds.size.width - firstSize.width) / 2,
							(collectionView.bounds.size.height - ceilf(self.font.lineHeight)) / 2,
							(collectionView.bounds.size.width - lastSize.width) / 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self selectItem:indexPath.item animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self didEndScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate) [self didEndScrolling];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	self.collectionView.layer.mask.frame = self.collectionView.bounds;
	[CATransaction commit];
}

@end

@implementation AKCollectionViewCell

- (void)initialize
{
	self.label = [[UILabel alloc] initWithFrame:self.bounds];
	self.label.backgroundColor = [UIColor clearColor];
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.textColor = [UIColor grayColor];
	self.label.numberOfLines = 1;
	self.label.lineBreakMode = NSLineBreakByTruncatingTail;
	self.label.highlightedTextColor = [UIColor blackColor];
	self.label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
	[self.contentView addSubview:self.label];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}

@end

@interface AKCollectionViewLayout ()
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat midX;
@property (nonatomic, assign) CGFloat maxAngle;
@end

@implementation AKCollectionViewLayout

- (id)init
{
	self = [super init];
	if (self) {
		self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
		self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		self.minimumLineSpacing = 0.0;
	}
	return self;
}

- (void)prepareLayout
{
	CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
	self.midX = CGRectGetMidX(visibleRect);
	self.width = CGRectGetWidth(visibleRect) / 2;
	self.maxAngle = M_PI_2;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];

	CGFloat distance = CGRectGetMidX(attributes.frame) - self.midX;
	CGFloat currentAngle = self.maxAngle * distance / self.width;
	CGFloat delta = sinf(currentAngle) * self.width - distance;

	attributes.transform3D = CATransform3DConcat(CATransform3DMakeRotation(currentAngle, 0, 1, 0),
												 CATransform3DMakeTranslation(delta, 0, 0));

	attributes.alpha = (ABS(distance) < self.width);

	return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSMutableArray *attributes = [NSMutableArray array];
	if ([self.collectionView numberOfSections]) {
		for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
			[attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
		}
	}
    return attributes;
}

@end