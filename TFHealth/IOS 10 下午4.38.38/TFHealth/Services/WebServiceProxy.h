//
//  WebServiceProxy.h
//  TFHealth
//
//  Created by nico on 14-5-21.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest/ASIHTTPRequest.h"
#import "ServiceCallbackDelegate.h"

@interface WebServiceProxy : NSObject

+ (ASIHTTPRequest *)getASISOAP11Request:(NSString *) WebURL
                         webServiceFile:(NSString *) wsFile
                           xmlNameSpace:(NSString *) xmlNS
                         webServiceName:(NSString *) wsName
                           wsParameters:(NSMutableArray *) wsParas;

+ (NSString *)getSOAP11WebServiceResponse:(NSString *) WebURL
                           webServiceFile:(NSString *) wsFile
                             xmlNameSpace:(NSString *) xmlNS
                           webServiceName:(NSString *) wsName
                             wsParameters:(NSMutableArray *) wsParas;

+ (void)getSOAP11WebServiceResponseAsync:(NSString *) WebURL
                            webServiceFile:(NSString *) wsFile
                              xmlNameSpace:(NSString *) xmlNS
                            webServiceName:(NSString *) wsName
                              wsParameters:(NSMutableArray *) wsParas
                          callbackInstance:(id<ServiceCallbackDelegate>)callback;

+ (NSString *)getSOAP11WebServiceResponseWithNTLM:(NSString *) WebURL
                                   webServiceFile:(NSString *) wsFile
                                     xmlNameSpace:(NSString *) xmlNS
                                   webServiceName:(NSString *) wsName
                                     wsParameters:(NSMutableArray *) wsParas
                                         userName:(NSString *) userName
                                         passWord:(NSString *) passWord;


+ (NSString *)checkResponseError:(NSString *) theResponse;

@end
