//
//  RACUsagVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/18.
//  Copyright © 2019年 刘俊杰. All rights reserved.
//

#import "RACUsagVC.h"
#import "UsageView.h"
#import "ReactiveObjC.h"

@interface RACUsagVC ()
@property (nonatomic, strong, readwrite) UsageView *usageView;
@property (nonatomic, strong, readwrite) UIButton *racBtn;
@end

@implementation RACUsagVC

#pragma GCC diagnostic ignored "-Wundeclared-selector"
- (void)viewDidLoad {
    [super viewDidLoad];    
    [self viewAction];
    [self repleacKVO];
    [self racBtnAction];
}

#pragma mark: <View 上的按钮点击事件>
- (void)viewAction {
    
    [[self.usageView rac_signalForSelector:@selector(tapBtnAction:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"RACUsagVC:%@",x);
        NSLog(@"RACUsagVC:%ld",x.count);
        NSLog(@"RACUsagVC:%@",x[0]);
        UIButton *sender = (UIButton *)x[0];
        NSLog(@"xxxxxTag:%ld",sender.tag);
    }];
    [self.view addSubview:self.usageView];
}

#pragma mark: <KVO>
- (void)repleacKVO {
    
    [RACObserve(self.usageView, frame) subscribeNext:^(id  _Nullable x) {
        NSLog(@"2 - %@",x);
    }];
}

#pragma mark: <按钮点击>
- (void)racBtnAction {
    
    [self.view addSubview:self.racBtn];
    [[self.racBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
        NSLog(@"%ld",x.tag);
    }];
    
    /**
     最关键的代码就是[self addTarget:subscriber action:@selector(sendNext:) forControlEvents:controlEvents];
     @param:self 就是btn本身，因为是btn调用的方法
     @param:然后target是subscriber（订阅者）
     @param:方法是 ：sendNext:
     事件是传入的事件
     return:所以现在按钮的点击方法会通过subscriber去调用sendNext方法,我们之前有提到过，RACSignal，所以这个时候我们订阅他就可以拿到sendNext的值。
     */
}


- (UsageView *)usageView {
    if (!_usageView) {
        _usageView = [[UsageView alloc] init];
        _usageView.frame = CGRectMake(100, 100, 200, 200);
    }
    return _usageView;
}

- (UIButton *)racBtn {
    if (!_racBtn) {
        _racBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _racBtn.backgroundColor = [UIColor yellowColor];
        _racBtn.tag = 999;
        _racBtn.frame = CGRectMake(100, 459, 80, 80);
    }
    return _racBtn;
}

@end
