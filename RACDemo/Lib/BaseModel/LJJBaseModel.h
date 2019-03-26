//
//  LJJBaseModel.h
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

//数据请求类型 默认是Post 可不用设置
typedef NS_OPTIONS(NSUInteger, NetType) {
    NetType_POST, // 1
    NetType_Get, // 2
};

NS_ASSUME_NONNULL_BEGIN

@interface LJJBaseModel : NSObject
@property (nonatomic, strong, readwrite) RACCommand *refreshCommand;//刷新
@property (nonatomic, strong, readwrite) RACCommand *loadCommand;//加载
@property (nonatomic,assign) NetType netType;
@end

NS_ASSUME_NONNULL_END
