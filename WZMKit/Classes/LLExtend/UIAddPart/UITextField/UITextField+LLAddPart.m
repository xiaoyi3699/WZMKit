//
//  UITextField+LLAddPart.m
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/7/5.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UITextField+LLAddPart.h"
#import <objc/runtime.h>
#import "LLLog.h"

#define TF_LL_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@implementation UITextField (LLAddPart)
static NSString *_performActionKey = @"performAction";

- (void)setPerformActionType:(LLPerformActionType)performActionType {
    objc_setAssociatedObject(self, &_performActionKey, @(performActionType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LLPerformActionType)performActionType {
    return (LLPerformActionType)[objc_getAssociatedObject(self, &_performActionKey) integerValue];
}

+ (void)load {
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = @selector(canPerformAction:withSender:);
        SEL swizzSel = @selector(ll_canPerformAction:withSender:);
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
}

- (BOOL)ll_canPerformAction:(SEL)action withSender:(id)sender{
    if (self.performActionType == LLPerformActionTypeNone) {
        return NO;
    }
    return [self ll_canPerformAction:action withSender:sender];
}

- (void)ll_setPlaceholderColor:(UIColor *)color font:(UIFont *)font {
    if (color) {
        [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    }
    if (font) {
        [self setValue:font forKeyPath:@"_placeholderLabel.font"];
    }
}

- (void)ll_contentMargin:(CGFloat)value {
    
    CGRect frame = [self bounds];
    frame.size.width = value;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftview;
}

- (void)ll_inputErrorForShake{
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [keyAn setValues:array];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    [self.layer addAnimation:keyAn forKey:@"Shark"];
}

- (BOOL)ll_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitNums:(NSInteger)limitNums {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSString *language = self.textInputMode.primaryLanguage;
    if ([language isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self markedTextRange];
        if (selectedRange) {
            return YES;
        }
    }
    if (self.text.length < limitNums) {
        if (self.text.length + string.length > limitNums) {
            self.text = [self.text stringByAppendingString:[string substringToIndex:(limitNums-self.text.length)]];
            return NO;
        }
        else {
            return YES;
        }
    }
    return NO;
}

- (BOOL)ll_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string pointNums:(NSInteger)pointNums{
    if (pointNums <= 0) {//整型
        if ([string rangeOfString:@"."].location != NSNotFound) {
            return NO;
        }
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if (single >= '0' && single <= '9') {//数据格式正确
                //首字母不能为0
                if([self.text length] == 0){
                    if (single == '0') {
                        ll_log(@"亲，第一个数字不能为0");
                        [self.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                return YES;
            }
            else{//输入的数据格式不正确
                ll_log(@"亲，您输入的格式不正确");
                [self.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
    }
    else {//浮点型
        BOOL isHaveDian = YES;
        if ([self.text rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        else {
            isHaveDian = YES;
        }
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                if ([self.text length] == 1) {
                    unichar firstChar = [self.text characterAtIndex:0];//当前输入的字符
                    if (firstChar == '0' && single != '.') {
                        NSString *singleStr = [NSString stringWithFormat:@"%c",single];
                        self.text = singleStr;
                        return NO;
                    }
                }
                //首字母不能为小数点
                if([self.text length] == 0){
                    if(single == '.') {
                        ll_log(@"亲，第一个数字不能为小数点");
                        [self.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!isHaveDian){//text中还没有小数点
                        return YES;
                    }
                    else{
                        ll_log(@"亲，您已经输入过小数点了");
                        [self.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                else{
                    if (isHaveDian) {//存在小数点
                        //判断小数点的位数
                        NSRange ran = [self.text rangeOfString:@"."];
                        if (range.location - ran.location <= pointNums) {
                            return YES;
                        }
                        else{
                            ll_log(@"%@",[NSString stringWithFormat:@"亲，您最多输入%ld位小数",(long)pointNums]);
                            return NO;
                        }
                    }
                    else{
                        return YES;
                    }
                }
            }
            else{//输入的数据格式不正确
                ll_log(@"亲，您输入的格式不正确");
                [self.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
    }
    return YES;
}

- (void)ll_limitTextFieldLength:(NSInteger)length{
    if (self.text.length > length) {
        self.text = [self.text substringToIndex:length];
    }
}

- (void)ll_selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)ll_setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

///工具框样式
- (void)ll_inputAccessoryViewWithType:(LLInputAccessoryType)type message:(NSString *)message {
    
    UIVisualEffectView *toolView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    toolView.frame = CGRectMake(0, 0, TF_LL_SCREEN_WIDTH, 40);
    toolView.backgroundColor = [UIColor colorWithWhite:.9 alpha:.9];
    
    NSArray *titles;
    if (type == LLInputAccessoryTypeDone) {
        titles = @[@"完成"];
    }
    else if (type == LLInputAccessoryTypeCancel) {
        titles = @[@"取消"];
    }
    else {
        titles = @[@"取消",@"完成"];
    }
    
    for (NSInteger i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == titles.count-1) {
            btn.frame = CGRectMake(TF_LL_SCREEN_WIDTH-50, 5, 40, 30);
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        else {
            btn.frame = CGRectMake(10, 5, 40, 30);
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dealKeyboardHide:) forControlEvents:UIControlEventTouchUpInside];
        [toolView.contentView addSubview:btn];
    }
    
    if (message.length) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, TF_LL_SCREEN_WIDTH-100, 30)];
        label.text = message;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkTextColor];
        label.textAlignment = NSTextAlignmentCenter;
        [toolView.contentView addSubview:label];
    }
    
    [self setInputAccessoryView:toolView];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
}

- (void)ll_inputAccessoryViewWithDoneTitle:(NSString *)title message:(NSString *)message {
    UIVisualEffectView *toolView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    toolView.frame = CGRectMake(0, 0, TF_LL_SCREEN_WIDTH, 40);
    
    if (title.length == 0) {
        title = @"完成";
    }
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.tag = 0;
    [doneBtn setTitle:title forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(TF_LL_SCREEN_WIDTH-50, 5, 40, 30);
    [doneBtn addTarget:self action:@selector(dealKeyboardHide:) forControlEvents:UIControlEventTouchUpInside];
    [toolView.contentView addSubview:doneBtn];
    
    if (message.length) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, TF_LL_SCREEN_WIDTH-100, 30)];
        label.text = message;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkTextColor];
        label.textAlignment = NSTextAlignmentCenter;
        [toolView.contentView addSubview:label];
    }
    
    [self setInputAccessoryView:toolView];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
}

- (void)dealKeyboardHide:(UIButton *)btn {
    if (btn.tag == 0) {
        ll_log(@"取消");
    }
    else {
        ll_log(@"完成");
    }
    [self resignFirstResponder];
}

@end
