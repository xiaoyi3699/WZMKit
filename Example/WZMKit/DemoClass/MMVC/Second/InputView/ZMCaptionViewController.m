//
//  ZMCaptionViewController.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ZMCaptionViewController.h"
#import "WZMVideoEditView.h"

@interface ZMCaptionViewController ()

@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WZMVideoEditView *videoView;
@property (nonatomic, strong) UIView *toolView;

@end

@implementation ZMCaptionViewController

- (instancetype)initWithVideoUrl:(NSURL *)videoUrl {
    self = [super init];
    if (self) {
        self.videoUrl = videoUrl;
        self.title = @"添加字幕";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WZM_R_G_B(244, 244, 244);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(exportVideo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    CGFloat toolViewH = 140;
    CGRect rect = WZMRectBottomArea();
    rect.origin.y += 10;
    rect.size.height -= toolViewH+20;
    self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:self.scrollView];
    
    [self initVideoView];
    [self loadCaptionWords];
    [self initToolView:toolViewH];
}

//播放view
- (void)initVideoView {
    self.videoView = [[WZMVideoEditView alloc] initWithFrame:self.scrollView.bounds];
    self.videoView.videoUrl = self.videoUrl;
    [self.scrollView addSubview:self.videoView];
}

//底部面板view
- (void)initToolView:(CGFloat)toolViewH {
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.wzm_maxY+10, self.view.wzm_width, toolViewH)];
    self.toolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolView];
    
    
    NSArray *titles = @[@"字幕",@"特效",@"转场"];
    NSArray *images = @[@"",@"",@""];
    CGFloat itemW = 70;
    CGFloat itemSpacing = (self.toolView.wzm_width-itemW*titles.count)/(titles.count-1);
    for (NSInteger i = 0; i < titles.count; i ++) {
        CGRect rect = CGRectMake(i*(itemW+itemSpacing), 0, itemW, itemW);
        WZMButton *btn = [[WZMButton alloc] initWithFrame:rect];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage wzm_getRoundImageByColor:[UIColor blueColor] size:CGSizeMake(30, 30)] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.imageFrame = CGRectMake(20, 10, 30, 30);
        btn.titleFrame = CGRectMake(0, 40, itemSpacing, 30);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.toolView addSubview:btn];
    }
    CGFloat nextMinY = itemW, nextH = self.toolView.wzm_height-itemW;
    NSLog(@"%@==%@",@(nextMinY),@(nextH));
}

//交互事件
- (void)itemBtnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        //字幕
    }
    else if (btn.tag == 1) {
        //特效
    }
    else {
        //转场
    }
}

//加载歌词
- (void)loadCaptionWords {
    //初始化歌词
    WZMCaptionModel *noteModel = [[WZMCaptionModel alloc] init];
    noteModel.text = @"我是第一个字幕:啦啦啦啦啦啦";
    noteModel.textColor = [UIColor whiteColor];
    noteModel.highTextColor = [UIColor redColor];
    noteModel.textPosition = CGPointMake(10, 10);
    noteModel.startTime = 0.5;
    noteModel.duration = 1.5;
    noteModel.textType = WZMCaptionModelTypeGradient;
    noteModel.textAnimationType = WZMCaptionTextAnimationTypeOneByOne;
    noteModel.showNote = NO;
    noteModel.noteId = @"1";
    
    WZMCaptionModel *noteModel2 = [[WZMCaptionModel alloc] init];
    noteModel2.text = @"我是第二个字幕:啦啦啦啦啦啦";
    noteModel2.textColor = [UIColor greenColor];
    noteModel2.highTextColor = [UIColor blueColor];
    noteModel2.textPosition = CGPointMake(10, 10);
    noteModel2.startTime = 2.5;
    noteModel2.duration = 2.5;
    noteModel2.noteId = @"2";
    
    WZMCaptionModel *noteModel3 = [[WZMCaptionModel alloc] init];
    noteModel3.text = @"我是第三个字幕:啦啦啦啦啦啦";
    noteModel3.textColor = [UIColor blueColor];
    noteModel3.highTextColor = [UIColor greenColor];
    noteModel3.textPosition = CGPointMake(10, 10);
    noteModel3.startTime = 5.5;
    noteModel3.duration = 3.5;
    noteModel3.noteId = @"3";
    
    self.videoView.noteModels = @[noteModel,noteModel2,noteModel3];
}

//导出视频
- (void)exportVideo {
    if (self.videoView.exporting) return;
    [WZMViewHandle wzm_showProgressMessage:nil];
    [self.videoView exportVideoWithNoteAnimationCompletion:^(NSURL *exportURL) {
        [WZMViewHandle wzm_dismiss];
        if (exportURL) {
            [WZMAlbumHelper wzm_saveVideo:exportURL.path];
        }
    }];
}

@end
