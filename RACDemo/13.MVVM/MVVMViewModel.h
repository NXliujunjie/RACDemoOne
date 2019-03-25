//
//  MVVMViewModel.h
//  RACDemo
//
//  Created by liujunjie on 2019/3/25.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVVMViewModel : NSObject

@property (nonatomic, strong) RACSignal *btnEnableSignal;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) RACCommand *loginCommand;
@end

NS_ASSUME_NONNULL_END
