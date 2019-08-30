//
//  FirstViewController.m
//  WZMKit
//
//  Created by wangzhaomeng on 07/15/2019.
//  Copyright (c) 2019 wangzhaomeng. All rights reserved.
//

/**********************************************************************************/
/* ↓ WZMNetWorking(网络请求)、WZMRefresh(下拉/上拉控件)、WZMJSONParse(JSON解析)的使用 ↓ */
/**********************************************************************************/

#import "FirstViewController.h"
#import "WZMNewsDataProvider.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    WZMNewsDataProvider *_newDataProvider;
}

@end

@implementation FirstViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第一页";
        _newDataProvider = [[WZMNewsDataProvider alloc] initWithFileName:@"article.json"];
        self.superDataProvider = _newDataProvider;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = self.superTableView;
    _tableView.frame = WZMRectMiddleArea();
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView wzm_cleraExtraLine];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger index = 0;
    for (NSInteger i = 0; i < indexPath.section; i ++) {
        index += [self tableView:tableView numberOfRowsInSection:i];
    }
    index += indexPath.row;
    
    if (index%3 == 0) {
        [WZMViewHandle wzm_showInfoMessage:@"哈哈哈哈"];
    }
    else if (index%3 == 1) {
        [WZMViewHandle wzm_showProgressMessage:@"哈哈哈哈"];
    }
    else {
        [WZMViewHandle wzm_dismiss];
    }
    return;
    
    if (indexPath.row < _newDataProvider.currentList.count) {
        WZMNewsModel *model = _newDataProvider.currentList[index];
        WZMWebViewController *webVC = [[WZMWebViewController alloc] initWithUrl:model.url];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newDataProvider.currentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:10];
    }
    if (indexPath.row < _newDataProvider.currentList.count) {
        WZMNewsModel *model = _newDataProvider.currentList[indexPath.row];
        cell.textLabel.text = model.title;
    }
    return cell;
}

@end
