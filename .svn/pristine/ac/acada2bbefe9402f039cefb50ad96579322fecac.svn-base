//
//  AddFriendAlertView.h
//  TFHealth
//
//  Created by fei on 14-8-1.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddFiendAlertViewDelegate;
@interface AddFriendAlertView : UIView
{
    UIControl *backControl;
}

@property (nonatomic,assign) id <AddFiendAlertViewDelegate> alertDelegate;


-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)str andImage:(UIImage *)image message:(NSString *)message delegate:(id<AddFiendAlertViewDelegate>)delegate;
-(void)show;
@end

@protocol AddFiendAlertViewDelegate <NSObject>

-(void)addFiendAlertView:(AddFriendAlertView *)addView ButtonClickedAtIndex:(NSInteger)buttonIndex;

@end