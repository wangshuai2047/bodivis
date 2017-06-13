//
//  ComponentAnalysisViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/12/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "ComponentAnalysisViewController.h"
#import "NormalAnalysisTableViewCell.h"
#import "ColorBarAnalysisTableViewCell.h"
#import "AnalysisDetailTableViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "HistoryDataViewController.h"
#import "User_Item_Info.h"
#import "TestItemCalc.h"
#import "TestItemID.h"
#import "AppDelegate.h"
#import "User.h"

@interface ComponentAnalysisViewController ()<UITableViewDataSource,UITableViewDelegate,NormalAnalysisCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *analysisTableView;
@property (strong,nonatomic) NSIndexPath * selectedIndexPath;
@property (retain,nonatomic) NSMutableArray* normalDatas;
@property (retain,nonatomic) NSMutableArray* abnormalDatas;
@end

@implementation ComponentAnalysisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)backButtonClikc:(id)sender {
    UIViewController * hsvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
    //[self.mm_drawerController setCenterViewController:hsvc withCloseAnimation:YES completion:nil];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)selectedIndexAlloc
{
    self.selectedIndexPath = [NSIndexPath indexPathForRow:1000 inSection:1000];
}

-(BOOL)selectedIndexPathIsAlloced
{
    if (self.selectedIndexPath.row == 1000 && self.selectedIndexPath.section == 1000) {
        return YES;
    }
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self selectedIndexAlloc];
    self.analysisTableView.delegate = self;
    self.analysisTableView.dataSource = self;
    
    self.normalDatas = [[NSMutableArray alloc] init];
    self.abnormalDatas = [[NSMutableArray alloc] init];
    [self loadData];
}

