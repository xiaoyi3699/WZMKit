//
//  UITextView+wzmcate.m
//  WZMFoundation
//
//  Created by WangZhaomeng on 2017/7/5.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UITextView+wzmcate.h"
#import <objc/runtime.h>
#import "WZMLogPrinter.h"

#define TV_WZM_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@implementation UITextView (wzmcate)
static NSString *_performActionKey = @"performAction";

- (void)setWzm_performActionType: (WZMPerformActionType)wzm_performActionType {
    objc_setAssociatedObject(self, &_performActionKey, @(wzm_performActionType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-  (WZMPerformActionType)wzm_performActionType {
    return  (WZMPerformActionType)[objc_getAssociatedObject(self, &_performActionKey) integerValue];
}

+ (void)load {
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = @selector(canPerformAction:withSender:);
        SEL swizzSel = @selector(wzm_canPerformAction:withSender:);
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

- (BOOL)wzm_canPerformAction:(SEL)action withSender:(id)sender{
    
    if (self.wzm_performActionType == WZMPerformActionTypeNone) {
        return NO;
    }
    return [self wzm_canPerformAction:action withSender:sender];
}

- (BOOL)wzm_shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text limitNums:(NSInteger)limitNums {
    if ([text isEqualToString:@""]) {
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
        if (self.text.length + text.length > limitNums) {
            self.text = [self.text stringByAppendingString:[text substringToIndex:(limitNums-self.text.length)]];
            return NO;
        }
        else {
            return YES;
        }
    }
    return NO;
}

- (BOOL)wzm_shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text pointNums:(NSInteger)pointNums{
    if (pointNums <= 0) {//整型
        if ([text rangeOfString:@"."].location != NSNotFound) {
            return NO;
        }
        if ([text length] > 0) {
            unichar single = [text characterAtIndex:0];//当前输入的字符
            if (single >= '0' && single <= '9') {//数据格式正确
                //首字母不能为0
                if([self.text length] == 0){
                    if (single == '0') {
                        WZMLog(@"亲，第一个数字不能为0");
                        [self.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                return YES;
            }
            else{//输入的数据格式不正确
                WZMLog(@"亲，您输入的格式不正确");
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
        if ([text length] > 0) {
            unichar single = [text characterAtIndex:0];//当前输入的字符
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
                        WZMLog(@"亲，第一个数字不能为小数点");
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
                        WZMLog(@"亲，您已经输入过小数点了");
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
                            WZMLog(@"%@",[NSString stringWithFormat:@"亲，您最多输入%ld位小数",(long)pointNums]);
                            return NO;
                        }
                    }
                    else{
                        return YES;
                    }
                }
            }
            else{//输入的数据格式不正确
                WZMLog(@"亲，您输入的格式不正确");
                [self.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
    }
    return YES;
}

- (void)wzm_limitTextFieldLength:(NSInteger)length{
    if (self.text.length > length) {
        self.text = [self.text substringToIndex:length];
    }
}

- (void)wzm_selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)wzm_setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

- (NSRange)wzm_selectedRange {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}

//键盘样式
- (void)wzm_inputAccessoryViewWithType: (WZMInputAccessoryType)type message:(NSString *)message {
    
    UIVisualEffectView *toolView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    toolView.frame = CGRectMake(0, 0, TV_WZM_SCREEN_WIDTH, 40);
    toolView.backgroundColor = [UIColor colorWithWhite:.9 alpha:.9];
    
    NSArray *titles;
    if (type == WZMInputAccessoryTypeDone) {
        titles = @[@"完成"];
    }
    else if (type == WZMInputAccessoryTypeCancel) {
        titles = @[@"取消"];
    }
    else {
        titles = @[@"取消",@"完成"];
    }
    
    for (NSInteger i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == titles.count-1) {
            btn.frame = CGRectMake(TV_WZM_SCREEN_WIDTH-50, 5, 40, 30);
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, TV_WZM_SCREEN_WIDTH-100, 30)];
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

- (void)wzm_inputAccessoryViewWithDoneTitle:(NSString *)title message:(NSString *)message {
    UIVisualEffectView *toolView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    toolView.frame = CGRectMake(0, 0, TV_WZM_SCREEN_WIDTH, 40);
    
    if (title.length == 0) {
        title = @"完成";
    }
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.tag = 0;
    [doneBtn setTitle:title forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(TV_WZM_SCREEN_WIDTH-50, 5, 40, 30);
    [doneBtn addTarget:self action:@selector(dealKeyboardHide:) forControlEvents:UIControlEventTouchUpInside];
    [toolView.contentView addSubview:doneBtn];
    
    if (message.length) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, TV_WZM_SCREEN_WIDTH-100, 30)];
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
        WZMLog(@"取消");
    }
    else {
        WZMLog(@"完成");
    }
    [self resignFirstResponder];
}

@end
