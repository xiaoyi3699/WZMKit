//
//  WZMBaseInputView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/19.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMBaseInputView.h"

@interface WZMBaseInputView ()<UITextViewDelegate,UITextFieldDelegate>

///初始y值
@property (nonatomic, assign) CGFloat startY;

///保存子类实现的输入框, 用来弹出系统键盘
@property (nonatomic, strong) UITextView *inputView1;
@property (nonatomic, strong) UITextField *inputView2;

///顶部toolView, 输入框就在这个view上
@property (nonatomic, strong) UIView *toolView;
///自定义键盘, 须子类使用方法传入
@property (nonatomic, strong) NSArray<UIView *> *keyboards;
///当前键盘类型
@property (nonatomic, assign) WZMInputViewType type;
///当前键盘索引, -1为z系统键盘
@property (nonatomic, assign) NSInteger keyboardIndex;
///是否处于编辑状态, 自定义键盘模式也认定为编辑状态
@property (nonatomic, assign, getter=isEditing) BOOL editing;

@end

@implementation WZMBaseInputView

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self prepareInit];
        [self createViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self prepareInit];
        [self createViews];
    }
    return self;
}

- (void)prepareInit {
    self.startY = -1;
    self.editing = NO;
    self.keyboardIndex = -1;
    self.type = WZMInputViewTypeIdle;
    self.keyboards = [[NSMutableArray alloc] initWithCapacity:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardValueChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)createViews {
    self.backgroundColor = [UIColor whiteColor];
    self.startY = [self startYOfInputView];
    self.toolView = [self toolViewOfInputView];
    for (UIView *view in self.toolView.subviews) {
        if ([view isKindOfClass:[UITextView class]]) {
            self.inputView1 = (UITextView *)view;
            self.inputView1.delegate = self;
            break;
        }
        if ([view isKindOfClass:[UITextField class]]) {
            self.inputView2 = (UITextField *)view;
            self.inputView2.delegate = self;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.inputView2];
            break;
        }
    }
    [self addSubview:self.toolView];
    
    self.keyboards = [self keyboardsOfInputView];
    for (UIView *keyboard in self.keyboards) {
        keyboard.hidden = YES;
        [self addSubview:keyboard];
    }
}

