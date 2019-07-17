//
//  WZMPlayerView.m
//  Pods-WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//

#import "WZMPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@implementation WZMPlayerView

//在调用视图的layer时，会自动触发layerClass方法，重写它，保证返回的类型是AVPlayerLayer
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

@end