-(void)loadData
{
    [self.normalDatas removeAllObjects];
    [self.abnormalDatas removeAllObjects];
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    
    User_Item_Info* lastInFluidItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getInFluid]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastExFluidItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getExFluid]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastWeightItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getWeight]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastFatItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getFat]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastProteinItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getProtein]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastMuscleItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getMuscle]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastSMuscleItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getSMuscle]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastTotalWaterItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getTotalWater]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastSclerotinItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getSclerotin]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastSFatItem=[User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getSplanchnaPercentFat]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    
    //    if(lastInFluidItem!=nil && lastWeightItem!=nil)
    //    {
    //        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
    //        data.minValue = [TestItemCalc calcMinInFluid:lastWeightItem.testValue];
    //        data.maxValue = [TestItemCalc calcMaxInFluid:lastWeightItem.testValue];
    //        data.testValue = lastInFluidItem.testValue;
    //        data.description = [self getDescription:@"细胞内液" pMin:data.minValue pMax:data.maxValue pValue:data.testValue];
    //        data.unit = @"KG";
    //        data.title=@"细胞内液";
    //        data.level = [self getDataLevel:data.testValue pMin:data.minValue pMax:data.maxValue];
    //        [self addData:data];
    //    }
    //    else
    //    {
    //        AnalyseDetailData* data =[self getDefaultData:@"细胞内液" pUnit:@"KG"];
    //        [self addData:data];
    //    }
    //    if(lastExFluidItem!=nil && lastWeightItem!=nil)
    //    {
    //        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
    //        data.minValue = [TestItemCalc calcMinExFluid:lastWeightItem.testValue];
    //        data.maxValue = [TestItemCalc calcMaxExFluid:lastWeightItem.testValue];
    //        data.testValue = lastExFluidItem.testValue;
    //        data.description = [self getDescription:@"细胞外液" pMin:data.minValue pMax:data.maxValue pValue:data.testValue];
    //        data.unit = @"KG";
    //        data.title=@"细胞外液";
    //        data.level = [self getDataLevel:data.testValue pMin:data.minValue pMax:data.maxValue];
    //        [self addData:data];
    //    }
    //    else
    //    {
    //        AnalyseDetailData* data =[self getDefaultData:@"细胞外液" pUnit:@"KG"];
    //        [self addData:data];
    //    }
    if(lastWeightItem!=nil && user!=nil)
    {
        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
        data.minValue = [TestItemCalc calcMinWeight:user.height pSexy:user.sex.intValue==1];
        data.maxValue =[TestItemCalc calcMaxWeight:user.height pSexy:user.sex.intValue==1];
        data.testValue = lastWeightItem.testValue;
        data.description = [self getDescription:@"体重" pMin:data.minValue pMax:data.maxValue pValue:data.testValue];
        data.unit = @"kg";
        data.title=@"体重";
        data.level = [self getDataLevel:data.testValue pMin:data.minValue pMax:data.maxValue];
        data.levelTitle=[self getLevelTitle:data.level];
        [self addData:data];
    }
    else
    {
        AnalyseDetailData* data =[self getDefaultData:@"体重" pUnit:@"kg"];
        [self addData:data];
    }
    if(lastWeightItem!=nil && lastFatItem!=nil)
    {
        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
        data.minValue = [TestItemCalc calcMinFat:lastWeightItem.testValue pSexy:user.sex.intValue==1];
        data.maxValue = [TestItemCalc calcMaxFat:lastWeightItem.testValue pSexy:user.sex.intValue==1];
        data.testValue = lastFatItem.testValue;
        data.description = [self getDescription:@"脂肪" pMin:data.minValue pMax:data.maxValue pValue:data.testValue];
        data.unit = @"kg";
        data.title=@"脂肪";
        data.level = [self getDataLevel:data.testValue pMin:data.minValue pMax:data.maxValue];
        data.levelTitle=[self getLevelTitle:data.level];
        [self addData:data];
    }
    else
    {
        AnalyseDetailData* data =[self getDefaultData:@"脂肪" pUnit:@"kg"];
        [self addData:data];
    }

    if(lastWeightItem!=nil&& lastFatItem!=nil && user!=nil)
    {
        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
        data.minValue = [TestItemCalc calcMinPBF:lastWeightItem.testValue pFat:lastFatItem.testValue pSexy:user.sex.intValue==1];
        data.maxValue = [TestItemCalc calcMaxPBF:lastWeightItem.testValue pFat:lastFatItem.testValue pSexy:user.sex.intValue==1];
        data.testValue = [TestItemCalc calcPBF:lastWeightItem.testValue pFat:lastFatItem.testValue];
        data.description = [self getDescription:@"体脂率" pMin:data.minValue pMax:data.maxValue pValue:data.testValue];
        data.unit = @"%";
        data.title=@"体脂率";
        data.level = [self getDataLevel:data.testValue pMin:data.minValue pMax:data.maxValue];
        data.levelTitle=[self getLevelTitle:data.level];
        [self addData:data];
    }
    else
    {
        AnalyseDetailData* data =[self getDefaultData:@"体脂率" pUnit:@"%"];
        [self addData:data];
    }
    
    if(lastWeightItem!=nil&& lastFatItem!=nil && user!=nil)
    {
        NSArray* dItems =[NSArray arrayWithObjects:@"较轻",@"正常",@"轻度",@"中度",@"重度",@"极度", nil];
        NSNumber* pbf = [TestItemCalc calcPBF:lastWeightItem.testValue pFat:lastFatItem.testValue];
        NSString* value =[TestItemCalc calcFatLevelByPbf:pbf pSexy:user.sex.intValue==1];
        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
        data.minValue =[NSNumber numberWithDouble:0];
        data.maxValue =[NSNumber numberWithDouble:0];
        data.testStringValue = value;
        data.unit=@"";
        data.title=@"肥胖等级";
        data.levelTitle=value;
        data.level=[dItems indexOfObject:value];
        data.displayItems=dItems;
        data.description=[NSString stringWithFormat:@"肥胖等级为%@",value];
        [self addData:data];
    }
    else
    {
        AnalyseDetailData* data =[self getDefaultData:@"肥胖等级" pUnit:@""];
        data.displayItems=[NSArray arrayWithObjects:@"较轻",@"正常",@"轻度",@"中度",@"重度",@"极度", nil];
        data.testStringValue=@"正常";
        [self addData:data];
    }
    
    if(lastSFatItem!=nil)
    {
        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
        data.minValue =[NSNumber numberWithDouble:10];
        data.maxValue =[NSNumber numberWithDouble:14];
        
        if(lastSFatItem.testValue.doubleValue<=2)
        {
            data.testValue =[NSNumber numberWithDouble:lastSFatItem.testValue.doubleValue+1];
        }
        else
        {
            data.testValue = [NSNumber numberWithDouble:lastSFatItem.testValue.doubleValue];
        }
        NSString* levelTitle;
        int level=1;
        NSString* desc;
        
        if(data.testValue.doubleValue>=0 && data.testValue.doubleValue<10)
        {
            levelTitle=@"正常";
            level=0;
            desc=@"内脏脂肪在正常范围内,请保持";
        }
        else if(data.testValue.doubleValue>=10 && data.testValue.doubleValue<14)
        {
            levelTitle=@"超标";
            level=1;
            desc=@"内脏脂肪超标,请根据营养处方合理饮食,以便达标";
        }
        else
        {
            levelTitle=@"高";
            level=2;
            desc=@"内脏脂肪超标,请根据营养处方合理饮食,以便达标";
        }
        data.description = desc;
        data.unit = @"";
        data.title=@"内脏脂肪";
        data.level = level;
        data.levelTitle=levelTitle;
        data.displayItems=[NSArray arrayWithObjects:@"正常",@"超标",@"高", nil];
        if(data.level==0)
        {
            [self.normalDatas addObject:data];
        }
        else
        {
            [self.abnormalDatas addObject:data];
        }
    }
    else
    {
        AnalyseDetailData* data =[self getDefaultData:@"内脏脂肪" pUnit:@""];
        data.displayItems=[NSArray arrayWithObjects:@"正常",@"超标",@"高", nil];
        data.level=0;
        if(data.level==0)
        {
            [self.normalDatas addObject:data];
        }
        else
        {
            [self.abnormalDatas addObject:data];
        }
    }

    if(lastWeightItem!=nil && lastProteinItem!=nil)
    {
        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
        data.minValue = [TestItemCalc calcMinProtein:lastWeightItem.testValue];
        data.maxValue =[TestItemCalc calcMaxProtein:lastWeightItem.testValue];
        data.testValue = lastProteinItem.testValue;
        data.description = [self getDescription:@"蛋白质" pMin:data.minValue pMax:data.maxValue pValue:data.testValue];
        data.unit = @"kg";
        data.title=@"蛋白质";
        data.level = [self getDataLevel:data.testValue pMin:data.minValue pMax:data.maxValue];
        data.levelTitle=[self getLevelTitle:data.level];
        [self addData:data];
    }
    else
    {
        AnalyseDetailData* data =[self getDefaultData:@"蛋白质" pUnit:@"kg"];
        [self addData:data];
    }
    
    if(lastWeightItem!=nil && lastTotalWaterItem!=nil)
    {
        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
        data.minValue = [TestItemCalc calcMinTotalWater:lastWeightItem.testValue];
        data.maxValue =[TestItemCalc calcMaxTotalWater:lastWeightItem.testValue];
        data.testValue = lastTotalWaterItem.testValue;
        data.description = [self getDescription:@"水分" pMin:data.minValue pMax:data.maxValue pValue:data.testValue];
        data.unit = @"kg";
        data.title=@"水分";
        data.level = [self getDataLevel:data.testValue pMin:data.minValue pMax:data.maxValue];
        data.levelTitle=[self getLevelTitle:data.level];
        [self addData:data];
    }
    else
    {
        AnalyseDetailData* data =[self getDefaultData:@"水分" pUnit:@"kg"];
        [self addData:data];
    }
    
    if(lastWeightItem!=nil && lastMuscleItem!=nil && user!=nil)
    {
        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
        data.minValue = [TestItemCalc calcMinMuscle:user.height pSexy:user.sex.intValue==1];
        data.maxValue =[TestItemCalc calcMaxMuscle:user.height pSexy:user.sex.intValue==1];
        data.testValue = lastMuscleItem.testValue;
        data.description = [self getDescription:@"肌肉" pMin:data.minValue pMax:data.maxValue pValue:data.testValue];
        data.unit = @"kg";
        data.title=@"肌肉";
        data.level = [self getDataLevel:data.testValue pMin:data.minValue pMax:data.maxValue];
        data.levelTitle=[self getLevelTitle:data.level];
        [self addData:data];
    }
    else
    {
        AnalyseDetailData* data =[self getDefaultData:@"肌肉" pUnit:@"kg"];
        [self addData:data];
    }
    if(lastWeightItem!=nil && lastSMuscleItem!=nil && user!=nil)
    {
        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
        data.minValue = [TestItemCalc calcMinSMuscle:user.height pSexy:user.sex.intValue==1];
        data.maxValue =[TestItemCalc calcMaxSMuscle:user.height pSexy:user.sex.intValue==1];
        data.testValue = lastSMuscleItem.testValue;
        data.description = [self getDescription:@"骨骼肌" pMin:data.minValue pMax:data.maxValue pValue:data.testValue];
        data.unit = @"kg";
        data.title=@"骨骼肌";
        data.level = [self getDataLevel:data.testValue pMin:data.minValue pMax:data.maxValue];
        data.levelTitle=[self getLevelTitle:data.level];
        [self addData:data];
    }
    else
    {
        AnalyseDetailData* data =[self getDefaultData:@"骨骼肌" pUnit:@"kg"];
        [self addData:data];
    }
    if(lastWeightItem!=nil && lastSclerotinItem!=nil)
    {
        AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
        data.minValue = [TestItemCalc calcMinSclerotin:lastWeightItem.testValue];
        data.maxValue =[TestItemCalc calcMaxSclerotin:lastWeightItem.testValue];
        data.testValue = lastSclerotinItem.testValue;
        data.description = [self getDescription:@"骨质" pMin:data.minValue pMax:data.maxValue pValue:data.testValue];
        data.unit = @"kg";
        data.title=@"骨质";
        data.level = [self getDataLevel:data.testValue pMin:data.minValue pMax:data.maxValue];
        data.levelTitle=[self getLevelTitle:data.level];
        [self addData:data];
    }
    else
    {
        AnalyseDetailData* data =[self getDefaultData:@"骨质" pUnit:@"kg"];
        [self addData:data];
    }
}

