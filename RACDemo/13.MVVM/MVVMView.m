//
//  MVVMView.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/25.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "MVVMView.h"

@implementation MVVMView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self ui];
    }
    return self;
}

- (void)ui {
    
    self.userName.frame = CGRectMake(60, 120, self.frame.size.width-120, 60);
    self.passWord.frame = CGRectMake(60, CGRectGetMaxY(self.userName.frame) + 60, self.frame.size.width-120, 60);
    self.loginBtn.frame = CGRectMake(60, CGRectGetMaxY(self.passWord.frame) + 60, self.frame.size.width-120, 60);
    
    [self addSubview:self.userName];
    [self addSubview:self.passWord];
    [self addSubview:self.loginBtn];
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = [UIColor grayColor];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.selected = false;
        [_loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _loginBtn;
}

- (UITextField *)userName {
    if (!_userName) {
        _userName = [[UITextField alloc] initWithFrame:CGRectZero];
        _userName.backgroundColor = [UIColor grayColor];
        _userName.placeholder = @"用户名";
    }
    return _userName;
}

- (UITextField *)passWord {
    if (!_passWord) {
        _passWord = [[UITextField alloc] initWithFrame:CGRectZero];
        _passWord.backgroundColor = [UIColor grayColor];
        _passWord.placeholder = @"密码";
    }
    return _passWord;
}

@end
