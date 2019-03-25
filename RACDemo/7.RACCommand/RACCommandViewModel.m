//
//  RACCommandViewModel.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/19.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "RACCommandViewModel.h"
@interface RACCommandViewModel ()

@end

@implementation RACCommandViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self subscriberConmandSignals];
    }
    return self;
}

/**
    懒加载方式来初始化 RACCommand 对象：
 */
- (RACCommand *)requestData {
    if (!_requestData) {
        _requestData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString* input) {
            //NSDictionary *body = @{@"memberCode": input};
            // 进行网络操作，同时将这个操作封装成信号 return
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:input];
                [subscriber sendCompleted];//告诉外界发送完了
                 return nil;
            }];
        }];
    }
    return _requestData;
}

/**
 RACCommand 中封装了各种信号，我们只用到了外层信号（executionSignal）和内层信号。订阅这些信号能够让我们实现两个目的：拿到请求返回的数据、跟踪 RACCommand 开始结束状态。定义一个方法来做这些事情：
 */

/**
 订阅外层信号（即 executionSignals）。外层信号在订阅或执行（即 execute: ）时发送。因此我们可以将它视作请求即将开始之前的信号，在这里将 self.error 清空，将 requestStatus 修改为 begin。
 
 订阅内层信号，因为内层信号由外层信号（executionSignals）作为数据发送（sendNext:），而发送的数据一般是作为 subcribeNext：时的 block 的参数来接收的，因此在这个块中，块的参数就是内层信号。这样我们就可以订阅内层信号了，同时获取数据（保存到 data 属性）并修改 requestStatus 为 end。
 
 RACCommand 比较特殊的一点是 error 信号需要在 errors 中订阅，而不能在 executionSignals 中订阅。在这里我们订阅了 errors 信号，并修改 data、error 和 requestStatus 属性值。
 */
- (void)subscriberConmandSignals {
    
    @weakify(self)
     //1. 订阅外层信号
    [self.requestData.executionSignals subscribeNext:^(RACSignal* innerSignal) {
        @strongify(self)
        // 2. 订阅内层信号
        [innerSignal subscribeNext:^(NSDictionary *x){
            self.data = x;
            self.status = HTTPRequestStatusEnd;
            NSLog(@"11111111");
        }];
        self.error = nil;
        self.status = HTTPRequestStatusBegin ;
    }];
    
     // 3. 订阅 errors 信号
    [self.requestData.errors subscribeNext:^(NSError *_Nullable x){
       @strongify(self)
        self.error = nil;
        self.data = nil;
        self.status = HTTPRequestStatusError;
    }];
}
@end
