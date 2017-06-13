//
//  FamilyManagementCollectionViewCell.h
//  TFHealth
//
//  Created by 王帅 on 17/3/13.
//  Copyright © 2017年 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deleteImageDelegate<NSObject>
-(void)deleteImageSelected:(NSString *)userID;
@end

@interface FamilyManagementCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *userIco;//头像
@property(nonatomic,strong)UIImageView *choosedImage;//选择
@property(nonatomic,strong)UIButton *deleteBtn;//删除
@property(nonatomic,strong)UILabel *userName;//昵称
@property(nonatomic,assign)id<deleteImageDelegate>delegate;

@end
