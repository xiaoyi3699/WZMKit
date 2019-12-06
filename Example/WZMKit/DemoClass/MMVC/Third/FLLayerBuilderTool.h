//
//  FLLayerBuilderTool.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLLayerBuilderTool : NSObject

+ (UIBezierPath*) createPathForText:(NSString*)string fontHeight:(CGFloat)height fontName:(CFStringRef)fontName;

@end

NS_ASSUME_NONNULL_END
