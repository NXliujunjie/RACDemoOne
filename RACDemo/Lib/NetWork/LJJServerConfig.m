//
//  LJJServerConfig.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "LJJServerConfig.h"

static NSString *LJJConfigEnv;  //环境参数 00: 测试环境,01: 生产环境


@implementation LJJServerConfig

// env: 环境参数 00: 测试环境 01: 生产环境
+ (void)setLJJConfigEnv:(NSString *)value {
    LJJConfigEnv = value;
}

// 返回环境参数 00: 测试环境 01: 生产环境
+ (NSString *)LJJConfigEnv {
    return LJJConfigEnv;
}

// 获取服务器地址
+ (NSString *)getLJJServerAddr {
    if ([LJJConfigEnv isEqualToString:@"00"]) {
        return @"http://api.breadtrip.com";
    }else{
        return @"http://api.breadtrip.com";
    }
}
@end
