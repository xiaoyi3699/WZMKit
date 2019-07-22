//
//  WZMToolView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/22.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMToolViewDelegate;

@interface WZMToolView : UIView

@property (nonatomic, weak) id<WZMToolViewDelegate> delegate;

@end

@protocol WZMToolViewDelegate <NSObject>

@optional
- (void)inputToolView:(WZMToolView *)inputToolView DidSelectAtIndex:(NSInteger)index;

@end
