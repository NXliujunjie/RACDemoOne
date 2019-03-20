//
//  RACSubjectAndRACReplaySubjectVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/18.
//  Copyright © 2019年 刘俊杰. All rights reserved.
//

#import "RACSubjectAndRACReplaySubjectVC.h"
#import "ReactiveObjC.h"

@interface RACSubjectAndRACReplaySubjectVC ()
@end

@implementation RACSubjectAndRACReplaySubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     RACSignal是不具备发送信号的能力的，但是RACSubject这个类就可以做到订阅／发送为一体。
     之前还提到过RAC三部曲，在RACSuject中同样适用。
     */
    
    /*
     1.创建信号
     调用subject方法内部事创建了一个_disposable取消信号和一个数组_subscribers，这个数组从命名上就可以看出来这个数组是，用来保存订阅者。
     */
    RACSubject *subject = [RACSubject subject];
    
    //测试:先发信息,看是否能收到 : 不能
    [subject sendNext:@"测试:先发信息,看是否能收到"];
    
    
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"1.RACReplaySubject:%@",x);
    }];
   [replaySubject sendNext:@"我先发送数据, 后订阅"];
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"2.RACReplaySubject:%@",x);
    }];
    
    
    
    /*
     2.订阅信号
     这里很简单，创建一个订阅者，然后调用  self subscribe:o]方法
     在RACSignal中也调用了这个方法，但是需要注意的是这两个方法并不是一个方法，内部实现不一样 -> 返回值 RACSubject
     在订阅的时候会把订阅者会把订阅者保存到一开创建RACSubject中的数组_subscribers中去。
     */
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    //再次订阅
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"再次订阅:%@", x);
    }];
    
    /*
     3.发送数据
     这里很简单，创建一个订阅者，然后调用  self subscribe:o]方法
     在RACSignal中也调用了这个方法，但是需要注意的是这两个方法并不是一个方法，内部实现不一样 -> 返回值 RACSubject
     在订阅的时候会把订阅者会把订阅者保存到一开创建RACSubject中的数组_subscribers中去。
     */
     [subject sendNext:@"发送数据"];

    /**
     总结 一
     @param: 1.创建的subject的是内部会创建一个数组_subscribers用来保存所有的订阅者
     @param: 2.订阅信息的时候会创建订阅者，并且保存到数组中
     @param: 3.遍历subject中_subscribers中的订阅者，依次发送信息
     */
    
    /**
     总结二
     @param: 测试:先发信息,不能接收
     @param:订阅多次信号，然后发送数据，我们可以看到收到了两次数据。
     */
    
    /**
     总结三 如果我非要先发送在订阅，并且也要能收到怎么处理呢？
     RACReplaySubject : 继承RACSubject，他的目的就是为例解决上面必须先订阅后发送的问题
     @param: 1 创建信号
     @param: 2.发送信号 代码中在发送之前做了一件事情，把要发送的数据保存到数组中，然后调用父类的发送方法，发送玩了看发送成功了没，成功了就删除数据，避免一个数据多次发送。
     @param:3.订阅信号
     return:1.创建的时候会在父类的基础之上多做一步，创建一个数组用来保存发送的数据,2.发送数据，但是此时发送会失败啊，为什么？因为没有人订阅啊，我发给谁啊,3.订阅信号，先遍历一次保存数据的数组，如果有就执行
     */
}
@end
