//
//  RACTimerVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/19.
//  Copyright © 2019年 刘俊杰. All rights reserved.
//

#import "RACTimerVC.h"
#import "ReactiveObjC.h"

@interface RACTimerVC ()

@property (nonatomic, strong, readwrite) UIButton *codeBtn;
@property (nonatomic, assign, readwrite) int timer;
@property (nonatomic, strong, readwrite) RACDisposable *disposable;
@end

@implementation RACTimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.codeBtn];
    
    //按钮点击
    @weakify(self)
    [[self.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        x.enabled = false;
        self.timer = 10;
        
        //这个就是RAC中的GCD
        
        /**
         [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]]
         @param 1. 在这个方法里面第一步 是 创建了一个RACSignal 当外部订阅的时候就会调用scheduler的after...方法，在返回的回调中发送数据
         @param 2. after... 内部就是调用的GCD的定时器 定时器的block就是外界传进来的block 创建一个RACDisposable，调用disposable方法等时候就会进入创建对象的block，把定时器释放掉
         @param 3.@weakify(self)，@strongify(self) 解决循环引用，且必须配套使用；
         */
        self.disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
            self.timer --;
            NSString *title = self.timer > 0 ? [NSString stringWithFormat:@"%d",self.timer] : @"发送验证码";
            [self.codeBtn setTitle:title forState:UIControlStateNormal | UIControlStateDisabled];
            self.codeBtn.enabled = (self.timer == 0 ) ? true : false;
            if (self.timer == 0) {
                [self.disposable dispose];
            }
        }];
    }];
    
}

- (UIButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.backgroundColor = [UIColor redColor];
        [_codeBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        _codeBtn.frame  = CGRectMake(0, 0, 200, 200);
        _codeBtn.center = self.view.center;
    }
    return _codeBtn;
}
@end
