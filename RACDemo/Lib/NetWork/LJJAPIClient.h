//
//  LJJAPIClient.h
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJJAPIClient : AFHTTPSessionManager

/**
  验证证书是否可信任
 */
+ (instancetype)sharedClient;
@end

NS_ASSUME_NONNULL_END
