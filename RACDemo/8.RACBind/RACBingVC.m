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
#import "ReactiveObjC.h"
#import "RACCommandViewModel.h"
//#import <ReactiveCocoa/RACReturnSignal.h>
#import "RACReturnSignal.h"

@interface RACBingVC ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong, readwrite) UIButton *btn;

@end

@implementation RACBingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     RACSignal的bind的主要过程如下：
     
     创建一个RACSignal的数组，把初始signal添加进去，如果该数组为空，发送complete；数组中任意的signal出现error，都会发送error；数组中任意的signal出现complete，都会让该数组删除该signal。
     订阅初始Signal，获得初始Signal中所有的value，error，complete信息。
     接受到value之后，通过RACStreamBindBlock这个block执行获得一个新的Signal，将这个Signal添加到数组中，并订阅这个signal。这个RACStreamBindBlock执行中会带一个BOOL值，如果BOOL值变成YES，初始Signal的订阅就结束了。
     //参考网址:https://blog.csdn.net/chenyin10011991/article/details/52383433
     */
    
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
    
    [self.view addSubview:self.textField];
    [[_textField.rac_textSignal bind:^RACSignalBindBlock {

        /**
         什么时候调用:
         block作用:表示绑定了一个信号.
         */
        return ^RACSignal *(id value, BOOL *stop){
            /**
             什么时候调用block:当信号有新的值发出，就会来到这个block。
             block作用:做返回值的处理
             做好处理，通过信号返回出去.
             */
            return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
        };
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

- (UITextField *)textField {
    
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(50, 200, 250, 60);
        _textField.backgroundColor = [UIColor grayColor];
    }
    return _textField;
}

@end
