//
//  RACSignalVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/18.
//  Copyright © 2019年 刘俊杰. All rights reserved.
//

#import "RACSignalVC.h"
#import "ReactiveObjC.h"

@interface RACSignalVC ()

@end

@implementation RACSignalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建信号量
    RACSignal *single = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"创建信号量");
        [subscriber sendNext:@"Im send next data"];
        NSLog(@"那我啥时候运行");
        return nil;
    }];
    
    //订阅信号
    [single subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}
@end
