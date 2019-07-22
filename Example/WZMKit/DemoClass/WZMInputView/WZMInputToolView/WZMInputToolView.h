//
//  WZMInputToolView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/22.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMInputToolViewDelegate;

@interface WZMInputToolView : UIView

@property (nonatomic, weak) id<WZMInputToolViewDelegate> delegate;

@end

@protocol WZMInputToolViewDelegate <NSObject>

@optional
- (void)inputToolView:(WZMInputToolView *)inputToolView DidSelectAtIndex:(NSInteger)index;

@end