-(NSString*)getDescription:(NSString*)title pMin:(NSNumber*)min pMax:(NSNumber*)max pValue:(NSNumber*)value
{
    NSString* result;
    if(value.doubleValue>=min.doubleValue && value.doubleValue<=max.doubleValue)
    {
        result =[NSString stringWithFormat:@"%@在正常范围内,请保持", title];
    }
    else if(value.doubleValue<min.doubleValue)
    {
        result =[NSString stringWithFormat:@"%@偏低,请根据营养处方合理饮食,以便达标", title];
    }
    else if (value.doubleValue>max.doubleValue)
    {
        result =[NSString stringWithFormat:@"%@偏高,请根据运动处方坚持运动,以便达标", title];
    }
    return result;
}


-(int)getDataLevel:(NSNumber*)value pMin:(NSNumber*)min pMax:(NSNumber*)max
{
    int result;
    if(value.doubleValue>=min.doubleValue && value.doubleValue<=max.doubleValue)
    {
        result =1;
    }
    else if(value.doubleValue<min.doubleValue)
    {
        result =0;
    }
    else {
        result=2;
    }
    return result;
}

-(NSString*)getLevelTitle:(int)level
{
    NSString* result;
    if(level==1)
    {
        result =@"正常";
    }
    else if(level==0)
    {
        result =@"偏低";
    }
    else {
        result=@"偏高";
    }
    return result;
}

