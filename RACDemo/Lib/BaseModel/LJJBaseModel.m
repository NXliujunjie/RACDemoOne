//
//  LJJBaseModel.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "LJJBaseModel.h"
#import "LJJNetWork.h"
#import "MVVMModel.h"
#import <YYModel/YYModel.h>
#import "LJJSignalNetWork.h"
#import "LJJModelMethod.h"

@interface LJJBaseModel()<LJJModelMethod>
@end

@implementation LJJBaseModel

- (instancetype)init {
    if (self = [super init]) {
        self.netType = NetType_POST;
        [self networkRequest];
    }
    return self;
}

- (void)networkRequest {
    
    if (self.netType == NetType_POST) {
        NSLog(@"post请求");
        
    }else if (self.netType == NetType_Get) {
        
        _refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[LJJSignalNetWork share] getNetworkUrl:input andDataHandling:^id(id response) {
                return [self dataRreating:response];
            }];
        }] ;
      
        
        _loadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[LJJSignalNetWork share] getNetworkUrl:input andDataHandling:^id(id response) {
                return [self dataRreating:response];
            }];
        }];

    }
}

- (nonnull id)dataRreating:(nonnull id)anyObject {return nil;}
@end
