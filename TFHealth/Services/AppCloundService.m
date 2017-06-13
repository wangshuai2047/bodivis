//
//  AppCloundService.m
//  TFHealth
//
//  Created by nico on 14-6-22.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "AppCloundService.h"
#import "User.h"
#import "WebServiceProxy.h"
#import "GDataXMLNode.h"
#import "Foundation/NSJSONSerialization.h"
#import "NSData+Base64.h"

static NSString* WebServiceUrlConst=@"https://service.bodivis.com.cn/";
static NSString* WebServiceFileConst=@"AppCloudService.svc";
static NSString* NameSapceConst=@"http://tempuri.org/";

//static NSString* WebServiceUrlConst=@"http://192.168.1.132:8010/";

@implementation AppCloundService

@synthesize methodName=_methodName;
@synthesize objectDelegate;

 -(AppCloundService*)initWidthDelegate:(id<ServiceObjectDelegate>)callback
{
    if(self.init==self)
    {
        self.objectDelegate=callback;
    }
    return self;
}

#pragma mark -- 请求成功
-(void)requestSuccessed:(NSString*)request
{
    NSError* error;
    GDataXMLDocument* doc = [[GDataXMLDocument alloc]initWithXMLString:request options:0 error:&error];
    //NSArray* nodes =[doc nodesForXPath:[NSString stringWithFormat:@"//%@Response/%@Result",self.methodName,self.methodName] error:&error];
    NSDictionary* namespaces = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"http://schemas.xmlsoap.org/soap/envelope/",@"s",
                                @"http://tempuri.org/",@"xmlns",
                                nil];
    
    NSString* path = [NSString stringWithFormat:@"//s:Body/xmlns:%@Response/xmlns:%@Result",self.methodName,self.methodName];
    NSArray* nodes = [doc nodesForXPath:path namespaces:namespaces error:&error];
    if(nodes!=nil && nodes.count>0){
        GDataXMLElement* obj = [nodes objectAtIndex:0];
        NSString* jsonValue = [obj stringValue];
        NSData* data = [jsonValue dataUsingEncoding:NSUTF8StringEncoding ];
        NSDictionary* u=  [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(self.objectDelegate!=NULL&&self.objectDelegate!=nil){
            [self.objectDelegate serviceSuccessed:u pMethod:self.methodName];
        }
    }
}

-(void)requestFailed:(NSString*)request
{
    if(self.objectDelegate!=NULL&&self.objectDelegate!=nil){
        [self.objectDelegate serviceFailed:request pMethod:self.methodName];
    }
}

