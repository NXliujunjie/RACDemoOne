//
//  RACMulticastConnectionVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/19.
//  Copyright © 2019年 刘俊杰. All rights reserved.
//

#import "RACMulticastConnectionVC.h"
#import "ReactiveObjC.h"

@interface RACMulticastConnectionVC ()

@end

@implementation RACMulticastConnectionVC

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self requestDataOne];
    [self requestDataTwo];
}

- (void)requestDataOne {
    
    //在项目中我们一般都会涉及网络请求，在使用RAC进行网络请求的时候我们可以这样子写：
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送网络请求");
        [subscriber sendNext:@"得到网络请求数据"];
        return nil;
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"1 - %@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"2 - %@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"3 - %@",x);
    }];
    /**
     我们先运行一次看看log打印就知道问题所在了。
     发送网络请求
     2017-10-26 14:40:36.766137+0800 RAC[816:321538] 1 - 得到网络请求数据
     2017-10-26 14:40:36.766388+0800 RAC[816:321538] 发送网络请求
     2017-10-26 14:40:36.766503+0800 RAC[816:321538] 2 - 得到网络请求数据
     2017-10-26 14:40:36.766725+0800 RAC[816:321538] 发送网络请求
     2017-10-26 14:40:36.766857+0800 RAC[816:321538] 3 - 得到网络请求数据
     
     打印的数据可以发现进行了三次网络请求，但是在实际开发过程中，我们并不想要请求三次，我们只想请求一次就够了。这个时候就可以用RACMulticastConnection这个类了，RACMulticastConnection其实是一个连接类，连接类的意思就是当一个信号被多次订阅，他可以帮我们避免多次调用创建信号中的block，基本用法如下：
     */
}

- (void)requestDataTwo {
    
    /**
     RACMulticastConnection其实是一个连接类，连接类的意思就是当一个信号被多次订阅，他可以帮我们避免多次调用创建信号中的block，基本用法如下：
     */
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
         NSLog(@"发送网络请求");
         [subscriber sendNext:@"得到网络请求数据"];
         return nil;
    }];
    
    RACMulticastConnection *connect = [signal publish];
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"4 - %@",x);
    }];
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"5 - %@",x);
    }];
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"6 - %@",x);
    }];
    [connect connect];
    /**
     2019-03-19 10:27:40.393991+0800 RACDemo[6401:598639] 发送网络请求
     2019-03-19 10:27:40.394095+0800 RACDemo[6401:598639] 4 - 得到网络请求数据
     2019-03-19 10:27:40.394179+0800 RACDemo[6401:598639] 5 - 得到网络请求数据
     2019-03-19 10:27:40.394269+0800 RACDemo[6401:598639] 6 - 得到网络请求数据
     */
    
    /**
     内部实现
     
     1、创建信号这个步骤就不用在多说了（保存了一个block，didSubscribe）
     2、把信号转化成为一个连接类[signal publish]
     3、在publish方法中首先创建了一个subject然后调用multicast创建了一个连接类，在创建连接类的时候把signal和subject保存了起来。
     - (RACMulticastConnection *)publish {
     RACSubject *subject = [[RACSubject subject] setNameWithFormat:@"[%@] -publish", self.name];
     RACMulticastConnection *connection = [self multicast:subject];
     return connection;
     }
     
     - (RACMulticastConnection *)multicast:(RACSubject *)subject {
     [subject setNameWithFormat:@"[%@] -multicast: %@", self.name, subject.name];
     RACMulticastConnection *connection = [[RACMulticastConnection alloc] initWithSourceSignal:self subject:subject];
     return connection;
     }
     
     - (instancetype)initWithSourceSignal:(RACSignal *)source subject:(RACSubject *)subject {
     NSCParameterAssert(source != nil);
     NSCParameterAssert(subject != nil);
     
     self = [super init];
     
     _sourceSignal = source;
     _serialDisposable = [[RACSerialDisposable alloc] init];
     _signal = subject;
     
     return self;
     }
     
     4、在调用的时候就不是调用原来的signal了，而是调用connect连接类的信号，但是在publish这个方法中我们把subject保存了起来，所以还是在调用subject。
     在init方法中赋值_signal = subject;
     5、在最后的connect方法中，在用之前保存的signal订阅我们保存的subject,也就是说在这里才是真正的订阅了我们的信号，这个时候才会去调用我们最开始保存的didSubscribe这个block，而发送数据的其实是我们在publish中保存的subject，所以就完成了一次创建多次订阅了。
     - (RACDisposable *)connect {
     BOOL shouldConnect = OSAtomicCompareAndSwap32Barrier(0, 1, &_hasConnected);
     
     if (shouldConnect) {
     self.serialDisposable.disposable = [self.sourceSignal subscribe:_signal];
     }
     
     return self.serialDisposable;
     }
     */

}

@end
