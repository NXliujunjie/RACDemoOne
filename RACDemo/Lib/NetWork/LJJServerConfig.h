//
//  LJJServerConfig.h
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJJServerConfig : NSObject

// env: 环境参数 00: 测试环境 01: 生产环境
+ (void)setLJJConfigEnv:(NSString *)value;

// 返回环境参数 00: 测试环境 01: 生产环境
+ (NSString *)LJJConfigEnv;

// 获取服务器地址
+ (NSString *)getLJJServerAddr;
@end

NS_ASSUME_NONNULL_END
