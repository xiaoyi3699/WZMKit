//
//  WZMPhotoBrowser.h
//  WZMKit
//
//  Created by WangZhaomeng on 2017/12/13.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@protocol WZMPhotoBrowserDelegate;

@interface WZMPhotoBrowser : UIViewController

@property (nonatomic, weak) id<WZMPhotoBrowserDelegate> delegate;

///images内的元素，可以是UIImage对象、NSData对象、路径、图片网址，并且支持gif
@property (nonatomic, strong) NSArray *images;
///图片索引
@property (nonatomic, assign) NSInteger index;

@end

@protocol WZMPhotoBrowserDelegate <NSObject>

@optional
- (void)photoBrowser:(WZMPhotoBrowser *)photoBrowser
        clickAtIndex:(NSInteger)index
             content:(id)content
               isGif:(BOOL)isGif
                type: (WZMGestureRecognizerType)type;


@end
