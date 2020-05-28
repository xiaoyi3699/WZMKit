//
//  WZMSubViewController.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/28.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMSubViewController.h"
#import "WZMSegmentedViewController.h"
#import "WZMNewsDataProvider.h"

@interface WZMSubViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) BOOL allowNotification;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WZMNewsDataProvider *newsDataProvider;

@end

#define notificationKey @"allowNotification"
@implementation WZMSubViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第一页";
        self.allowNotification = YES;
        self.newsDataProvider = [[WZMNewsDataProvider alloc] initWithFileName:@"article.json"];
        self.superDataProvider = self.newsDataProvider;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = self.frame;
    UIView *headerView = [[UIView alloc] initWithFrame:self.superViewController.headerView.bounds];
    
    self.tableView = self.superTableView;
    self.tableView.frame = self.view.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = headerView;
    [self.tableView wzm_cleraExtraLine];
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewOffsetChanged:) name:notificationKey object:nil];
}

- (void)scrollViewOffsetChanged:(NSNotification *)n {
    if (self.allowNotification == NO) {
        self.allowNotification = YES;
        return;
    }
    CGFloat offsetY = [n.object floatValue];
    CGPoint offset = self.tableView.contentOffset;
    if (offsetY > (self.superViewController.headerView.wzm_height - self.fixedHeight)) {
        offset.y = (self.superViewController.headerView.wzm_height - self.fixedHeight);
    }
    else {
        offset.y = offsetY;
    }
    self.tableView.contentOffset = offset;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row;
    for (NSInteger i = 0; i < indexPath.section; i ++) {
        index += [tableView numberOfRowsInSection:i];
    }
    if (indexPath.row < self.newsDataProvider.currentList.count) {
        WZMNewsModel *model = self.newsDataProvider.currentList[indexPath.row];
        WZMWebViewController *webVC = [[WZMWebViewController alloc] initWithUrl:model.newsUrl];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsDataProvider.currentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:10];
    }
    if (indexPath.row < self.newsDataProvider.currentList.count) {
        WZMNewsModel *model = self.newsDataProvider.currentList[indexPath.row];
        cell.textLabel.text = model.newsTitle;
    }
    return cell;
}

- (void)scrollToTop {
    [self.tableView wzm_scrollsToTopAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.superViewController.headerView.wzm_height-offsetY < self.fixedHeight) {
        offsetY = self.superViewController.headerView.wzm_height - self.fixedHeight;
    }
    self.superViewController.headerView.wzm_minY = -offsetY;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL stop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (stop) {
        [self scrollViewDidEndScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 停止类型3
        BOOL stop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (stop) {
            [self scrollViewDidEndScroll];
        }
    }
}

- (void)scrollViewDidEndScroll {
    //结束滑动，刷新偏移量
    self.allowNotification = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationKey object:@(self.tableView.contentOffset.y)];
}

- (BOOL)capturesNavigatonBar {
    return NO;
}

@end