#pragma mark - 监听键盘变化
- (void)keyboardValueChange:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    CGFloat duration = [dic[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect beginFrame = [dic[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect endFrame = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if (beginFrame.origin.y < endFrame.origin.y) {
        if (self.keyboardIndex == -1) {
            //系统键盘收回
            [self minYWillChange:self.startY duration:duration isFinishEditing:YES];
        }
        else {
            //自定义键盘弹出
            [self wzm_showKeyboardAtIndex:self.keyboardIndex duration:duration];
        }
    }
    else {
        //系统键盘弹出
        if (self.type == WZMInputViewTypeIdle) {
            [self didBeginEditing];
        }
        self.keyboardIndex = -1;
        self.type = WZMInputViewTypeSystem;
        CGFloat minY = endFrame.origin.y-self.toolView.bounds.size.height;
        [self minYWillChange:minY duration:duration isFinishEditing:NO];
    }
}

- (void)minYWillChange:(CGFloat)minY duration:(CGFloat)duration isFinishEditing:(BOOL)isFinishEditing {
    self.editing = !isFinishEditing;
    if (isFinishEditing) {
        self.keyboardIndex = -1;
        self.type = WZMInputViewTypeIdle;
        [self didEndEditing];
    }
    CGRect endFrame = self.frame;
    endFrame.origin.y = minY;
    [UIView animateWithDuration:duration animations:^{
        self.frame = endFrame;
    }];
    [self willChangeFrameWithDuration:duration];
}

///视图的初始y值
- (CGFloat)startYOfInputView {
    if (self.startY == -1) {
        self.startY = self.bounds.size.height;
    }
    return self.startY;
}

///子类设置toolView和keyboards
- (UIView *)toolViewOfInputView {
    return nil;
}

- (NSArray<UIView *> *)keyboardsOfInputView {
    return nil;
}

///开始编辑
- (void)didBeginEditing {
    
}

///结束编辑
- (void)didEndEditing {
    
}

///输入框值改变
- (void)valueDidChange {
    
}

///是否允许开始编辑
- (BOOL)shouldBeginEditing {
    return YES;
}

///是否允许结束编辑
- (BOOL)shouldEndEditing {
    return YES;
}

///是否允许点击return键
- (BOOL)shouldReturn {
    return YES;
}

///是否允许编辑
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

///视图frameb改变
- (void)willChangeFrameWithDuration:(CGFloat)duration {
    
}

#pragma mark - 键盘事件处理
- (void)showSystemKeyboard {
    if (self.type != WZMInputViewTypeSystem) {
        self.type = WZMInputViewTypeSystem;
        if (self.inputView1) {
            [self.inputView1 becomeFirstResponder];
        }
        else if (self.inputView2) {
            [self.inputView2 becomeFirstResponder];
        }
    }
}

//判断是否直接弹出自定义键盘
- (void)showKeyboardAtIndex:(NSInteger)index duration:(CGFloat)duration {
    if (index < 0 || index >= self.keyboards.count || self.keyboardIndex == index) return;
    if (self.type == WZMInputViewTypeSystem) {
        //由系统键盘弹出自定义键盘
        //系统键盘收回, 在键盘监听事件中弹出自定义键盘
        self.keyboardIndex = index;
        [self endEditing:YES];
    }
    else {
        self.keyboardIndex = index;
        //直接弹出自定义键盘
        [self wzm_showKeyboardAtIndex:index duration:duration];
    }
}

- (void)dismissKeyboard {
    if (self.type == WZMInputViewTypeIdle) return;
    if (self.type == WZMInputViewTypeSystem) {
        [self endEditing:YES];
    }
    else {
        for (UIView *view in self.keyboards) {
            view.hidden = YES;
        }
        [self minYWillChange:self.startY duration:0.25 isFinishEditing:YES];
    }
}

//直接弹出自定义键盘
- (void)wzm_showKeyboardAtIndex:(NSInteger)index duration:(CGFloat)duration {
    if (self.type == WZMInputViewTypeIdle) {
        [self didBeginEditing];
    }
    //直接弹出自定义键盘
    self.type = WZMInputViewTypeOther;
    UIView *k;
    for (NSInteger i = 0; i < self.keyboards.count; i ++) {
        UIView *other = [self.keyboards objectAtIndex:i];
        if (i == index) {
            other.hidden = NO;
            k = other;
        }
        else {
            other.hidden = YES;
        }
    }
    if (k) {
        CGFloat minY = self.startY-k.bounds.size.height;
        [self minYWillChange:minY duration:duration isFinishEditing:NO];
    }
}

//重设frame
- (void)reset:(UIView *)view y:(CGFloat)y {
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

- (NSString *)text {
    if (self.inputView1) {
        return self.inputView1.text;
    }
    if (self.inputView2) {
        return self.inputView2.text;
    }
    return nil;
}

- (void)setText:(NSString *)text {
    if (self.inputView1) {
        self.inputView1.text = text;
    }
    if (self.inputView2) {
        self.inputView2.text = text;
    }
}

#pragma mark - super method
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reset:self y:self.startY];
    }
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self didBeginEditing];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self didEndEditing];
}

- (void)textFieldDidChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (![textField isKindOfClass:[UITextField class]]) return;
    [self valueDidChange];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return [self shouldBeginEditing];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return [self shouldEndEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self shouldReturn];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self shouldChangeTextInRange:range replacementText:string];
}

#pragma mark - UITextView
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self didBeginEditing];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self didEndEditing];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self valueDidChange];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return [self shouldBeginEditing];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return [self shouldEndEditing];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] || [text isEqualToString:@"\r"]) {
        return [self shouldReturn];
    }
    return [self shouldChangeTextInRange:range replacementText:text];
}

- (void)dealloc {
    wzm_log(@"%@释放了",NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
