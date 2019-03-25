//
//  RACTupleAndSequence.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/21.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "RACTupleAndSequence.h"
#import "ReactiveObjC.h"

@interface RACTupleAndSequence ()

@end

@implementation RACTupleAndSequence

- (void)viewDidLoad {
    [super viewDidLoad];
   
    /**
     了解过Swift的童鞋肯定知道元祖，在元祖中可以放入任何的数据类型，包括基本数据类型，但是在OC中数组只能存储对象。
     而RAC的Tuple就是把OC的数组进行了一层封装
     */
    
    //创建方法:
    [RACTuple tupleWithObjects:@"大吉大利",@"今晚吃鸡",@"666666", nil];
    [RACTuple tupleWithObjectsFromArray:@[@"大吉大利",@"今晚吃鸡"]];
    [RACTuple tupleWithObjectsFromArray:@[@"大吉大利",@"今晚吃鸡"] convertNullsToNils: YES];
    
    //使用:
//    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"大吉大利",@"今晚吃鸡"] convertNullsToNils:YES];
//    id value = tuple[0];
//    id value2 = tuple.first;
//    NSLog(@"1:%@, %@", value, value2);
    
    /**
     然后还有一个类：RACSequence，这个类可以用来代替我们的NSArray或者NSDictionary，主要就是用来快速遍历，和用来字段转模型。
     */
    NSArray * array = @[@"大吉大利",@"今晚吃鸡",@66666,@99999];
    RACSequence * sequence = array.rac_sequence;
    RACSignal *singles = sequence.signal;
    [singles subscribeNext:^(id  _Nullable x) {
       // NSLog(@"2:%@",x);
    }];
    
    /**
     RAC是可以链式调用的，于是又可能写成下面的样子
     */
    NSArray * arrayTwo = @[@"大吉大利",@"今晚吃鸡",@66666,@99999];
    [arrayTwo.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
       // NSLog(@"3:%@",x);
    }];
    
    /**
     代替字典
     */
    NSDictionary * dict = @{@"大吉大利":@"今晚吃鸡",
                            @"666666":@"999999",
                            @"dddddd":@"aaaaaa"
                            };
    [dict.rac_sequence.signal subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"key:%@  value:%@",x[0], x[1]);
        //或
        RACTupleUnpack(NSString *key,id value) = x;
        NSLog(@"key2:%@  value2:%@",key, value);
    }];
}
@end
