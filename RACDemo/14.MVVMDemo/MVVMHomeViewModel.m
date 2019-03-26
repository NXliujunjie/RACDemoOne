//
//  MVVMHomeViewModel.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "MVVMHomeViewModel.h"
#import "MVVMModel.h"
#import <YYModel/YYModel.h>

@interface MVVMHomeViewModel()
@end

@implementation MVVMHomeViewModel

-(NetType)netType {
    return NetType_Get;
}

- (nonnull id)dataRreating:(nonnull id)anyObject {
    
    NSMutableArray *dataSources = [[NSMutableArray alloc] init];
    NSDictionary *data = anyObject[@"data"];
    NSArray *elements = data[@"elements"];
    NSDictionary *nullDic = elements[0];
    NSArray *dataArray = nullDic[@"data"];
    NSArray *nullArray = dataArray[0];
    [nullArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MVVMModel *model = [MVVMModel yy_modelWithJSON:obj];
        [dataSources addObject:model];
    }];
    return dataSources;
}
@end
