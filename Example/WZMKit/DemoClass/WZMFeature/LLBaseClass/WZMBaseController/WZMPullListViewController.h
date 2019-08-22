//
//  WZMPullListViewController.h
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/11.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMBaseViewController.h"
#import "WZMBaseDataProvider.h"

@interface WZMPullListViewController : WZMBaseViewController

@property (nonatomic, strong) UITableView *superTableView;
@property (nonatomic, strong) UICollectionView *superCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) WZMBaseDataProvider *superDataProvider;

//UITableViewStyle
- (UITableViewStyle)tableViewStyle;
//刷新数据
- (void)refreshHeader;
//加载更多
- (void)refreshFooter;
//加载中的动画
- (void)showLoadingView;
//加载后的处理
- (void)didLoadDataWithResponseResult:(WZMHttpResponseResult *)responseResult;
- (UIView *)badView;
- (void)badViewAction;
- (UIImage *)badViewImage;
- (NSString *)badViewMessage;
- (NSString *)badViewActionTitle;
- (NSArray<UIView *> *)badViewFront;
- (CGRect)badViewFrame;
- (UIColor *)badViewColor;

@end
