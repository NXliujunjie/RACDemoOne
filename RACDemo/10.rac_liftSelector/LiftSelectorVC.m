//
//  LiftSelectorVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/25.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "LiftSelectorVC.h"
#import "ReactiveObjC.h"
@interface LiftSelectorVC ()

@end

@implementation LiftSelectorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     在线程里面一定有一个这样子的例子：同时下载三张图片，三张图片都下载完了，在显示到UI上面。那个时候是使用group，现在来看看RAC是如何做的。
     */
    
    //先创建三个信号
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"%@",[NSThread currentThread]);
        [subscriber sendNext:@"我是图片1"];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"我是图片2"];
        return nil;
    }];
    
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"我是图片3"];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUIPic:pic2:pic3:) withSignalsFromArray:@[signal1, signal2, signal3]];
}

- (void)updateUIPic:(id)pic1 pic2:(id)pic2 pic3:(id)pic3{
    
    NSLog(@"我要加载了 : pic1 - %@ pic2 - %@ pic3 - %@",pic1,pic2,pic3);
    
}


@end
