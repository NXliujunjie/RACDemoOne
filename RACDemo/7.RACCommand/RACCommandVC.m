//
//  RACCommandVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/19.
//  Copyright © 2019年 刘俊杰. All rights reserved.
//

#import "RACCommandVC.h"
#import "ReactiveObjC.h"
#import "RACCommandViewModel.h"

@interface RACCommandVC () {
    int tag;
}
@property (nonatomic, strong, readwrite) RACCommandViewModel *viewModel;
@property (nonatomic, strong, readwrite) UIButton *btn;
@property (nonatomic, strong, readwrite) UITextView *textView;
@end

@implementation RACCommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _viewModel = [[RACCommandViewModel alloc] init];
    [self.view addSubview:self.btn];
    [self.view addSubview:self.textView];
    [self bindViewModel];

    //[self RACCommandOne];
    //[self RACCommandTwo];
    //[self RACCommandThree];
    //[self RACCommand_One];
    
    tag = 1;
}

/**
 
 RACCommand类用于表示事件的执行，一般来说是在UI上的某些动作来触发这些事件，比如点击一个按钮。RACCommand的实例能够决定是否可以被执行，这个特性能反应在UI上，而且它能确保在其不可用时不会被执行。通常，当一个命令可以执行时，会将它的属性allowsConcurrentExecution设置为它的默认值：NO，从而确保在这个命令已经正在执行的时候，不会同时再执行新的操作。命令执行的返回值是一个RACSignal，因此我们能对该返回值进行next:，completed或error:
 */

- (void)RACCommandOne {
    
    /**
     Command翻译过来就是命令
     */
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
          NSLog(@"执行1");
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"执行3");
            [subscriber sendNext:input];
            return nil;
        }];
    }];
    
    /**
     第一种接收方法
     RACSignal *signal = [command execute:@"开始飞起来"];
     [signal subscribeNext:^(id  _Nullable x) {
     NSLog(@"接收数据1--%@",x);
     }];
     */
    
    /**
     第二种接收方法
     executionSignals就是用来发送信号的信号源，
     需要注意的是这个方法一定要在执行execute方法之前，否则就不起作用了，
     */
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"执行4");
            NSLog(@"接收数据%@",x);
        }];
        NSLog(@"执行2");
    }];
    [command execute:@"发送消息"];
    
}

- (void)RACCommandTwo {
    
    /**
     1.除了上面那个双层订阅，我们还可以用这个switchToLatest
     2.switchToLatest表示的是最新发送的信号
     3.如果想监听到执行完成或者还在执行 [command.executing skip:1] +  [subscriber sendCompleted];
     4.在发送数据之后加上[subscriber sendCompleted]  作用是 发送了数据，并告诉外界发送完成了
     5.skip 忽略的次数，我们这个时候只想忽略第一次
     filter过滤某些
     ignore忽略某些值
     startWith从哪里开始
     skip跳过（忽略）次数
     take取几次值 正序
     takeLast取几次值 倒序
     */
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"我就是数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收数据--%@",x);
    }];
    
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"还在执行");
        }else{
            NSLog(@"执行结束");
        }
    }];
    
    [command execute:@"发送数据"];
}

- (void)RACCommandThree {
    
    /**
     验证一下 switchToLatest表示的是最新发送的信号
     1、先创建5个RACSubject，其中第一个为信号中的信号（也就是发送的数据是信号）
     2、然后我们就订阅信号中的信号（因为我们约定了，发送的是信号，所以接收到的也是信号，既然是信号，那就可以订阅）
     3、监听到执行完成或者还在执行就可以这样子
     */
    RACSubject *signalofsignal = [RACSubject subject];
    RACSubject *signal1= [RACSubject subject];
    RACSubject *signal2= [RACSubject subject];
    RACSubject *signal3= [RACSubject subject];
    RACSubject *signal4= [RACSubject subject];
    
    [signalofsignal subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"signalofsignal 1 : %@",x);
        }];
    }];
    
    [signalofsignal.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"signalofsignal 2 : %@",x);
    }];
    
    [signalofsignal sendNext:signal1];
    [signalofsignal sendNext:signal2];
    [signalofsignal sendNext:signal3];
    [signalofsignal sendNext:signal4];
    
    [signal1 sendNext:@"1"];
    [signal2 sendNext:@"2"];
    [signal3 sendNext:@"3"];
    [signal4 sendNext:@"4"];
}

