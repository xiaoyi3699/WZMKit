//
//  PlayView.m
//  WZMAVPlayer
//
//  Created by zhaomengWang on 2017/4/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "WZMVideoPlayerItem.h"
#import "WZMLogPrinter.h"
#import "WZMMacro.h"
#import "UIImage+wzmcate.h"
#import "UIView+wzmcate.h"
#import "UIViewController+wzmcate.h"

#import "WZMPlayer.h"
#import "WZMPlayerView.h"

typedef NS_ENUM(NSUInteger, WZMDirection) {
    WZMDirectionNone = 0,
    WZMDirectionHrizontal,    //水平方向滑动
    WZMDirectionVertical,     //垂直方向滑动
};

@interface WZMVideoPlayerView ()

//滑动手势
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat startBright;
@property (nonatomic, assign) CGFloat startVideoRate;
@property (nonatomic, assign) WZMDirection direction;

//音量、亮度、进度
@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) UISlider *volumeViewSlider;
@property (nonatomic, strong) UISlider *brightnessSlider;
@property (nonatomic, strong) UISlider *progressSlider;

//视图
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *fullBtn;
@property (nonatomic, strong) UIView   *topView;
@property (nonatomic, strong) UIView   *toolView;
@property (nonatomic, strong) UILabel  *totalTimeLabel;
@property (nonatomic, strong) UILabel  *currentTimeLabel;
@property (nonatomic, strong) WZMPlayer *player;
@property (nonatomic, strong) WZMPlayerView *playerView;

@end

@implementation WZMVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:tapGR];
        
        //获取系统的音量view
        self.volumeView.frame = CGRectMake(frame.size.width-30, (frame.size.height-100)/2.0, 20, 100);
        self.volumeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.volumeView.hidden = YES;
        [self addSubview:self.volumeView];
        
        //控制亮度
        self.brightnessSlider.frame = CGRectMake(20, (frame.size.height-100)/2.0, 20, 100);
        self.brightnessSlider.minimumValue = 0.0;
        self.brightnessSlider.maximumValue = 1.0;
        self.brightnessSlider.hidden = YES;
        [self.brightnessSlider addTarget:self action:@selector(brightnessChanged:) forControlEvents:UIControlEventValueChanged];
        self.brightnessSlider.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.brightnessSlider];
        
        //顶部view
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        _topView.backgroundColor = WZM_R_G_B_A(50, 50, 50, .5);
        _topView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_topView];
        
        //返回按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10, 15, 50, 16)];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn setImage:[WZMPublic imageNamed:@"wzm_back_white" ofType:@"png"] forState:UIControlStateNormal];
        [_topView addSubview:backBtn];
        
        UIButton *tureBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tureBackBtn setFrame:CGRectMake(0, 0, 60, 44)];
        [tureBackBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:tureBackBtn];
        
        //全屏按钮
        _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullBtn setFrame:CGRectMake(_topView.wzm_width-50, 10, 40, 25)];
        _fullBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _fullBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _fullBtn.layer.masksToBounds = YES;
        _fullBtn.layer.cornerRadius = 5;
        _fullBtn.layer.borderColor = WZM_R_G_B(230, 230, 230).CGColor;
        _fullBtn.layer.borderWidth = 0.8;
        [_fullBtn setTitle:@"全屏" forState:UIControlStateNormal];
        [_fullBtn setTitle:@"还原" forState:UIControlStateSelected];
        [_fullBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fullBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_topView addSubview:_fullBtn];
        
        UIButton *tureFullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tureFullBtn setFrame:CGRectMake(_topView.wzm_width-60, 0, 60, 44)];
        tureFullBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [tureFullBtn addTarget:self action:@selector(fullBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:tureFullBtn];
        
        //底部view
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 40)];
        _toolView.backgroundColor = WZM_R_G_B_A(50, 50, 50, .5);
        _toolView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_toolView];
        
        //播放暂停按钮
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setFrame:CGRectMake(5,10,20,20)];
        _playBtn.selected=YES;
        [_playBtn setBackgroundImage:[WZMPublic imageNamed:@"wzm_player_play" ofType:@"png"] forState:UIControlStateNormal];
        [_playBtn setBackgroundImage:[WZMPublic imageNamed:@"wzm_player_pause" ofType:@"png"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:_playBtn];
        
        _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playBtn.frame), 10, 40, 20)];
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:8];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_toolView addSubview:_currentTimeLabel];
        
        //播放进度条
        _progressSlider= [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_currentTimeLabel.frame),12.5,frame.size.width-CGRectGetMaxX(_currentTimeLabel.frame)-40,15)];
        _progressSlider.minimumValue = 0.0;
        _progressSlider.maximumValue = 1.0;
        [_progressSlider addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [_progressSlider addTarget:self action:@selector(touchChange:) forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
        [_progressSlider setThumbImage:[UIImage wzm_getRoundImageByColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
        _progressSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_toolView addSubview:_progressSlider];
        
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_progressSlider.frame), 10, 40, 20)];
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:8];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_toolView addSubview:_totalTimeLabel];
        
        _playerView = [[WZMPlayerView alloc] initWithFrame:self.bounds];
        [self addSubview:_playerView];
        _player = [[WZMPlayer alloc] init];
        _player.playerView = _playerView;
    }
    return self;
}

