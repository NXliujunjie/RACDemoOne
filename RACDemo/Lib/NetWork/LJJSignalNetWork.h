//
//  LJJSignalNetWork.h
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

typedef id(^DataHandling)(id);

@interface LJJSignalNetWork : NSObject


/**
    初始化
 */
+(instancetype)share;


/**
 *  GET请求接口，若不指定baseurl，可传完整的url
*/
- (RACSignal *)getNetworkUrl:(NSString *)requestUrl andDataHandling:(DataHandling)dataHandling;

@end

NS_ASSUME_NONNULL_END
