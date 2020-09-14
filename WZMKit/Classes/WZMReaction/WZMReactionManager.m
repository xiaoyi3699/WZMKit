//
//  WZMReactionManager.m
//  WZMCommonStatic
//
//  Created by WangZhaomeng on 2019/6/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMReactionManager.h"
#import "WZMLogPrinter.h"

@interface WZMReactionManager ()

@property (nonatomic, strong) NSMutableArray *names;

@end

@implementation WZMReactionManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.names = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

#pragma mark - UIView
- (void)gestureRecognizer:(UIGestureRecognizer *)gesture {
    if (self.next) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            self.next(gesture);
        }
        else {
            if (gesture.state == UIGestureRecognizerStateBegan) {
                self.next(gesture);
            }
        }
    }
}

- (void)singleGestureRecognizer:(UITapGestureRecognizer *)gesture {
    [self gestureView:gesture.view type:WZMGestureRecognizerTypeSingle];
}

- (void)doubleGestureRecognizer:(UITapGestureRecognizer *)gesture {
    [self gestureView:gesture.view type:WZMGestureRecognizerTypeDouble];
}

- (void)longGestureRecognizer:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self gestureView:gesture.view type:WZMGestureRecognizerTypeLong];
    }
}

//private
- (void)gestureView:(UIView *)view type: (WZMGestureRecognizerType)type {
    if (self.gesture) {
        self.gesture(view,type);
    }
}

#pragma mark - UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self scrollView:scrollView didChangeType:WZMScrollTypeBeginScroll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollView:scrollView didChangeType:WZMScrollTypeScrolling];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL stop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (stop) {
        [self scrollViewDidEndScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 停止类型3
        BOOL stop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (stop) {
            [self scrollViewDidEndScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView {
    [self scrollView:scrollView didChangeType:WZMScrollTypeEndScroll];
}

- (void)scrollView:(UIScrollView *)scrollView didChangeType:(WZMScrollType)type {
    if (self.scroll) {
        self.scroll(scrollView, type);
    }
}

#pragma mark - UIButton
- (void)btnClick:(UIButton *)btn {
    if (self.next) {
        self.next(btn);
    }
}

- (void)btnDown:(UIButton *)btn {
    [self btnTouch:btn event:UIControlEventTouchDown];
}

- (void)btnDownRepeat:(UIButton *)btn {
    [self btnTouch:btn event:UIControlEventTouchDownRepeat];
}

- (void)btnDragInside:(UIButton *)btn {
    [self btnTouch:btn event:UIControlEventTouchDragInside];
}

- (void)btnDragOutside:(UIButton *)btn {
    [self btnTouch:btn event:UIControlEventTouchDragOutside];
}

- (void)btnDragEnter:(UIButton *)btn {
    [self btnTouch:btn event:UIControlEventTouchDragEnter];
}

- (void)btnDragExit:(UIButton *)btn {
    [self btnTouch:btn event:UIControlEventTouchDragExit];
}

- (void)btnUpInside:(UIButton *)btn {
    [self btnTouch:btn event:UIControlEventTouchUpInside];
}

- (void)btnUpOutside:(UIButton *)btn {
    [self btnTouch:btn event:UIControlEventTouchUpOutside];
}

- (void)btnCancel:(UIButton *)btn {
    [self btnTouch:btn event:UIControlEventTouchCancel];
}

//private
- (void)btnTouch:(UIButton *)btn event:(UIControlEvents)event {
    if (self.event) {
        self.event(btn,event);
    }
}

#pragma mark - UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self textField:textField inputType:WZMTextInputTypeBegin];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self textField:textField inputType:WZMTextInputTypeEnd];
}

- (void)textFieldDidChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (![textField isKindOfClass:[UITextField class]]) return;
    [self textField:textField inputType:WZMTextInputTypeChange];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return [self textField:textField shouldType:WZMTextShouldTypeBegin];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return [self textField:textField shouldType:WZMTextShouldTypeEnd];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return [self textField:textField shouldType:WZMTextShouldTypeClear];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self textField:textField shouldType:WZMTextShouldTypeReturn];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textFieldShouldChange) {
        return self.textFieldShouldChange(textField,range,string);
    }
    return YES;
}

//private
- (void)textField:(UITextField *)textField inputType: (WZMTextInputType)type {
    if (self.textFieldInput) {
        self.textFieldInput(textField,type);
    }
}

- (BOOL)textField:(UITextField *)textField shouldType: (WZMTextShouldType)type {
    if (self.textFieldShould) {
        return self.textFieldShould(textField,type);
    }
    return YES;
}

#pragma mark - UITextView
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self textView:textView inputType:WZMTextInputTypeBegin];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self textView:textView inputType:WZMTextInputTypeEnd];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self textView:textView inputType:WZMTextInputTypeChange];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return [self textView:textView shouldType:WZMTextShouldTypeBegin];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return [self textView:textView shouldType:WZMTextShouldTypeEnd];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] || [text isEqualToString:@"\r"]) {
        return [self textView:textView shouldType:WZMTextShouldTypeReturn];
    }
    if (self.textViewShouldChange) {
        return self.textViewShouldChange(textView,range,text);
    }
    return YES;
}

//private
- (void)textView:(UITextView *)textView inputType: (WZMTextInputType)type {
    if (self.textFieldInput) {
        self.textViewInput(textView,type);
    }
}

- (BOOL)textView:(UITextView *)textView shouldType: (WZMTextShouldType)type {
    if (self.textViewShould) {
        return self.textViewShould(textView,type);
    }
    return YES;
}

#pragma mark - UIAlertView
#if WZM_APP
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.alert) {
        self.alert(alertView,buttonIndex);
    }
}
#endif

#pragma mark - reaction method
- (void)addObserverWithName:(NSString *)name sel:(SEL)sel obj:(id)obj {
    if ([self.names containsObject:name]) return;
    [self.names addObject:name];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:sel name:name object:obj];
}

- (void)removeObserver {
    if (self.names.count == 0) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [self removeObserver];
}

@end
