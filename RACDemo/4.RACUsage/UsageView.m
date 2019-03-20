//
//  UsageView.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/18.
//  Copyright © 2019年 刘俊杰. All rights reserved.
//

#import "UsageView.h"

@interface UsageView()

@property (nonatomic, strong, readwrite) UIButton *tapBtn;
@end

@implementation UsageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.tapBtn];
    }
    return self;
}

- (void)tapBtnAction:(UIButton *)sender {
    NSLog(@"按钮响应事件%@",sender);
}

- (UIButton *)tapBtn {
    
    if (!_tapBtn) {
        _tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tapBtn.frame = CGRectMake(40, 40, 60, 60);
        _tapBtn.backgroundColor = [UIColor blueColor];
        _tapBtn.tag = 1000;
        [_tapBtn addTarget:self action:@selector(tapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tapBtn;
}

@end
