//
//  MVVMHomeVC.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import "MVVMHomeVC.h"
#import "MVVMHomeViewModel.h"
#import "MJRefresh.h"
#import "LJJRefreshGifHeader.h"
#import "LJJRefreshGifFooter.h"
#import "MVVMModel.h"
#import "MVVMCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
// 懒加载
#define HT_LAZY(object, assignment) (object = object ?: assignment)

@interface MVVMHomeVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MVVMHomeViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MVVMHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self bindViewModel];
}

- (void)bindViewModel {
    
    self.viewModel = [[MVVMHomeViewModel alloc] init];
    //刷新
    @weakify(self);
    self.tableView.mj_header = [LJJRefreshGifHeader headerWithRefreshingBlock:^{
         @strongify(self);
        [self.viewModel.refreshCommand execute:@"/v2/index/"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    [self.viewModel.refreshCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:x];
        [self.tableView reloadData];
    }];
    
    //加载
    self.tableView.mj_footer = [LJJRefreshGifFooter footerWithRefreshingBlock:^{
         @strongify(self);
         [self.viewModel.loadCommand execute:@"/v2/index/"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    [self.viewModel.loadCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.dataSource addObjectsFromArray:x];
        [self.tableView reloadData];
    }];
    
    [self.viewModel.refreshCommand execute:@"/v2/index/"];
    
}

#pragma mark: -- UITableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MVVMCell *cell = [tableView dequeueReusableCellWithIdentifier:[MVVMCell description] forIndexPath:indexPath];
    MVVMModel *model = self.dataSource[indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    return cell;
}

#pragma mark: -- lazy vars
- (UITableView *)tableView {
    return HT_LAZY(_tableView, ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
        [tableView registerClass:[MVVMCell class] forCellReuseIdentifier:[MVVMCell description]];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor lightGrayColor];
        tableView;
    }));
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
@end
