//
//  RACBingVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/20.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "RACBingVC.h"
#import "RACCommandViewModel.h"
#import "RACReturnSignal.h"
@interface RACBingVC ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation RACBingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1、创建信号
    RACSubject *subjectSignal = [RACSubject subject];
    
    //2绑定信号
    RACSignal *single = [subjectSignal bind:^RACSignalBindBlock _Nonnull {
       //返回一个信号
        return ^RACSignal *(id _Nullable value, BOOL *stop){
            return [RACReturnSignal return:value];
        };
    }];
    
    [single subscribeNext:^(id _Nullable x) {
        NSLog(@"收到的数据 %@",x);
    }];
    [subjectSignal sendNext:@"发送消息"];
    
    [self bindOne];
}

- (void)bindOne {
    
}

- (UITextField *)textField {
    
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(100, 200, 300, 60);
        _textField.backgroundColor = [UIColor grayColor];
    }
    return _textField;
}

@end
