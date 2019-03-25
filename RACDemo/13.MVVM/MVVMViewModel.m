//
//  MVVMViewModel.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/25.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "MVVMViewModel.h"

@interface MVVMViewModel()

@end

@implementation MVVMViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self setUP];
    }
    return self;
}

- (void)setUP {
    
    _btnEnableSignal = [RACSignal combineLatest:@[RACObserve(self,account),RACObserve(self, password)] reduce:^id _Nullable(NSString * account,NSString * password){
        return @(account.length && (password.length > 5));
    }];
    
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"组合参数，准备发送登录请求 - %@", input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"开始请求");
            
            NSLog(@"请求成功");
            
            NSLog(@"处理数据");
            
            [subscriber sendNext:@"请求后的数据"];
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"结束了");
            }];
        }];
        
        return nil;
    }];
}
@end
