//
//  WZMFontManager.h
//  WZMKit
//
//  Created by Zhaomeng Wang on 2020/2/26.
//  Copyright © 2020 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMFontManager : NSObject

///从路径加载字体
+ (UIFont *)fontWithPath:(NSString *)path size:(CGFloat)size;

@end
