//
//  PeopleListViewController.h
//  TFHealth
//
//  Created by fei on 14-7-28.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *showPeopleTableView;
    NSMutableArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *showListTableView;
@property (nonatomic,retain) NSString *comfromType;

@end
