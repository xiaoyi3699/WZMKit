//
//  LLReactionManager.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLEnum.h"

typedef void(^nextAction)(id param_);
typedef void(^alertAction)(UIAlertView *alert_, NSInteger index_);
typedef void(^eventAction)(UIButton *button_, UIControlEvents event_);
typedef void(^gestureAction)(UIView *view_, LLGestureRecognizerType gesture_);
typedef void(^textFieldInputAction)(UITextField *textField_, LLTextInputType textInput_);
typedef BOOL(^textFieldShouldAction)(UITextField *textField_, LLTextShouldType textShould_);
typedef BOOL(^textFieldShouldChangeAction)(UITextField *textField_, NSRange range_, NSString *string_);
typedef void(^textViewInputAction)(UITextView *textView_, LLTextInputType textInput_);
typedef BOOL(^textViewShouldAction)(UITextView *textView_, LLTextShouldType textShould_);
typedef BOOL(^textViewShouldChangeAction)(UITextView *textView_, NSRange range_, NSString *string_);
@interface LLReactionManager : NSObject<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic, copy) nextAction next;
@property (nonatomic, copy) alertAction alert;
@property (nonatomic, copy) eventAction event;
@property (nonatomic, copy) gestureAction gesture;
@property (nonatomic, copy) textFieldInputAction textFieldInput;
@property (nonatomic, copy) textFieldShouldAction textFieldShould;
@property (nonatomic, copy) textFieldShouldChangeAction textFieldShouldChange;
@property (nonatomic, copy) textViewInputAction textViewInput;
@property (nonatomic, copy) textViewShouldAction textViewShould;
@property (nonatomic, copy) textViewShouldChangeAction textViewShouldChange;

#pragma mark - UIView
- (void)gestureRecognizer:(UIGestureRecognizer *)gesture;
- (void)singleGestureRecognizer:(UITapGestureRecognizer *)gesture;
- (void)doubleGestureRecognizer:(UITapGestureRecognizer *)gesture;
- (void)longGestureRecognizer:(UILongPressGestureRecognizer *)gesture;

#pragma mark - UIButton
- (void)btnClick:(UIButton *)btn;
- (void)btnDown:(UIButton *)btn;
- (void)btnDownRepeat:(UIButton *)btn;
- (void)btnDragInside:(UIButton *)btn;
- (void)btnDragOutside:(UIButton *)btn;
- (void)btnDragEnter:(UIButton *)btn;
- (void)btnDragExit:(UIButton *)btn;
- (void)btnUpInside:(UIButton *)btn;
- (void)btnUpOutside:(UIButton *)btn;
- (void)btnCancel:(UIButton *)btn;

#pragma mark - UITextField
- (void)textFieldDidChange:(NSNotification *)notification;

#pragma mark - reaction method
- (void)addObserverWithName:(NSString *)name sel:(SEL)sel obj:(id)obj;

@end