- (void)playWithUrl:(NSURL *)url {
    [_player playWithURL:url];
}


//音量调节
- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView  = [[MPVolumeView alloc] init];
        _volumeView.transform = CGAffineTransformMakeRotation(M_PI*(-0.5));
        [_volumeView setShowsVolumeSlider:YES];
        [_volumeView setShowsRouteButton:NO];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                [self.volumeViewSlider setThumbImage:[UIImage wzm_getRoundImageByColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
                break;
            }
        }
    }
    return _volumeView;
}

//亮度调节
- (UISlider *)brightnessSlider {
    if (_brightnessSlider == nil) {
        _brightnessSlider  = [[UISlider alloc] init];
        _brightnessSlider.transform = CGAffineTransformMakeRotation(M_PI*(-0.5));
        [_brightnessSlider setThumbImage:[UIImage wzm_getRoundImageByColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    }
    return _brightnessSlider;
}

//亮度调节相关
- (void)brightnessChanged:(UISlider *)slider {
    [[UIScreen mainScreen] setBrightness:slider.value];
}

//播放器的单击事件<控制底部和顶部view的显示与隐藏>
- (void)tapGR:(UITapGestureRecognizer *)tapGR {
    [UIView animateWithDuration:.5 animations:^{
        _topView.hidden = !_topView.isHidden;
        _toolView.hidden = !_toolView.isHidden;
    }];
}

#pragma mark - 顶部view相关事件
//返回按钮的点击事件
- (void)goBack:(UIButton *)btn
{
    if (_fullBtn.selected) {
        [self fullBtnClick];
    }
    else {
        if (self.wzm_viewController.navigationController.topViewController == self.wzm_viewController) {
            [self.wzm_viewController.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.wzm_viewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

//全屏按钮的点击事件
- (void)fullBtnClick
{
    UIInterfaceOrientation orientation;
    if (_fullBtn.selected) {
        orientation = UIInterfaceOrientationPortrait;
    }
    else {
        orientation = UIInterfaceOrientationLandscapeRight;
    }
    [self.wzm_viewController wzm_interfaceOrientation:orientation];
}

#pragma mark - 底部view相关事件
//播放按钮的点击事件
-(void)playBtnClick:(UIButton *)btn
{
    btn.selected ? [self pause] : [self play];
}

//进度条滑动开始
-(void)touchDown:(UISlider *)sl
{
    [self pause];
}

//进度条滑动
-(void)touchChange:(UISlider *)sl
{
//    float current = _progressSlider.value;
//    _currentTimeLabel.text = [self getTime:(NSInteger)(current*_player.duration)];
    [_player seekToProgress:_progressSlider.value];
}

//进度条滑动结束
-(void)touchUp:(UISlider *)sl
{
    [self play];
}

#pragma mark - 滑动手势处理,亮度/音量/进度
/**
 开始触摸
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    self.direction = WZMDirectionNone;
    
    //记录首次触摸坐标
    self.startPoint = point;
    //检测用户是触摸屏幕的左边还是右边，以此判断用户是要调节音量还是亮度，左边是亮度，右边是音量
    if (self.startPoint.x <= self.bounds.size.width/2.0) {
        //亮度
        self.startBright = [UIScreen mainScreen].brightness;
    } else {
        //音量
        self.startBright = self.volumeViewSlider.value;
    }
    self.startVideoRate = _player.playProgress;
}

/**
 移动手指
 */
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    if (self.direction == WZMDirectionNone) {
        //分析出用户滑动的方向
        if (fabs(panPoint.x) >= 30) {
            [self pause];
            self.direction = WZMDirectionHrizontal;
        }
        else if (fabs(panPoint.y) >= 30) {
            self.direction = WZMDirectionVertical;
        }
        else {
            return;
        }
    }
    
    if (self.direction == WZMDirectionHrizontal) {
        CGFloat scale = (_player.duration > 180 ? 180/_player.duration : 1.0);
        CGFloat rate = self.startVideoRate+(panPoint.x/self.bounds.size.width)*scale;
        if (rate > 1) {
            rate = 1;
        }
        else if (rate < 0) {
            rate = 0;
        }
        _progressSlider.value = rate;
        [_player seekToProgress:rate];
    }
    else if (self.direction == WZMDirectionVertical) {
        CGFloat value = self.startBright-(panPoint.y/self.bounds.size.height);
        if (value > 1) {
            value = 1;
        }
        else if (value < 0) {
            value = 0;
        }
        if (self.startPoint.x <= self.frame.size.width/2.0) {//亮度
            self.brightnessSlider.hidden = NO;
            self.brightnessSlider.value = value;
            [[UIScreen mainScreen] setBrightness:value];
        }
        else {//音量
            self.volumeView.hidden = NO;
            [self.volumeViewSlider setValue:value];
        }
    }
}

/**
 结束触摸
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.direction == WZMDirectionHrizontal) {
        [self play];
    }
    else if (self.direction == WZMDirectionVertical) {
        self.volumeView.hidden = YES;
        self.brightnessSlider.hidden = YES;
    }
}

/**
 取消触摸
 */
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (self.direction == WZMDirectionHrizontal) {
        [self play];
    }
    else if (self.direction == WZMDirectionVertical) {
        self.volumeView.hidden = YES;
        self.brightnessSlider.hidden = YES;
    }
}

#pragma mark - private method
//播放
- (void)play {
    if (_player) {
        [_player play];
        _playBtn.selected = YES;
    }
}

//暂停
- (void)pause {
    if (_player) {
        [_player pause];
        _playBtn.selected = NO;
    }
}

//将秒数换算成具体时长
- (NSString *)getTime:(NSInteger)second
{
    NSString *time;
    if (second < 60) {
        time = [NSString stringWithFormat:@"00:%02ld",(long)second];
    }
    else {
        if (second < 3600) {
            time = [NSString stringWithFormat:@"%02ld:%02ld",(long)(second/60),(long)(second%60)];
        }
        else {
            time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)(second/3600),(long)((second-second/3600*3600)/60),(long)(second%60)];
        }
    }
    return time;
}

//视频播放完毕
-(void)moviePlayDidEnd:(NSNotification *)notification {
    _playBtn.selected = NO;
    _progressSlider.value = 1.0;
    [_player seekToProgress:0.0];
    WZMLog(@"视频播放完毕！");
}

- (void)dealloc {
    WZMLog(@"%@释放了",NSStringFromClass(self.class));
}

@end
