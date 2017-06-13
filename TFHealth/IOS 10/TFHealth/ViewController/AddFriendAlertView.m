//
//  AddFriendAlertView.m
//  TFHealth
//
//  Created by fei on 14-8-1.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "AddFriendAlertView.h"

@implementation AddFriendAlertView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)str andImage:(UIImage *)image message:(NSString *)message delegate:(id<AddFiendAlertViewDelegate>)delegate {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _alertDelegate = delegate;
        
        [self setSubViewsWithTitle:str message:message image:image];
    }
    return self;
}
-(void)setSubViewsWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image {
    self.frame = CGRectMake(0, 0, 280, 120);
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 3.0f;
    self.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [self addSubview:titleLabel];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 30, 30)];
    imageView.image = image;
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.layer.borderWidth = 5;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = UIColorFromRGB(0x343963).CGColor;
    [self addSubview:imageView];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 35, self.frame.size.width-70, 40)];
    infoLabel.numberOfLines = 2;
    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    infoLabel.text = message;
    infoLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:infoLabel];
    
    for (int i = 0; i < 2;  i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(self.frame.size.width/2*i, 80, self.frame.size.width/2, 40);
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:i==0?@"确定":@"取消" forState:UIControlStateNormal];
        button.tag = 200 + i;
        [self addSubview:button];
    }
    
}

-(void)show {
    
    backControl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backControl.backgroundColor = [UIColor colorWithRed:121/255 green:121/255 blue:121/255 alpha:0.5];
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if(!keywindow){
        keywindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    }
	[keywindow addSubview:backControl];
	[keywindow addSubview:self];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [backControl addGestureRecognizer:tapGesture];
	self.center = CGPointMake(keywindow.bounds.size.width / 2.0f,
	                          keywindow.bounds.size.height / 2.0f);
	[self fadeIn];
    
}

-(void)fadeIn {
    
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
    
}

-(void)fadeOut {
    
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        if (finished) {
            [backControl removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

-(void)buttonClicked:(UIButton *)btn {
    
    if ([_alertDelegate respondsToSelector:@selector(addFiendAlertView:ButtonClickedAtIndex:)]) {
        [_alertDelegate addFiendAlertView:self ButtonClickedAtIndex:btn.tag-200];
    }
    [self fadeOut];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
