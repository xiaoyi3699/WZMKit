//
//  WZMAlertManager.h
//  WZMKit
//
//  Created by Zhaomeng Wang on 2020/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZMAlertQueue : NSObject

@property (nonatomic, strong) NSMutableArray *queues;

+ (instancetype)shareQueue;
- (void)showAlertView:(UIView *)alertView;

@end

NS_ASSUME_NONNULL_END