//上传用户类型，0:手环 1:秤 2:两者都有
-(void) UploadUserDevices:(int)appUserId userType:(NSString*)userType
{
    NSString* servicName=@"SetUserDevicesJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [wsParas addObject:@"userType"];
    [wsParas addObject:userType];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

//上传用户手环运动记录
-(void)UploadUserCoreValue:(int)appUserId ItemId:(int)ItemId ItemName:(NSString*)ItemName StepCount:(int)StepCount KmCount:(float)KmCount CalorieValue:(int)CalorieValue TimeLenght:(int)TimeLenght SleepTimeCount:(int)SleepTimeCount LastCoreStep:(int)LastCoreStep LastCoreCalorieValue:(int)LastCoreCalorieValue CreateTime:(NSDate*)CreateTime
{
    NSDateFormatter* formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSString* servicName=@"UpdateUserCoreValueJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [wsParas addObject:@"ItemId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",ItemId]];
    [wsParas addObject:@"ItemName"];
    [wsParas addObject:ItemName];
    [wsParas addObject:@"StepCount"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",StepCount]];
    [wsParas addObject:@"KmCount"];
    [wsParas addObject:[NSString stringWithFormat:@"%.1f",KmCount]];
    [wsParas addObject:@"CalorieValue"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",CalorieValue]];
    [wsParas addObject:@"TimeLenght"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",TimeLenght]];
    [wsParas addObject:@"SleepTimeCount"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",SleepTimeCount]];
    [wsParas addObject:@"LastCoreStep"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",LastCoreStep]];
    [wsParas addObject:@"LastCoreCalorieValue"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",LastCoreCalorieValue]];
    [wsParas addObject:@"CreateTime"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",[formater stringFromDate:CreateTime]]];
    
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

-(void) UploadDefaultSports:(int)appUserId sportName1:(NSString*)sportName1 sportName2:(NSString*)sportName2 sportName3:(NSString*)sportName3
{
    NSString* servicName=@"UpLoadUserConfigSportsJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [wsParas addObject:@"sportName1"];
    [wsParas addObject:sportName1];
    [wsParas addObject:@"sportName2"];
    [wsParas addObject:sportName2];
    [wsParas addObject:@"sportName3"];
    [wsParas addObject:sportName3];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

-(void)GetUserInfo:(int)userId
{
    NSString* servicName=@"GetUserInfoJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
//    [wsParas addObject:@"1"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

/*删除家庭成员*/
-(void)deleteMemberWithMemberId:(int)userId
{
    NSString* servicName=@"DeleteUserMembersJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"userId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}


-(void)UserLogin:(NSString*)usermail userPassword:(NSString*)password
{
    NSString* servicName=@"LoginJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"Username"];
    [wsParas addObject:usermail];
    [wsParas addObject:@"Password"];
    [wsParas addObject:password];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

-(void)SyncUser:(NSString*)usermail userPassword:(NSString*)password
{
    NSString* servicName=@"GetUserJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"username"];
    [wsParas addObject:usermail];
    [wsParas addObject:@"password"];
    [wsParas addObject:password];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

//同步运动项目及强度系数列表
-(void) GetCoefficients
{
    NSString* servicName=@"GetCoefficientsJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

-(void)languageGetCoefficientsJson:(int)language
{
    NSString* servicName=@"LanguageGetCoefficientsJson";
    self.methodName=servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"language"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",language]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

//添加用户成员
-(void) AddMembers:(int)appUserId userIco:(NSData*)icodata nick:(NSString*)name userHeight:(int)height userWeight:(int)weight userSex:(int)sex userAge:(int)age userType:(NSString*)utype relationshipName:(NSString*)rName addTime:(NSString*) aTime
{
    NSString* servicName=@"AddMembersJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    NSString *endata = [icodata base64Encoding];
//    NSLog(@"Base64编码:%@", endata);
    NSData *imgdata = nil;
    
    if (endata!=nil) {
        imgdata = [NSData dataWithBase64EncodedString:endata];
    }
    
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [wsParas addObject:@"userIco"];
    if (endata!=nil) {
        [wsParas addObject:endata];
    }
    else
    {
        [wsParas addObject:@""];
    }
    [wsParas addObject:@"nickName"];
    [wsParas addObject:name];
    [wsParas addObject:@"userHeight"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",height]];
    [wsParas addObject:@"weight"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",weight]];
    [wsParas addObject:@"sex"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",sex]];
    [wsParas addObject:@"birthday"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",age]];
    [wsParas addObject:@"memberType"];
    [wsParas addObject:utype];
    [wsParas addObject:@"relationshipName"];
    [wsParas addObject:rName];
    [wsParas addObject:@"addTime"];
    [wsParas addObject:aTime];
    
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

//注册用户信息
-(void)RegisterUser:(NSString*)usermail userPassword:(NSString*)password
{
    NSString* servicName=@"RegisterJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"Username"];
    [wsParas addObject:usermail];
    [wsParas addObject:@"Password"];
    [wsParas addObject:password];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}
/*获取运动建议 性别（1男2女） 体脂百分比  肌肉  肌肉正常范围的均值  肌肉正常范围下限（上限加下限除以2）  年龄  周减重目标*/
-(void)getSportPrescription:(int)appUserId sex:(int)sex pbf:(float)pbfValue muscle:(float)muscle m1:(float)m1 m2:(float)m2 age:(int)age weeksubtact:(float)weeksubtact
{
    NSString *servicName = @"GetSportPrescriptionJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [ssParas addObject:@"sex"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",sex]];
    [ssParas addObject:@"pbf"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",pbfValue]];
    [ssParas addObject:@"muscle"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",muscle]];
    [ssParas addObject:@"m1"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",m1]];
    [ssParas addObject:@"m2"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",m2]];
    [ssParas addObject:@"age"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",age]];
    [ssParas addObject:@"swl"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",weeksubtact]];
    
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

-(void)tempGetSportPrescription:(int)appUserId sex:(int)sex pbf:(float)pbfValue muscle:(float)muscle m1:(float)m1 m2:(float)m2 age:(int)age weeksubtact:(float)weeksubtact language:(int)language
{
    NSString *servicName = @"TempGetSportPrescriptionJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [ssParas addObject:@"sex"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",sex]];
    [ssParas addObject:@"pbf"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",pbfValue]];
    [ssParas addObject:@"muscle"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",muscle]];
    [ssParas addObject:@"m1"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",m1]];
    [ssParas addObject:@"m2"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",m2]];
    [ssParas addObject:@"age"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",age]];
    [ssParas addObject:@"swl"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",weeksubtact]];
    [ssParas addObject:@"language"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",language]];
    
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}


-(void)userSportIdeaInfoJson:(int)appUserId language:(int)language
{
    NSString *servicName = @"userSportIdeaInfoJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [ssParas addObject:@"language"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",language]];
    
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

/*获取营养建议 性别（1男2女） 体脂百分比  肌肉  肌肉正常范围的均值  肌肉正常范围下限（上限加下限除以2）  周减重目标  运动减重百分比　膳食减重百分比*/
-(void)getFoodPrescription:(int)appUserId sex:(int)sex pbf:(float)pbfValue muscle:(float)muscle m1:(float)m1 m2:(float)m2 weeksubtact:(float)weeksubtact sporttarget:(float)sporttarget foodtarget:(float)foodtarget
{
    NSString *servicName = @"DietPrescriptionJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [ssParas addObject:@"sex"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",sex]];
    [ssParas addObject:@"pbf"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",pbfValue]];
    [ssParas addObject:@"muscle"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",muscle]];
    [ssParas addObject:@"m1"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",m1]];
    [ssParas addObject:@"m2"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",m2]];
    [ssParas addObject:@"swl"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",weeksubtact]];
    [ssParas addObject:@"eProportion"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",sporttarget]];
    [ssParas addObject:@"dProportion"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",foodtarget]];
    
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

-(void)TempgetFoodPrescription:(int)appUserId sex:(int)sex pbf:(float)pbfValue muscle:(float)muscle m1:(float)m1 m2:(float)m2 weeksubtact:(float)weeksubtact sporttarget:(float)sporttarget foodtarget:(float)foodtarget language:(int)language
{
    NSString *servicName = @"TempDietPrescriptionJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [ssParas addObject:@"sex"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",sex]];
    [ssParas addObject:@"pbf"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",pbfValue]];
    [ssParas addObject:@"muscle"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",muscle]];
    [ssParas addObject:@"m1"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",m1]];
    [ssParas addObject:@"m2"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",m2]];
    [ssParas addObject:@"swl"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",weeksubtact]];
    [ssParas addObject:@"eProportion"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",sporttarget]];
    [ssParas addObject:@"dProportion"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",foodtarget]];
    [ssParas addObject:@"language"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",language]];
    
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

-(void)NewDietPrescriptionJson:(int)appUserId language:(int)language
{
    //1、简体中文  2、英文
    NSString *servicName = @"NewDietPrescriptionJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [ssParas addObject:@"language"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",language]];
    
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
    
}

/* 更新个人设置  用户编号 目标体重  周减重量   运动减重占比   膳食减重占比  睡眠时长 步伐长度 目标步伐数 提醒时间 */
-(void)addAndUpdatePersonalSet:(int)userId targetWeight:(float)targetWeight weekSubTarget:(float)weekSubTarget sportProp:(float)sportProp foodProp:(float)foodProp  sleepTimeLength:(NSString*)sleepTimeLength stepLength:(int)stepLength stepCount:(int)stepCount alertTime:(NSString*)alertTime{
    NSString *servicName = @"addAndUpdatePersonalSetJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [ssParas addObject:@"targetWeight"];
    [ssParas addObject:[NSString stringWithFormat:@"%.1f",targetWeight]];
    [ssParas addObject:@"weekSubTarget"];
    [ssParas addObject:[NSString stringWithFormat:@"%.1f",weekSubTarget]];
    [ssParas addObject:@"sportProp"];
    [ssParas addObject:[NSString stringWithFormat:@"%.1f",sportProp]];
    [ssParas addObject:@"foodProp"];
    [ssParas addObject:[NSString stringWithFormat:@"%.1f",foodProp]];
    [ssParas addObject:@"sleepTimelength"];
    [ssParas addObject:sleepTimeLength];
    [ssParas addObject:@"stepLength"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",stepLength]];
    [ssParas addObject:@"stepCount"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",stepCount]];
    [ssParas addObject:@"alertTime"];
    [ssParas addObject:alertTime];
    
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
    
    
}

//-返回膳食分类列表-刘飞添加-7.12
-(void)getFoodClass
{
    NSString* servicName=@"GetFoodClassJson";
    self.methodName=servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:nil callbackInstance:self];
}

-(void)LanguageGetFoodClass:(int)language
{
    NSString* servicName=@"LanguageGetFoodClassJson";
    self.methodName=servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"language"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",language]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

//-返回膳食字典列表，具体食物-刘飞添加-7.12
-(void)getFoodDictionary
{
    NSString* servicName=@"GetFoodDictionaryJson";
    self.methodName=servicName;
     [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:nil callbackInstance:self];
}
-(void)LanguageGetFoodDictionary:(int)language
{
    NSString* servicName=@"LanguageGetFoodDictionaryJson";
    self.methodName=servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"language"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",language]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

//-返回用户膳食记录 -刘飞-7.13
-(void)getUserDiliyFoodWithUserId:(int)userId {
    NSString *servicName = @"GetUserDaliyFoodJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}
/* 上传用户膳食记录  用户编号  膳食编号  摄入总量   摄入卡路里   摄入日期  类型：早中晚餐  -刘飞-7.13 */
-(void)uploadFoodInfoWithUserId:(int)userId foodId:(int)foodId intakeValue:(NSString *)takeValue calorieValuer:(NSString *)calorieValue intakeDate:(NSString *)date andType:(NSString *)type {
    NSString *servicName = @"UploadFoodInfoJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [ssParas addObject:@"foodId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",foodId]];
    [ssParas addObject:@"intakeValue"];
    [ssParas addObject:takeValue];
    [ssParas addObject:@"calorieValue"];
    [ssParas addObject:calorieValue];
    [ssParas addObject:@"intakeDate"];
    [ssParas addObject:date];
    [ssParas addObject:@"type"];
    [ssParas addObject:type];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
    
    
}
/* 添加自定义膳食   用户编号  膳食分类   膳食名称  单位摄入量卡路里  单位摄入量  是否自定义项目 0-否 1-是*/
//刘飞 7.16
-(void)addCustomsFoodWithUserId:(int)userId classId:(int)classId foodName:(NSString *)foodName caloriesValue:(float)caloriesValue gramValue:(float)gramValue isCustoms:(int)isCustom {
    NSString *servicName = @"AddCustomsFoodJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [ssParas addObject:@"ClassId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",classId]];
    [ssParas addObject:@"FoodName"];
    [ssParas addObject:foodName];
    [ssParas addObject:@"CaloriesValue"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",caloriesValue]];
    [ssParas addObject:@"GramValue"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",gramValue]];
    [ssParas addObject:@"IsCumtoms"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",isCustom]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

/* 修改用户膳食记录  用户编号  膳食编号  摄入总量   摄入卡路里   摄入日期  类型：早中晚餐*/
-(void)updateFoodInfoWithUserId:(int)userId foodId:(int)foodId intakeValue:(NSString *)takeValue calorieValuer:(NSString *)calorieValue intakeDate:(NSString *)date andType:(NSString *)type newIntakeValue:(NSString*)newIntakeValue newCalorieValue:(NSString*)newCalorieValue newType:(NSString*)newType{
    NSString *servicName = @"UpdateFoodInfoJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [ssParas addObject:@"foodId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",foodId]];
    [ssParas addObject:@"intakeValue"];
    [ssParas addObject:takeValue];
    [ssParas addObject:@"calorieValue"];
    [ssParas addObject:calorieValue];
    [ssParas addObject:@"intakeDate"];
    [ssParas addObject:date];
    [ssParas addObject:@"type"];
    [ssParas addObject:type];
    [ssParas addObject:@"newIntakeValue"];
    [ssParas addObject:newIntakeValue];
    [ssParas addObject:@"newCalorieValue"];
    [ssParas addObject:newCalorieValue];
    [ssParas addObject:@"newType"];
    [ssParas addObject:newType];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}


//删除膳食记录
-(void)deleteFoodInfoWithUserId:(int)userId foodId:(int)foodId intakeValue:(NSString *)takeValue calorieValuer:(NSString *)calorieValue intakeDate:(NSString *)date andType:(NSString *)type
{
    NSString *servicName = @"DeleteFoodByIdJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [ssParas addObject:@"foodId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",foodId]];
    [ssParas addObject:@"intakeValue"];
    [ssParas addObject:takeValue];
    [ssParas addObject:@"calorieValue"];
    [ssParas addObject:calorieValue];
    [ssParas addObject:@"intakeDate"];
    [ssParas addObject:date];
    [ssParas addObject:@"type"];
    [ssParas addObject:type];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

/* 添加自定义运动项目 用户编号 运动名称 单位（组，个，分钟） 单位时间消耗卡路里 单位时间 是否自定义项目 备注 */
-(void)addCustomsSportItemWithUserId:(int)userId sportName:(NSString *)sportName uint:(NSString *)uint caloriesValue:(float)caloriesValue timeSpan:(int)timeSpan isCustoms:(int)isCustom remarks:(NSString *)remarks {
    
    NSString *servicName = @"AddCustomsSportItemJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [ssParas addObject:@"SportName"];
    [ssParas addObject:sportName];
    [ssParas addObject:@"Uint"];
    [ssParas addObject:uint];
    [ssParas addObject:@"CaloriesValue"];
    [ssParas addObject:[NSString stringWithFormat:@"%.2f",caloriesValue]];
    [ssParas addObject:@"TimeSpan"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",timeSpan]];
    [ssParas addObject:@"IsCumtoms"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",isCustom]];
    if (remarks) {
        [ssParas addObject:@"Remarks"];
        [ssParas addObject:remarks];
    }
    
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
    
}
/* 上传用户运动项目 */

-(void)uploadSportWithUserId:(int)userId sportId:(int)sportId movementTime:(int)movementTime calorie:(NSString *)cal sportDate:(NSString *)sportDate {
    NSString *servicName = @"UploadSportInfoJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [ssParas addObject:@"sportId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",sportId]];
    [ssParas addObject:@"movementTime"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",movementTime]];
    [ssParas addObject:@"cal"];
    [ssParas addObject:cal];
    [ssParas addObject:@"sportDate"];
    [ssParas addObject:sportDate];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
    
}


/*
    请求系统运动项目
 */

-(void)getSportItems {
    NSString *servicName = @"GetSportItemsJson";
    self.methodName = servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:nil callbackInstance:self];
}
-(void)languageGetSportItems:(int)language {
    NSString *servicName = @"LanguageGetSportItemsJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"language"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",language]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

//获取对应用户好友/伙伴  -刘飞 7.14
-(void)getUserFriendsWithUserId:(int)userId {
    
    NSString *servicName = @"GetUserFriendsJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

//获取活跃用户
-(void)getActivityUsersWithUserId:(int)userId {
    NSString *servicName = @"GetActiveUsersJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}
//获取与我相似用户
-(void)getLikeUsersWithUserId:(int)userId {
    NSString *servicName = @"GetLikeUsersJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

#pragma mark - 获取排行榜
-(void)getBeatPercentageUserId:(int)userId {
    NSString *servicName = @"BeatPercentageJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

-(void)addFriendWithUserId:(int)userId friendId:(int)friendId time:(NSDate *)date {
    NSString *servicName = @"AddFriendsJson";
    self.methodName = servicName;
    NSMutableArray *ssParas = [NSMutableArray arrayWithCapacity:0];
    [ssParas addObject:@"appUserId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [ssParas addObject:@"friendsId"];
    [ssParas addObject:[NSString stringWithFormat:@"%d",friendId]];
    [ssParas addObject:@"createTime"];
    [ssParas addObject:[NSString stringWithFormat:@"%@",date]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:ssParas callbackInstance:self];
}

#pragma mark - 完善信息
-(void)ImproveUserData:(int)userId userIco:(NSData*)icodata nick:(NSString*)name userAge:(int)age userSex:(int)sex userHeight:(int)height remark:(NSString*)remark
{
    //NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"原NSString转为data:%@", data);
    
    NSString *endata = [icodata base64Encoding];
//    NSLog(@"Base64编码:%@", endata);
    NSData *imgdata = [NSData dataWithBase64EncodedString:endata];
    NSString* servicName=@"PerfectUserInfoJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [wsParas addObject:@"userIco"];
    [wsParas addObject:endata];
    [wsParas addObject:@"nickName"];
    [wsParas addObject:name];
    [wsParas addObject:@"sex"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",sex]];
    [wsParas addObject:@"height"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",height]];
    [wsParas addObject:@"birthday"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",age]];
    [wsParas addObject:@"remark"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",remark]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

-(void)uploadUserItemInfo:(int)userId cId:(int)cId itemId:(int)itemId testDate:(NSDate*)date testValue:(NSNumber*)testValue
{
    NSDateFormatter* formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString* servicName=@"UploadUserItemsJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [wsParas addObject:@"CID"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",cId]];
    [wsParas addObject:@"itemId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",itemId]];
    [wsParas addObject:@"itemValue"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",testValue]];
    [wsParas addObject:@"summary"];
    [wsParas addObject:@"none"];
    [wsParas addObject:@"testDate"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",[formater stringFromDate:date]]];
    [wsParas addObject:@"macModel"];
    [wsParas addObject:@"4"];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

-(void)uploadCompositeScore:(int)userId score:(NSNumber*)score testDate:(NSDate*)date
{
    NSDateFormatter* formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString* servicName=@"UploadCompositeScoreJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [wsParas addObject:@"score"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",score]];
    [wsParas addObject:@"summary"];
    [wsParas addObject:@"none"];
    [wsParas addObject:@"testDate"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",[formater stringFromDate:date]]];
    [wsParas addObject:@"Remark"];
    [wsParas addObject:@"none"];
    [wsParas addObject:@"syncStatus"];
    [wsParas addObject:@"0"];
    
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

-(void)UploadUserTestDataByJson:(NSString*)testData
{
    NSString* servicName=@"UploadUserTestDataByJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"testDataJson"];
    [wsParas addObject:testData];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];

}

/**
 @brief 获取用户所有综合得成成绩
 */
-(void)getUserCompInfo:(int)userId
{
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    NSString* servicName=@"GetUserCompInfoJson";
    self.methodName=servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

/**
 @brief 获取用户所有测试项目
 */
-(void)getUserItems:(int)userId
{
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    NSString* servicName=@"GetUserItemsJson";
    self.methodName=servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

/**
 @brief 获取用户所有家人（获取家庭成员）
 */
-(void)getUserMembers:(int)userId
{
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    NSString* servicName=@"GetUserMembersJson";
    self.methodName=servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

/**
 @brief 获取用户所有设备
 */
-(void)getUserDevices:(int)userId
{
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    NSString* servicName=@"GetUserDevicesJson";
    self.methodName=servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

/**
 @brief 获取用户设置信息
 */
-(void)getUserPersonalSetInfo:(int)userId
{
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    NSString* servicName=@"GetUserPersonalSetInfoJson";
    self.methodName=servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

/**
 @brief 获取用户手环运动数据
 */
-(void)getUserCoreValue:(int)userId
{
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    NSString* servicName=@"GetUserCoreValueJson";
    self.methodName=servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

-(void)shareTestInfo:(int)appUserId weight:(double) weight stateIndex:(double) stateIndex fatRate:(double) fatRate fat:(double) fat muscle:(double) muscle water:(double) water bone:(double) bone protein:(double) protein stepcount:(int)stepcount burnCalories:(double) burnCalories
{
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [wsParas addObject:@"weight"];
    [wsParas addObject:[NSString stringWithFormat:@"%f",weight]];
    [wsParas addObject:@"stateIndex"];
    [wsParas addObject:[NSString stringWithFormat:@"%f",stateIndex]];
    [wsParas addObject:@"fatRate"];
    [wsParas addObject:[NSString stringWithFormat:@"%f",fatRate]];
    [wsParas addObject:@"fat"];
    [wsParas addObject:[NSString stringWithFormat:@"%f",fat]];
    [wsParas addObject:@"muscle"];
    [wsParas addObject:[NSString stringWithFormat:@"%f",muscle]];
    [wsParas addObject:@"water"];
    [wsParas addObject:[NSString stringWithFormat:@"%f",water]];
    [wsParas addObject:@"bone"];
    [wsParas addObject:[NSString stringWithFormat:@"%f",bone]];
    [wsParas addObject:@"protein"];
    [wsParas addObject:[NSString stringWithFormat:@"%f",protein]];
    [wsParas addObject:@"stepcount"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",stepcount]];
    [wsParas addObject:@"burnCalories"];
    [wsParas addObject:[NSString stringWithFormat:@"%f",burnCalories]];
    NSString* servicName=@"ShareTestInfoJson";
    self.methodName=servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

//获取是否显示检测版本功能
-(void)isShowAppVersionDetectionAction
{
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    NSString* servicName=@"isOpenCheckVersionJson";
    self.methodName=servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

//检测版本
-(void)appVersionDetectionWithAppType
{
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appType"];
    [wsParas addObject:[NSString stringWithFormat:@"1"]];
    NSString* servicName=@"GetAppVersionJson";
    self.methodName=servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

//广告启动页
-(void)getAdLaunchInfo{
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    NSString* servicName=@"getAdverInfoJson";
    self.methodName=servicName;
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
}

//通过时间区间查询获取用户数据  type:1每周，2每月，3每季，4每年
/**
 @brief 通过时间区间查询获取用户数据
 */
-(void)GetUserItemsByDateJsonWithappUserId:(int)appUserId  type:(int)type startDate:(NSDate*)startDate endDate:(NSDate*)enDate{
    NSDateFormatter* formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString* servicName=@"GetUserItemsByDateJson";
    self.methodName=servicName;
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",appUserId]];
    [wsParas addObject:@"queryType"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",type]];
    [wsParas addObject:@"starttime"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",[formater stringFromDate:startDate]]];
    [wsParas addObject:@"endtime"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",[formater stringFromDate:enDate]]];
    [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];

}

/*
 -(void)uploadUserItemInfo:(int)userId cId:(int)cId itemId:(int)itemId testDate:(NSDate*)date testValue:(NSNumber*)testValue
 {
 NSDateFormatter* formater=[[NSDateFormatter alloc] init];
 [formater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
 NSString* servicName=@"UploadUserItemsJson";
 self.methodName=servicName;
 NSMutableArray* wsParas=[[NSMutableArray alloc] init];
 [wsParas addObject:@"appUserId"];
 [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
 [wsParas addObject:@"CID"];
 [wsParas addObject:[NSString stringWithFormat:@"%d",cId]];
 [wsParas addObject:@"itemId"];
 [wsParas addObject:[NSString stringWithFormat:@"%d",itemId]];
 [wsParas addObject:@"itemValue"];
 [wsParas addObject:[NSString stringWithFormat:@"%@",testValue]];
 [wsParas addObject:@"summary"];
 [wsParas addObject:@"none"];
 [wsParas addObject:@"testDate"];
 [wsParas addObject:[NSString stringWithFormat:@"%@",[formater stringFromDate:date]]];
 [wsParas addObject:@"macModel"];
 [wsParas addObject:@"4"];
 [WebServiceProxy getSOAP11WebServiceResponseAsync:WebServiceUrlConst webServiceFile:WebServiceFileConst xmlNameSpace:NameSapceConst webServiceName:servicName wsParameters:wsParas callbackInstance:self];
 }

 */

@end