-(AnalyseDetailData*)getDefaultData:(NSString*)title pUnit:(NSString*)unit
{
    AnalyseDetailData* data =[[AnalyseDetailData alloc] init];
    data.minValue = [NSNumber numberWithDouble:0];
    data.maxValue = [NSNumber numberWithDouble:0];
    data.testValue = [NSNumber numberWithDouble:0];
    data.description = [NSString stringWithFormat:@"%@暂无数据",title];
    data.unit = unit;
    data.level = 1;
    data.title = title;
    data.displayItems=[NSArray arrayWithObjects:@"偏高",@"正常",@"偏高", nil];
    data.levelTitle=[self getLevelTitle:1];
    return data;
}

-(void)addData:(AnalyseDetailData*)data
{
    if(data.level==1)
    {
        [self.normalDatas addObject:data];
    }
    else
    {
        [self.abnormalDatas addObject:data];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (section == 1) {
    //        return self.selectedIndexPath.section==1?4:3;
    //    }
    //
    //    if (section==0 ) {
    //        return  self.selectedIndexPath.section==0?6:5;
    //    }
    NSUInteger abnormalCount= self.abnormalDatas.count;
    NSUInteger normalCount = self.normalDatas.count;
    if (section == 1 && abnormalCount>0) {
        return self.selectedIndexPath.section==1?(abnormalCount+1):abnormalCount;
    }
    else if (section==0 && normalCount>0) {
        NSInteger count =  self.selectedIndexPath.section==0?(normalCount+1):normalCount;
        return  count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndexPath.row == indexPath.row&&self.selectedIndexPath.section == indexPath.section) {
        return 150;
    }
    return 44;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(15, 17, 6, 6)];
    whiteView.layer.cornerRadius = 3;
    whiteView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [view addSubview:whiteView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(24, 0, 280, 40)];
    //NSUInteger abnormalCount= self.abnormalDatas.count;
    //NSUInteger normalCount = self.normalDatas.count;
    if(section==0)
    {
        //label.text = [NSString stringWithFormat:@"根据体成分测试，以下%u项合格",normalCount];
        label.text = @"根据测试，以下为合格项，点击可查看详细";
    }
    else
    {
        //label.text = [NSString stringWithFormat:@"根据体成分测试，以下%u项不合格",abnormalCount];
        label.text = @"根据测试，以下为不合格项，点击可查看详细";
    }
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"component analyse cellForRowAtIndexPath: %ld-%ld", (long)indexPath.section,(long)indexPath.row);
     NSArray* colors=[NSArray arrayWithObjects:UIColorFromRGB(0xf0c759),UIColorFromRGB(0x89e456),UIColorFromRGB(0xe84949),UIColorFromRGB(0x6349E9),UIColorFromRGB(0xE949DF),UIColorFromRGB(0x820000), nil];
    if (self.selectedIndexPath!=nil && indexPath.row == self.selectedIndexPath.row && indexPath.section == self.selectedIndexPath.section) {
        
        AnalysisDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AnalysisDetailTableViewCell" forIndexPath:indexPath];
        AnalyseDetailData* data ;
        NSInteger row = indexPath.row;
        if(self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row<row)
        {
            row = row - 1;
        }
        if(indexPath.section==0)
        {
            data = [self.normalDatas objectAtIndex:row-1];
            
        }
        else
        {
            data = [self.abnormalDatas objectAtIndex:row-1];
        }
        if(data!=nil)
        {
            if([data.title isEqual:@"内脏脂肪"])
            {
                [cell.bar setColors:[NSArray arrayWithObjects:UIColorFromRGB(0x89e456),UIColorFromRGB(0xe84949),UIColorFromRGB(0x6349E9), nil]];
            }
            else
            {
                [cell.bar setColors:colors];
            }
            if(data.displayItems!=nil)
            {
                [cell.bar setItems:data.displayItems];
            }
            else
            {
                [cell.bar setItems:[NSArray arrayWithObjects:@"低",@"正常",@"高", nil]];
            }
            cell.detailTextView.text =data.description;
            if(data.minValue.doubleValue!=0)
            {
                [cell.bar setMinValue:[NSString stringWithFormat:@"%3.1f",data.minValue.doubleValue]];
            }
            if(data.maxValue.doubleValue!=0)
            {
                [cell.bar setMaxValue:[NSString stringWithFormat:@"%3.1f",data.maxValue.doubleValue]];
            }
            if(data.testStringValue!=nil)
            {
                [cell.bar setTestValue:data.testStringValue];
            }
            else
            {
                [cell.bar setTestValue:[NSString stringWithFormat:@"%3.1f",data.testValue.doubleValue]];
            }
            [cell.bar setLevel:data.level];
            
            return cell;
        }
        return nil;
    }
    NormalAnalysisTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NormalAnalysisTableViewCell" forIndexPath:indexPath];
    
    AnalyseDetailData* data = nil;
    NSInteger row = indexPath.row;
    if(self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row<row)
    {
        row = row - 1;
    }
    if(indexPath.section==0 && row<self.normalDatas.count)
    {
        data = [self.normalDatas objectAtIndex:row];
    }
    else if(row<self.abnormalDatas.count)
    {
        data = [self.abnormalDatas objectAtIndex:row];
    }
    if(data!=nil)
    {
        UIButton* name =(UIButton*)[cell viewWithTag:100];
        [name setTitle:data.title forState:UIControlStateNormal];
        UILabel* num =(UILabel*)[cell viewWithTag:200];
        if(data.testStringValue!=nil)
        {
            [num setText:data.testStringValue];
        }
        else
        {
            [num setText:[NSString stringWithFormat:@"%3.1f",data.testValue.doubleValue]];
        }
        UIButton* status =(UIButton*)[cell viewWithTag:400];
        [status setTitle:data.levelTitle forState:UIControlStateNormal];
        [cell.unitLabel setText:data.unit];
        
        if(data.level<3)
        {
            NSString* imgName=[data.title isEqual:@"内脏脂肪"]?@"12_lower":@"12_normal";
            
            if(data.level==0)
            {
                imgName=[data.title isEqual:@"内脏脂肪"]?@"12_normal":@"12_lower";
            }
            else if(data.level==2)
            {
                imgName=@"12_overweight";
            }
            [status setBackgroundColor:nil];
            [status setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        }
        else if(data.level<=colors.count)
        {
            NSString* imgName=@"s6";
            
            if(data.level==3)
            {
                imgName=@"s4";
            }
            else if(data.level==4)
            {
                imgName=@"s5";
            }
            [status setBackgroundColor:nil];
            [status setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            
            /*
            [status setBackgroundImage:nil forState:UIControlStateNormal];
            UIColor* color=[colors objectAtIndex:data.level];
            [status setBackgroundColor:color];
            */
        }
        //cell.titleButton.tag = indexPath.section * 1000+indexPath.row;
        cell.delegate = self;
        return cell;
    }
    return nil;
}

-(void)NormalAnalysisCellTitleButtonClick:(UITableViewCell *)cell
{
    NSIndexPath* indPath = [self.analysisTableView  indexPathForCell:cell];
    if ([self selectedIndexPathIsAlloced])
    {
        NSIndexPath * indP = [NSIndexPath indexPathForRow:indPath.row+1 inSection:indPath.section];
        self.selectedIndexPath = indP;
        [self addCellAtIndexPath:indP];
        NSLog(@"component analyse cell add: %ld-%ld", indP.section,indP.row);
        return;
    }
    else
    {
        if (indPath.row+1 == self.selectedIndexPath.row && indPath.section == self.selectedIndexPath.section) {
            NSIndexPath * indP = [NSIndexPath indexPathForRow:indPath.row+1 inSection:indPath.section];
            [self selectedIndexAlloc];
            [self deleteCellAtIndexPath:indP];
            
            return ;
        }
        
        NSIndexPath * tempIndex = [NSIndexPath indexPathForRow:self.selectedIndexPath.row inSection:self.selectedIndexPath.section];
        NSIndexPath * indP;
        if(tempIndex.row<indPath.row && tempIndex.section==indPath.section)
        {
            indP = [NSIndexPath indexPathForRow:indPath.row inSection:indPath.section];
        }
        else
        {
            indP = [NSIndexPath indexPathForRow:indPath.row+1 inSection:indPath.section];
        }
        NSLog(@"component analyse cell insert: %ld-%ld", indP.section,indP.row);
        [self selectedIndexAlloc];
        //[self.analysisTableView beginUpdates];
        [self deleteCellAtIndexPath:tempIndex];
        self.selectedIndexPath = indP;
        [self addCellAtIndexPath:indP];
        //[self.analysisTableView reloadData];
        //[self.analysisTableView reloadSections:[[NSIndexSet alloc] initWithIndex:indP.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[self.analysisTableView endUpdates];
    }
}

-(void)deleteCellAtIndexPath:(NSIndexPath*)index
{
    NSMutableArray * indexArray = [NSMutableArray arrayWithCapacity:0];
    [indexArray addObject:index];
    [self.analysisTableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
}

-(void)addCellAtIndexPath:(NSIndexPath*)index
{
    NSMutableArray * indexArray = [NSMutableArray arrayWithCapacity:0];
    [indexArray addObject:index];
    [self.analysisTableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    [self.analysisTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

@implementation AnalyseDetailData

@synthesize maxValue;
@synthesize minValue;
@synthesize testValue;
@synthesize description;
@synthesize unit;
@synthesize displayItems;
@synthesize levelTitle;
@synthesize testStringValue;

@end
