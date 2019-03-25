//
//  FlatterAndMapVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/25.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "FlatterAndMapVC.h"
#import "ReactiveObjC.h"
#import "RACReturnSignal.h"

@interface FlatterAndMapVC ()

@end

@implementation FlatterAndMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self testOne];
    //[self testTwo];
   // [self testThree];
    
    [self testFour];
}

- (void)testOne {
    
    RACSubject *subject = [RACSubject subject];
    
    RACSignal *signal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [RACReturnSignal return:value];
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"what happend?"];
}

- (void)testTwo {
    
    RACSubject *subject = [RACSubject subject];
    
    [[subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        
        value = [NSString stringWithFormat:@"%@ 你别问我， 我也不知道",value];
        return [RACReturnSignal return:value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [subject sendNext:@"what happend?"];
}

- (void)testThree {
    
    RACSubject *subject = [RACSubject subject];
    [[subject map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%@ 你别问我，我也不知道", value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"what happend?"];
    [subject sendNext:@"what happend?"];
    [subject sendNext:@"what happend?"];
    [subject sendNext:@"what happend?"];
}

/**
 RAC 处理信号中的信号 三种方法
 第一种： 双重订阅
 
 第二种: 订阅最新的信号
 
 第三种: flattenMap
 */
- (void)testFour {
    
   // [self one];
   // [self two];
    [self three];
}

- (void)one {
    
    RACSubject *subjectOfSignal = [RACSubject subject];
    RACSubject * subject = [RACSubject subject];
    [subjectOfSignal subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
    }];
    [subjectOfSignal sendNext:subject];
    [subject sendNext:@"干啥类"];
}

- (void)two {
    
    RACSubject *subjectOfSignal = [RACSubject subject];
    RACSubject *subject1 = [RACSubject subject];
    [subjectOfSignal.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subjectOfSignal sendNext:subject1];
    [subject1 sendNext:@"弄啥嘞"];
}

- (void)three {
    
    RACSubject *subjectOfSignal = [RACSubject subject];
    RACSubject *subject1 = [RACSubject subject];
    [[subjectOfSignal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subjectOfSignal sendNext:subject1];
    [subject1 sendNext:@"弄啥嘞"];
}
@end
