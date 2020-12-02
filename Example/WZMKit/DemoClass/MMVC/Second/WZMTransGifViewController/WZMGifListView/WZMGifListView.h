//
//  WZMGifListView.h
//  ThirdApp
//
//  Created by Zhaomeng Wang on 2020/8/20.
//  Copyright © 2020 富秋. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMGifListViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface WZMGifListView : UIView
@property (nonatomic, assign) CGFloat delayTime;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, weak) UIViewController *fromController;
@property (nonatomic, weak) id<WZMGifListViewDelegate> delegate;
- (void)reloadWithImages:(NSArray *)images;

@end

@protocol WZMGifListViewDelegate <NSObject>

@optional
- (void)gifListViewDidChange:(WZMGifListView *)gifListView;

@end
NS_ASSUME_NONNULL_END
