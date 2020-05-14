//
//  WZMScannerViewController.m
//  erweima
//
//  Created by wangzhaomeng on 16/7/25.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMScannerViewController.h"
#import "WZMLogPrinter.h"
#import "WZMPublic.h"
#import "UIColor+wzmcate.h"

@interface WZMScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate> {
    dispatch_queue_t _dispatchQueue;
}
@property (nonatomic, strong) UILabel *statuesLabel;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIBarButtonItem *starBarButtonItem;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int a;

@end

@implementation WZMScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wzm_getDynamicColor:[UIColor whiteColor]];
    _a = 74;
    [self createViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self start];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stop];
}

- (void)createViews{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-280)/2, _a, 280, 350)];
    _bgView.backgroundColor = [UIColor wzm_getDynamicColor:[UIColor grayColor]];
    [self.view addSubview:_bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, -7, 290, 364)];
    imageView.image = [WZMPublic imageWithFolder:@"qrCode" imageName:@"qrBg.png"];
    [_bgView addSubview:imageView];
    
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_bgView.frame.origin.x, 74, 280, 10)];
    _lineImageView.image = [WZMPublic imageWithFolder:@"qrLine" imageName:@"qrBg.png"];
    _lineImageView.hidden = YES;
    [self.view addSubview:_lineImageView];
    
    _statuesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView.frame)+27, self.view.bounds.size.width, 21)];
    _statuesLabel.textColor = [UIColor wzm_getDynamicColor:[UIColor blackColor]];
    _statuesLabel.text = @"将取景框对准二维码，即可自动扫描";
    _statuesLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_statuesLabel];
}

#pragma mark - 二维码扫描
/**开始扫描二维码**/
- (BOOL)startReading {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        WZMLog(@"%@",[error localizedDescription]);
        return NO;
    }
    else {
        if (!_captureSession) {
            _captureSession = [[AVCaptureSession alloc] init];
            [_captureSession addInput:input];
            
            AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
            [_captureSession addOutput:captureMetadataOutput];
            
            _dispatchQueue = dispatch_queue_create("myQueue", NULL);
            [captureMetadataOutput setMetadataObjectsDelegate:self queue:_dispatchQueue];
            [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
            
            _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
            [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            [_videoPreviewLayer setFrame:CGRectMake(0, 0, 280, 350)];
        }
        [_bgView.layer addSublayer:_videoPreviewLayer];
        [_captureSession startRunning];
        return YES;
    }
}

/**停止扫描二维码**/
-(void)stopReading {
    [_captureSession stopRunning];
    [_videoPreviewLayer removeFromSuperlayer];
}

/**输出二维码**/
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stop];
        if (metadataObjects != nil && [metadataObjects count] > 0) {
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                NSString *text = [metadataObj stringValue];
                [self handleText:text];
            }
        }
    });
}

- (void)handleText:(NSString *)text {
    WZMLog(@"===%@",text);
}

#pragma mark - 二维码扫描动画
/**开始扫描动画**/
- (void)start {
    if (_timer == nil) {
        _a = 74;
        _lineImageView.hidden = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval: 0.02 target: self selector: @selector(animation:) userInfo: nil repeats: YES];
        [_timer fire];
        [self startReading];
    }
}

/**停止扫描动画**/
- (void)stop {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        _a = 74;
        _lineImageView.hidden = YES;
        [self stopReading];
    }
}

/**扫描动画**/
- (void)animation:(NSTimer *)timer {
    _a = _a + 5;
    if (_a >= 74+350) {
        _a = 74;
    }
    CGRect rect = _lineImageView.frame;
    rect.origin.y = _a;
    _lineImageView.frame = rect;
}

@end
