//
//  FiltrationVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/25.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "FiltrationVC.h"
#import "ReactiveObjC.h"

@interface FiltrationVC ()
@property (nonatomic, strong, readwrite) UITextField *textField;
@end

@implementation FiltrationVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.textField];
    
    /**
     过滤，顾名思义自然是过滤掉我们不想要的数据，在RAC中则是过滤掉不想要的信号。
     举个例子，过滤掉textField前面五个字符
     */
    // [self fillter];
    
    /**
     忽略
     */
   // [self ignore];
    
    
    /**
     ignoreValues 忽略掉所有的值
     */
    //[self ignoreValues];
    
    
    /**
     指定哪些信号 正序
     //takeLast
    */
   // [self take];
    
    /**
     标记 : takeUntil需要一个信号作为标记，当标记的信号发送数据，就停止。
     takeUntil
     */
   // [self takeUntil];
    
    
    /**
     剔除一样的信号
     distinctUntilChanged。
     */
    [self distinctUntilChanged];
}

- (void)distinctUntilChanged {
    
    RACSubject * subject = [RACSubject subject];
    [[subject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"x"];
    [subject sendNext:@"x"];
    [subject sendNext:@"y"];
    [subject sendNext:@"y"];
    
    //还可以忽略数组 字段 但是不能忽略模型
}

- (void)takeUntil {
    
    RACSubject * subject = [RACSubject subject];
    RACSubject * subject1 = [RACSubject subject];
    
    [[subject takeUntil:subject1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    [subject1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    
    [subject1 sendNext:@"停止"];
    
    [subject sendNext:@"4"];
    [subject sendNext:@"5"];
}

- (void)take {
    RACSubject * subject = [RACSubject subject];
    [[[subject take:1] take:4] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    [subject sendNext:@"4"];
    [subject sendNext:@"5"];
    
    //在使用takeLast的使用一定要告诉系统，发送完成了，不然就没效果。
    //[subject sendCompleted];
}

- (void)fillter {
    
    //fillter
    [[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 5;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)ignore {
    
    RACSubject *subject = [RACSubject subject];
    [[[subject ignore:@"a"] ignore:@"a1"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"a"];
    [subject sendNext:@"a1"];
    [subject sendNext:@"b"];
}

- (void)ignoreValues {
    
    RACSubject *subject = [RACSubject subject];
    [[subject ignoreValues] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"a1"];
    [subject sendNext:@"b"];
}

-(UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 200, 200, 60)];
        _textField.backgroundColor = [UIColor lightGrayColor];
    }
    return _textField;
}
@end
