//
//  WZMPullListViewController.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/11.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMPullListViewController.h"
#import "WZMViewHandle.h"
#import "WZMTextInfo.h"
#import "WZMRefresh.h"

@interface WZMPullListViewController ()

@end

@implementation WZMPullListViewController{
    UIView *_badView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UITableView *)superTableView {
    if (_superTableView == nil) {
        _superTableView = [[UITableView alloc] initWithFrame:CGRectNull style:[self tableViewStyle]];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 11.0, *)) {
            _superTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
#else
        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
        _superTableView.wzm_header = [WZMRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
        _superTableView.wzm_footer = [WZMRefreshFooterView footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
//        [_superTableView.wzm_header beginRefresh];
        [self refreshHeader];
    }
    return _superTableView;
}

//UITableViewStyle
- (UITableViewStyle)tableViewStyle {
    return UITableViewStylePlain;
}

- (UICollectionView *)superCollectionView {
    if (_superCollectionView == nil) {
        _superCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _superCollectionView.backgroundColor = [UIColor whiteColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 11.0, *)) {
            _superCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
#else
        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
        _superCollectionView.wzm_header = [WZMRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
        _superCollectionView.wzm_footer = [WZMRefreshFooterView footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
//        [_superCollectionView.wzm_header beginRefresh];
        [self refreshHeader];
    }
    return _superCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.itemSize = CGSizeMake(100, 100);
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 10;
    }
    return _flowLayout;
}

- (void)refreshHeader {
    [_superDataProvider refreshData];
    [self reloadData];
}

- (void)refreshFooter {
    [self reloadData];
}

//加载数据
- (void)reloadData {
    [_superDataProvider loadData:^{
        [self showLoadingView];
    } callBack:^{
        [self didLoadDataWithResponseResult:_superDataProvider.httpResponseResult];
        [self endRefresh];
    }];
}

//结束加载动画
- (void)endRefresh {
    if (_superTableView) {
        [_superTableView reloadData];
        [_superTableView.wzm_header endRefresh];
        [_superTableView.wzm_footer endRefresh];
    }
    if (_superCollectionView) {
        [_superCollectionView reloadData];
        [_superCollectionView.wzm_header endRefresh];
        [_superCollectionView.wzm_footer endRefresh];
    }
}

//子类如果需要实现自己页面特定的页面加载动画，重载该方法即可
- (void)showLoadingView {
    [WZMViewHandle wzm_showProgressMessage:WZM_LOADING];
}

//子类如果需要实现自己页面特定需求的数据加载后的处理，重载该方法即可
- (void)didLoadDataWithResponseResult:(WZMHttpResponseResult *)responseResult {
    
    BOOL isDataEmpty = [_superDataProvider isDataEmpty];
    _superTableView.hidden = isDataEmpty;
    _superCollectionView.hidden = isDataEmpty;
    [self showBadView:isDataEmpty];
    
    if (responseResult.code == WZMHttpResponseCodeSuccess) {
        [WZMViewHandle wzm_dismiss];
    }
    else {
        [WZMViewHandle wzm_showInfoMessage:responseResult.message];
    }
}

#pragma mark - 加载出错时的处理
- (void)showBadView:(BOOL)show {
    if (_badView) {
        if (show) {
            _badView.hidden = NO;
        }
        else {
            _badView.hidden = YES;
            return;
        }
    }
    else {
        if (show) {
            _badView = [self badView];
        }
        else {
            return;
        }
    }
    if (_badView.superview == nil) {
        [self.view addSubview:_badView];
    }
    if ([self badViewFront]) {
        for (UIView *view in [self badViewFront]) {
            if ([view isKindOfClass:[UIView class]]) {
                [self.view bringSubviewToFront:view];
            }
        }
    }
    for (UIView *subview in _badView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]] && subview.tag == 1) {
            [(UIImageView *)subview setImage:[self badViewImage]];
            continue;
        }
        if ([subview isKindOfClass:[UILabel class]] && subview.tag == 2) {
            NSString *msg = [self badViewMessage];
            if ([NSString wzm_isBlankString:msg]) {
                subview.hidden = YES;
                [(UILabel *)subview setText:@""];
            }
            else {
                subview.hidden = NO;
                [(UILabel *)subview setText:msg];
            }
            continue;
        }
        if (([subview isKindOfClass:[UIButton class]]) && subview.tag == 3) {
            NSString *title = [self badViewActionTitle];
            if ([NSString wzm_isBlankString:title]) {
                subview.hidden = YES;
                [(UIButton *)subview setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                subview.hidden = NO;
                [(UIButton *)subview setTitle:title forState:UIControlStateNormal];
            }
            continue;
        }
    }
}

- (UIView *)badView {
    CGRect rect = [self badViewFrame];
    if (CGRectIsNull(rect)) {
        rect = self.view.bounds;
    }
    _badView = [[UIView alloc] initWithFrame:rect];
    _badView.backgroundColor = [self badViewColor];
    
    CGFloat imageW = _badView.wzm_width/4;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_badView.wzm_width-imageW)/2, _badView.wzm_height/2-imageW-40, imageW, imageW)];
    imageView.tag = 1;
    [_badView addSubview:imageView];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.wzm_maxY+10, _badView.wzm_width, 20)];
    msgLabel.tag = 2;
    msgLabel.textColor = WZM_R_G_B(180, 180, 180);
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.font = [UIFont systemFontOfSize:12];
    [_badView addSubview:msgLabel];
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.tag = 3;
    actionBtn.frame = CGRectMake((_badView.wzm_width-100)/2, msgLabel.wzm_maxY+10, 100, 35);
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    actionBtn.layer.masksToBounds = YES;
    actionBtn.layer.cornerRadius = 5;
    actionBtn.layer.borderColor = THEME_COLOR.CGColor;
    actionBtn.layer.borderWidth = 1;
    [actionBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(badViewAction) forControlEvents:UIControlEventTouchUpInside];
    [_badView addSubview:actionBtn];
    
    return _badView;
}

- (void)badViewAction {
    [self refreshHeader];
}

- (NSString *)badViewActionTitle {
    return @"刷新试试";
}

- (NSString *)badViewMessage {
    if (_superDataProvider.httpResponseResult.code == WZMHttpResponseCodeFail) {
        return WZM_NO_NET;
    }
    return WZM_NO_NET;
}

- (UIImage *)badViewImage {
    if (_superDataProvider.httpResponseResult.code == WZMHttpResponseCodeFail) {
        return [UIImage imageNamed:@"ll_no_net"];
    }
    return [UIImage imageNamed:@"ll_no_data"];
}

- (NSArray<UIView *> *)badViewFront {
    return nil;
}

- (CGRect)badViewFrame {
    return CGRectNull;
}

- (UIColor *)badViewColor {
    return nil;
}

@end
