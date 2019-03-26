//
//  LJJAPIClient.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "LJJAPIClient.h"

@implementation LJJAPIClient

+ (instancetype)sharedClient {
    
    static LJJAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[LJJAPIClient alloc] init];
        /**
         AFSSLPinningModeNone,        //代表无条件信任服务器的证书
         AFSSLPinningModePublicKey,   //代表会对服务器返回的证书中的PublicKey进行验证
         AFSSLPinningModeCertificate, //代表会对服务器返回的证书同本地证书全部进行校验
         */
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}
@end
