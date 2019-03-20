//
//  RACDisposableVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/18.
//  Copyright © 2019年 刘俊杰. All rights reserved.
//

#import "RACDisposableVC.h"
#import "ReactiveObjC.h"
@interface RACDisposableVC ()

@property (nonatomic, strong)RACDisposable *able;

@end

@implementation RACDisposableVC


- (void)viewDidLoad {
    [super viewDidLoad];
        
    //1.创建信号量
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"创建信号量");
        
        //3.发送信息
        [subscriber sendNext:@"Im send next data"];
        
        self.able = subscriber;
        NSLog(@"那我啥时候运行");
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposable");
        }];
    }];
    
    //2.订阅信号量
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //主动触发 取消订阅
    [disposable dispose];
    
    /*
     情形一:
     1 订阅者被销毁
     2 RACDisposable 调用dispose取消订阅
     
     情形二:
     1 订阅者被强引用,不调用dispose
     2 RACDisposable 不调用dispose
     
     情形三:
     1 在发送订阅的时候会给我们一个RACDisposable对象，我们拿到它，然后调用 [disposable dispose]; 这个方法
     2 就算在强引用订阅者的情况下，主动调用dispose也会调用block
     */
}
@end
