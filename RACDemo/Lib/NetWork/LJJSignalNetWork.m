//
//  LJJSignalNetWork.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "LJJSignalNetWork.h"
#import "LJJNetWork.h"

@implementation LJJSignalNetWork

+(instancetype)share {
    return [[self alloc] init];
}

- (RACSignal *)getNetworkUrl:(NSString *)requestUrl andDataHandling:(DataHandling)dataHandling{

    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        LJJURLSessionTask *task = [LJJNetWork getWithUrl:requestUrl refreshCache:YES showHUD:@"加载中..." success:^(id response) {
            if (dataHandling) {dataHandling(response);}
            [subscriber sendNext:dataHandling(response)];
            [subscriber sendCompleted];
        } fail:^(NSError * _Nonnull error) {
           [subscriber sendError:error];
           [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}
@end
