//
//  WZMPhotoDuibiViewController.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/1/28.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import "WZMPhotoDuibiViewController.h"

@interface WZMPhotoDuibiViewController ()<WZMAlbumNavigationControllerDelegate>

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *imageContentView1;
@property (nonatomic, strong) UIView *imageContentView2;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIView *toolView;

@end

@implementation WZMPhotoDuibiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.contentView];
    
    self.imageContentView1 = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.imageContentView1.userInteractionEnabled = NO;
    [self.contentView addSubview:self.imageContentView1];
    
    self.imageContentView2 = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.imageContentView2.userInteractionEnabled = NO;
    [self.contentView addSubview:self.imageContentView2];
    
    self.imageView1 = [[UIImageView alloc] initWithFrame:self.imageContentView1.bounds];
    self.imageView1.alpha = 1.0;
    [self.imageContentView1 addSubview:self.imageView1];
    
    self.imageView2 = [[UIImageView alloc] initWithFrame:self.imageContentView2.bounds];
    self.imageView2.alpha = 0.5;
    [self.imageContentView2 addSubview:self.imageView2];
    
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(10.0, WZM_SCREEN_HEIGHT-100.0-WZM_BOTTOM_HEIGHT, WZM_SCREEN_WIDTH-20.0, 80.0)];
    self.toolView.wzm_cornerRadius = 5.0;
    self.toolView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.contentView addSubview:self.toolView];
    
    self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake((WZM_SCREEN_WIDTH-80.0)/2.0, (WZM_SCREEN_HEIGHT-80.0)/2.0-20.0, 80.0, 80.0)];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"photo_add"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapClick)];
    [self.contentView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(contentPanClick:)];
    [self.contentView addGestureRecognizer:pan2];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(toolPanClick:)];
    [self.toolView addGestureRecognizer:pan];
    
    NSArray *btnTitles = @[@"交换位置",@"修改图片",@"复位"];
    CGFloat btnW = (self.toolView.wzm_width/btnTitles.count);
    for (NSInteger i = 0; i < btnTitles.count; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnW, 0.0, btnW, 40.0)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:btn];
    }
    
    UISlider *slider1 = [[UISlider alloc] initWithFrame:CGRectMake(5.0, 40.0, self.toolView.wzm_width-10.0, 30.0)];
    slider1.tag = 0;
    slider1.minimumValue = 0.0;
    slider1.maximumValue = 1.0;
    slider1.value = self.imageView2.alpha;
    [slider1 addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [slider1 addTarget:self action:@selector(touchChange:) forControlEvents:UIControlEventValueChanged];
    [slider1 addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    [slider1 setThumbImage:[UIImage wzm_getRoundImageByColor:[UIColor whiteColor] size:CGSizeMake(10.0, 10.0)] forState:UIControlStateNormal];
    [self.toolView addSubview:slider1];
}

- (void)contentTapClick {
    [UIView animateWithDuration:0.35 animations:^{
        self.toolView.alpha = (1.0-self.toolView.alpha);
    } completion:^(BOOL finished) {
//        if (@available(iOS 11.0, *)) {
//            [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
//        } else {
//            // Fallback on earlier versions
//        }
    }];
}

- (void)contentPanClick:(UIPanGestureRecognizer *)recognizer {
    if (self.imageView2.image == nil) return;
    UIView *tapView = self.imageContentView2;
    CGPoint point_0 = [recognizer translationInView:recognizer.view];
    static CGRect rect;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        rect = tapView.frame;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat x = rect.origin.x+point_0.x;
        CGFloat y = rect.origin.y+point_0.y;
        tapView.frame = CGRectMake(x, y, tapView.frame.size.width, tapView.frame.size.height);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled) {
        
    }
}

- (void)toolPanClick:(UIPanGestureRecognizer *)recognizer {
    UIView *tapView = recognizer.view;
    CGPoint point_0 = [recognizer translationInView:tapView];
    static CGRect rect;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        rect = tapView.frame;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat y = rect.origin.y+point_0.y;
        if (y < WZM_STATUS_HEIGHT || y > WZM_SCREEN_HEIGHT-WZM_BOTTOM_HEIGHT-tapView.frame.size.height) {
            y = tapView.frame.origin.y;
        }
        tapView.frame = CGRectMake(10.0, y, tapView.frame.size.width, tapView.frame.size.height);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled) {
        
    }
}

- (void)itemBtnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        //交换位置
        UIImage *image = self.imageView1.image;
        self.imageView1.image = self.imageView2.image;
        self.imageView2.image = image;
    }
    else if (btn.tag == 1) {
        //修改图片
        [self addBtnClick:nil];
    }
    else {
        self.imageContentView1.frame = self.contentView.bounds;
        self.imageContentView2.frame = self.contentView.bounds;
    }
}

//进度条滑动开始
-(void)touchDown:(UISlider *)sl {
    
}

//进度条滑动
-(void)touchChange:(UISlider *)sl {
    self.imageView2.alpha = sl.value;
}

//进度条滑动结束
-(void)touchUp:(UISlider *)sl {
    
}

- (void)addBtnClick:(UIButton *)btn {
    WZMAlbumConfig *config = [[WZMAlbumConfig alloc] init];
    config.minCount = 1;
    config.maxCount = 2;
    config.allowPreview = NO;
    config.allowShowGIF = NO;
    config.allowShowVideo = NO;
    WZMAlbumNavigationController *nav = [[WZMAlbumNavigationController alloc] initWithConfig:config];
    nav.pickerDelegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    if (originals.count == 1) {
        self.addBtn.hidden = YES;
        if (self.imageView1.image == nil) {
            self.imageView1.image = originals.firstObject;
        }
        else {
            self.imageView2.image = originals.firstObject;
        }
    }
    else if (originals.count == 2) {
        self.addBtn.hidden = YES;
        self.imageView1.image = originals.firstObject;
        self.imageView2.image = originals.lastObject;
    }
    else {
        [WZMViewHandle wzm_showAlertMessage:@"图片资源出错"];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//屏蔽屏幕底部的系统手势
//- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
//    if (self.toolView.alpha == 0.0) {
//        return  UIRectEdgeAll;
//    }
//    return  UIRectEdgeNone;
//}

@end
