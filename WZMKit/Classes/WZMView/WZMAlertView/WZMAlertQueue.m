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
@property (nonatomic, assign) BOOL showing;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;
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
        self.index = -1;
        self.showing = NO;
        self.queues = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)showAlertView:(UIView *)alertView {
    if (self.showing) return;
    if (alertView == nil) return;
    [self.queues addObject:alertView];
    [self showAlertViewAtIndex:0];
}

- (void)showAlertViewAtIndex:(NSInteger)index {
    if (index >= self.queues.count) {
        [self timerInvalidate];
        [self.queues removeAllObjects];
        return;
    }
    if (self.index == index) return;
    self.index = index;
    UIView *alertView = [self.queues objectAtIndex:index];
    if ([alertView isKindOfClass:[UIAlertView class]]) {
        [(UIAlertView *)alertView show];
    }
    else if ([alertView isKindOfClass:[WZMAlertView class]]) {
        [(WZMAlertView *)alertView showAnimated:YES];
    }
    [self timerFire];
}

#pragma mark - timer
- (void)timerFire {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    }
}

- (void)timerInvalidate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.showing = NO;
}

- (void)timerRun:(NSTimer *)timer {
    self.showing = YES;
    UIView *alertView = [self.queues objectAtIndex:self.index];
    if ([alertView isKindOfClass:[UIAlertView class]]) {
        if ([(UIAlertView *)alertView isVisible] == NO) {
            [self showAlertViewAtIndex:(self.index+1)];
        }
    }
    else if (alertView.superview == nil) {
        [self showAlertViewAtIndex:(self.index+1)];
    }
}

@end
