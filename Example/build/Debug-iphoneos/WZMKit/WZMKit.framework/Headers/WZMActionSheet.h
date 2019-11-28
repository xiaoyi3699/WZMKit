//
//  WZMActionSheet.h
//  WZMFoundation
//
//  Created by WangZhaomeng on 2017/7/11.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMBlock.h"

@protocol WZMActionSheetDelegate;

@interface WZMActionSheet : UIView

@property (nonatomic, weak) id<WZMActionSheetDelegate> delegete;

- (instancetype)initWithMessage:(NSString *)message titles:(NSArray *)titles;
- (void)showCompletion:(doBlock)completion;
- (void)showInView:(UIView *)aView completion:(doBlock)completion;
- (void)dismiss;

@end

@protocol WZMActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(WZMActionSheet *)actionSheet didSelectedAtIndex:(NSInteger)index;

@end
