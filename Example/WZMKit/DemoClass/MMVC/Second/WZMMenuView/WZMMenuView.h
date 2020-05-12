//
//  WZMMenuView.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/9.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMMenuViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface WZMMenuView : UIView

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, weak) id<WZMMenuViewDelegate> delegate;

@end

@protocol WZMMenuViewDelegate <NSObject>

@optional
- (void)menuView:(WZMMenuView *)menuView didSelectedText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
