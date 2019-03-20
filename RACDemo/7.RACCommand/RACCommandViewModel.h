//
//  RACCommandViewModel.h
//  RACDemo
//
//  Created by liujunjie on 2019/3/19.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HTTPRequestStatus) {
    HTTPRequestStatusBegin,
    HTTPRequestStatusEnd,
    HTTPRequestStatusError,
};

@interface RACCommandViewModel : NSObject

@property (nonatomic, assign, readwrite) HTTPRequestStatus status;
@property (nonatomic, strong, readwrite) RACCommand *requestData;
@property (nonatomic, strong, readwrite, nullable) NSDictionary *data;
@property (nonatomic, strong, readwrite, nullable) NSError *error;
@end

NS_ASSUME_NONNULL_END
