//
//  LLReactionManager.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "LLReactionManager.h"
#import "LLLog.h"

@interface LLReactionManager ()

@property (nonatomic, strong) NSMutableArray *names;

@end

@implementation LLReactionManager

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
    [self gestureView:gesture.view type:LLGestureRecognizerTypeSingle];
}

- (void)doubleGestureRecognizer:(UITapGestureRecognizer *)gesture {
    [self gestureView:gesture.view type:LLGestureRecognizerTypeDouble];
}

- (void)longGestureRecognizer:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self gestureView:gesture.view type:LLGestureRecognizerTypeLong];
    }
}

//private
- (void)gestureView:(UIView *)view type:(LLGestureRecognizerType)type {
    if (self.gesture) {
        self.gesture(view,type);
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
    [self textField:textField inputType:LLTextInputTypeBegin];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self textField:textField inputType:LLTextInputTypeEnd];
}

- (void)textFieldDidChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (![textField isKindOfClass:[UITextField class]]) return;
    [self textField:textField inputType:LLTextInputTypeChange];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return [self textField:textField shouldType:LLTextShouldTypeBegin];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return [self textField:textField shouldType:LLTextShouldTypeEnd];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return [self textField:textField shouldType:LLTextShouldTypeClear];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self textField:textField shouldType:LLTextShouldTypeReturn];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textFieldShouldChange) {
        return self.textFieldShouldChange(textField,range,string);
    }
    return YES;
}

//private
- (void)textField:(UITextField *)textField inputType:(LLTextInputType)type {
    if (self.textFieldInput) {
        self.textFieldInput(textField,type);
    }
}

- (BOOL)textField:(UITextField *)textField shouldType:(LLTextShouldType)type {
    if (self.textFieldShould) {
        return self.textFieldShould(textField,type);
    }
    return YES;
}

#pragma mark - UITextView
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self textView:textView inputType:LLTextInputTypeBegin];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self textView:textView inputType:LLTextInputTypeEnd];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self textView:textView inputType:LLTextInputTypeChange];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return [self textView:textView shouldType:LLTextShouldTypeBegin];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return [self textView:textView shouldType:LLTextShouldTypeEnd];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] || [text isEqualToString:@"\r"]) {
        return [self textView:textView shouldType:LLTextShouldTypeReturn];
    }
    if (self.textViewShouldChange) {
        return self.textViewShouldChange(textView,range,text);
    }
    return YES;
}

//private
- (void)textView:(UITextView *)textView inputType:(LLTextInputType)type {
    if (self.textFieldInput) {
        self.textViewInput(textView,type);
    }
}

- (BOOL)textView:(UITextView *)textView shouldType:(LLTextShouldType)type {
    if (self.textViewShould) {
        return self.textViewShould(textView,type);
    }
    return YES;
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.alert) {
        self.alert(alertView,buttonIndex);
    }
}

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
    ll_log(@"%@释放了",NSStringFromClass(self.class));
    [self removeObserver];
}

@end
