//
//  LLInline.h
//  LLFeatureStatic
//
//  Created by WangZhaomeng on 2019/6/29.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLMacro.h"

UIKIT_STATIC_INLINE CGFloat LLDistanceBetweenPoints(CGPoint point1, CGPoint point2) {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy);
}

UIKIT_STATIC_INLINE CGRect LLRectMiddleArea() {
    CGRect rect = LL_SCREEN_BOUNDS;
    if (IS_iPhoneX) {
        rect.origin.y = 88;
        rect.size.height = rect.size.height-171;
    }
    else {
        rect.origin.y = 64;
        rect.size.height = rect.size.height-113;
    }
    return rect;
}

UIKIT_STATIC_INLINE CGRect LLRectTopArea() {
    CGRect rect = LL_SCREEN_BOUNDS;
    rect.origin.y = 0;
    if (IS_iPhoneX) {
        rect.size.height = rect.size.height-83;
    }
    else {
        rect.size.height = rect.size.height-49;
    }
    return rect;
}

UIKIT_STATIC_INLINE CGRect LLRectBottomArea() {
    CGRect rect = LL_SCREEN_BOUNDS;
    if (IS_iPhoneX) {
        rect.origin.y = 88;
        rect.size.height = rect.size.height-88;
    }
    else {
        rect.origin.y = 64;
        rect.size.height = rect.size.height-64;
    }
    return rect;
}

UIKIT_STATIC_INLINE CGRect LLRectSafeArea() {
    CGRect rect = LL_SCREEN_BOUNDS;
    if (IS_iPhoneX) {
        rect.origin.y = 44;
        rect.size.height = rect.size.height-78;
    }
    else {
        rect.origin.y = 20;
        rect.size.height = rect.size.height-20;
    }
    return rect;
}

UIKIT_STATIC_INLINE CGSize LLSizeRatioToMaxWidth (CGSize size, CGFloat maxWidth) {
    return CGSizeMake(maxWidth, size.height*maxWidth/size.width);
}

UIKIT_STATIC_INLINE CGSize LLSizeRatioToMaxHeight (CGSize size, CGFloat MaxHeight) {
    return CGSizeMake(size.width*MaxHeight/size.height, MaxHeight);
}

UIKIT_STATIC_INLINE CGSize LLSizeRatioToMaxSize (CGSize size, CGSize maxSize) {
    if (size.width/size.height >= maxSize.width/maxSize.height) {
        return LLSizeRatioToMaxWidth(size, maxSize.width);
    }
    else {
        return LLSizeRatioToMaxHeight(size, maxSize.height);
    }
}