- (void) RACCommand_One {
    
    /**
     RACCommand 是 RAC 中的最复杂的一个类之一，它也是一种广义上的信号。RAC 中信号其实是一种对象（或者是不同代码块）之间通信机制，在面向对象中，类之间的通信方式主要是方法调用，而信号也是一种调用，只不过它是函数式的，因此信号不仅仅可以在对象之间相互调用（传参），也可以在不同代码块（block）之间进行调用。
     
     一般来说，RAC 中用 RACSignal 来代表信号。一个对象创建 RACSignal 信号，创建信号时会包含一个 block，这个 block 的作用是发送信号给订阅者（类似方法返回值或回调函数）。另一个对象（或同一个对象）可以用这个信号进行订阅，从而获得发送者发送的数据。这个过程和方法调用一样，信号相当于暴露给其它对象的方法，订阅者订阅信号相当于调用信号中的方法（block），只不过返回值的获得变成了通过 block 来获得。此外，你无法直接向 RACSignal 传递参数，要向信号传递参数，需要提供一个方法，将要传递的参数作为方法参数，创建一个信号，通过 block 的捕获局部变量方式将参数捕获到信号的 block 中。
     
     而 RACCommand 不同，RACCommand 的订阅不使用 subscribeNext 方法而是用 execute: 方法。而且 RACCommand 可以在订阅/执行（即 excute:方法）时传递参数。因此当需要向信号传递参数的时候，RACComand 更好用。
     
     此外，RACCommand 包含了一个 executionSignal 的信号，这个信号是对用户透明的，它是自动创建的，由 RACCommand 进行管理。许多资料中把它称之为信号中的信号，是因为这个信号会发送其它信号——即 RACCommand 在初始化的 signalBlock 中创建（return）的信号。这个信号是 RACCommand 创建时由我们创建的，一般是用于处理一些异步操作，比如网络请求等。
     
     executionSignal 信号 叫他外层信号
     signalBlock 中的那个信号（真正执行主要工作的）则叫内层信号
     例子一如下:
     */
}

/**
 UI 需要关心 RACCommand 的开始、完成、失败状态，以便显示隐藏小菊花，同时 UI 需要关心 RACCommand 获取的数据并做展示（这里为了简单起见，直接用 Text View 显示出数据）。这其实是对 ViewModel 中的 data 属性和 requestStatus 属性的监听，因此，接下来的一步就是在 controller 中将 View 和 ViewModel 进行绑定了。绑定的代码如下：
 */

- (void)bindViewModel {
    
      @weakify(self)
    [[RACObserve(_viewModel, status) skip:1] subscribeNext:^(NSNumber* x){
        switch ([x intValue]) {
            case HTTPRequestStatusBegin:
                NSLog(@"开始刷新,展示菊花");
                break;
            case HTTPRequestStatusEnd:
                NSLog(@"结束刷新,隐藏菊花");
                break;
            case HTTPRequestStatusError:
                NSLog(@"数据错误");
                break;
            default:
                break;
        }
    }];
    
    RAC(self.textView, text) = [[RACObserve(_viewModel, data) skip:1] map:^id _Nullable(NSString *value) {
        return value;
    }];
    
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self->tag ++;
        if (self->tag == 1) {
            [self.viewModel.requestData execute:@"1"];
        }else if (self->tag == 2){
             [self.viewModel.requestData execute:@"2"];
        }else{
            [self.viewModel.requestData execute:@"3"];
        }
    }];
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.backgroundColor = [UIColor redColor];
        [_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_btn setTitle:@"点击刷新" forState:UIControlStateNormal];
        _btn.frame  = CGRectMake(0, 150, 200, 60);
    }
    return _btn;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame: CGRectMake(60,300,200,200)];
        _textView.backgroundColor = [UIColor greenColor];
    }
    return _textView;
}

@end
