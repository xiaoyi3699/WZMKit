//
//  WZMAlertQueue.m
//  WZMKit
//
//  Created by Zhaomeng Wang on 2020/9/10.
//

#import "WZMAlertQueue.h"
#import "WZMLogPrinter.h"
#import "WZMAlertView.h"

@interface WZMAlertQueue()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UIView *alertView;
@end

@implementation WZMAlertQueue

+ (instancetype)shareQueue {
    static WZMAlertQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[WZMAlertQueue alloc] init];
    });
    return queue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.queues = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)showAlertView:(UIView *)alertView {
    if (alertView == nil) return;
    [self.queues addObject:alertView];
    if (self.alertView) {
        [self timerFire];
    }
    else {
        self.alertView = alertView;
        if ([alertView isKindOfClass:[UIAlertView class]]) {
            [(UIAlertView *)alertView show];
        }
        else if ([alertView isKindOfClass:[WZMAlertView class]]) {
            [(WZMAlertView *)alertView showAnimated:YES];
        }
        [self timerFire];
    }
}

- (void)removeAlertView {
    if (self.alertView == nil) return;
    [self.queues removeObject:self.alertView];
    self.alertView = nil;
}

#pragma mark - timer
- (void)timerFire {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    }
}

- (void)timerInvalidate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self removeAlertView];
    if (self.queues.count) {
        [self showAlertView:self.queues.firstObject];
    }
}

- (void)timerRun:(NSTimer *)timer {
    if (self.alertView.superview == nil) {
        [self timerInvalidate];
    }
    WZMLog(@"========2121212==2=1==1212");
}

@end
