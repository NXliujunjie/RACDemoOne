//
//  MVVMVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/25.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "MVVMVC.h"
#import "MVVMView.h"
#import "MVVMViewModel.h"
#import "ReactiveObjC.h"

@interface MVVMVC ()

@property (nonatomic, strong, readwrite) MVVMView *mvvmView;
@property (nonatomic, strong, readwrite) MVVMViewModel *mvvmViewModel;
@end

@implementation MVVMVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.mvvmView];
    [self racBind];
}

- (void)racBind {
    
    RAC(self.mvvmViewModel, account) = self.mvvmView.userName.rac_textSignal;
    RAC(self.mvvmViewModel, password) = self.mvvmView.passWord.rac_textSignal;
    RAC(self.mvvmView.loginBtn, enabled) = self.mvvmViewModel.btnEnableSignal;
   
    //4、数据请求成功
    [self.mvvmViewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
         NSLog(@"数据请求成功: %@",x);
    }];
    
    //3、准备工作都完成啦，现在在按钮点击的时候就执行command
    [[self.mvvmView.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.mvvmViewModel.loginCommand execute:@{@"accound":self.mvvmView.userName.text,@"password":self.mvvmView.passWord.text}];
    }];
}

- (MVVMView *)mvvmView {
    if (!_mvvmView) {
        _mvvmView = [[MVVMView alloc] initWithFrame:self.view.frame];
        _mvvmView.backgroundColor = [UIColor whiteColor];
    }
    return _mvvmView;
}

- (MVVMViewModel *)mvvmViewModel {
    if (!_mvvmViewModel) {
        _mvvmViewModel = [[MVVMViewModel alloc] init];
    }
    return _mvvmViewModel;
}
@end
