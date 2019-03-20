//
//  ViewController.m
//  RACDemo
//
//  Created by liujunjie on 2019/3/15.
//  Copyright © 2019 . All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"

static UIColor* ljjRandomColor() {
    
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    CGFloat rr = r / 255.0;
    CGFloat rg = g / 255.0;
    CGFloat rb = b / 255.0;
    return [UIColor colorWithRed:rr green:rg blue:rb alpha:1];
}

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) NSArray *dataSource;
@property (nonatomic, strong, readwrite) UIButton *loadDataBtn;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.loadDataBtn];
    [self.view addSubview:self.tableView];
    
    self.title = @"RACDemo";
    [self loadData:^{
        [self.tableView reloadData];
    }];
    
    //刷新
    @weakify(self);
        
    [[self.loadDataBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

- (void)loadData:(void(^)(void))reloadDataBlock{
    self.dataSource = @[@"RACSignalVC",
                        @"RACDisposableVC",
                        @"RACSubjectAndRACReplaySubjectVC",
                        @"RACUsagVC",
                        @"RACTimerVC",
                        @"RACMulticastConnectionVC",
                        @"RACCommandVC"];
    reloadDataBlock();
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell description]
                                                            forIndexPath:indexPath];
    cell.backgroundColor = ljjRandomColor();
    cell.textLabel.text = [NSString stringWithFormat:@"%ld/%@",indexPath.row + 1,self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class class = NSClassFromString(self.dataSource[indexPath.row]);
    id vc = [[class alloc] init];
    UIViewController *vcs  = vc;
    vcs.view.backgroundColor = ljjRandomColor();
    [self.navigationController pushViewController:vcs animated:true];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -75-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UIAccessibilityTraitNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell description]];
    }
    return _tableView;
}

-(UIButton *)loadDataBtn {
    if (!_loadDataBtn) {
        _loadDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadDataBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        _loadDataBtn.backgroundColor = [UIColor grayColor];
        [_loadDataBtn setTitle:@"换个颜色" forState:UIControlStateNormal];
         _loadDataBtn.frame  = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 75, [UIScreen mainScreen].bounds.size.width, 75);
    }
    return _loadDataBtn;
}



@end
