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

///UITableViewStyle
- (UITableViewStyle)tableViewStyle;
///刷新数据
- (void)refreshHeader;
///加载更多
- (void)refreshFooter;
///子类如果需要实现自己页面特定的页面加载动画,重载该方法即可
- (void)showLoadingView;
- (void)dismissLoadingView;
///子类如果需要实现自己页面特定需求的数据加载后的处理,重载以下方法即可
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
