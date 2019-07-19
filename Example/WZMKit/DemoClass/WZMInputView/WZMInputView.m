//
//  WZMInputView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/19.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMInputView.h"
#import "WZMChatBtn.h"

typedef enum : NSUInteger {
    WZMInputViewTypeIdle = 0, //闲置状态
    WZMInputViewTypeSystem,   //系统键盘
    WZMInputViewTypeOther,    //自定义键盘
} WZMInputViewType;

@interface WZMInputView ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) WZMInputViewType type;
@property (nonatomic, assign) NSInteger keyboardIndex;
@property (nonatomic, assign, getter=isEditing) BOOL editing;

@end

@implementation WZMInputView {
    
}

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
}

- (void)wzm_resignFirstResponder {
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

#pragma mark - 监听键盘变化
- (void)keyboardValueChange:(NSNotification *)notification {
    if (_textView.isFirstResponder == NO) return;
    NSDictionary *dic = notification.userInfo;
    CGFloat duration = [dic[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect endFrame = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if (endFrame.origin.y == self.bounds.size.height) {
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
        if (self.type == WZMInputViewTypeOther) {
            //隐藏之前的keyboard
            UIView *k = [self.keyboards objectAtIndex:self.keyboardIndex];
            k.hidden = YES;
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
        self.type = WZMInputViewTypeIdle;
    }
    CGRect endFrame = self.frame;
    endFrame.origin.y = minY;
    [UIView animateWithDuration:duration animations:^{
        self.frame = endFrame;
    }];
    if ([self.delegate respondsToSelector:@selector(inputView:willChangeFrameWithDuration:isEditing:)]) {
        [self.delegate inputView:self willChangeFrameWithDuration:duration isEditing:self.isEditing];
    }
}

#pragma mark - 键盘事件处理
- (void)showSystemKeyboard {
    if (self.type != WZMInputViewTypeSystem) {
        self.type = WZMInputViewTypeSystem;
        [self.textView becomeFirstResponder];
    }
}

- (void)dismissKeyboard {
    if (self.type == WZMInputViewTypeIdle) return;
    if (self.type == WZMInputViewTypeSystem) {
        //系统键盘收回
        [self endEditing:YES];
    }
    else {
        //自定义键盘收回
        [self minYWillChange:self.startY duration:0.3 isFinishEditing:YES];
    }
    self.keyboardIndex = -1;
    self.type = WZMInputViewTypeIdle;
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
        if (self.type == WZMInputViewTypeOther) {
            //隐藏之前的keyboard
            UIView *k = [self.keyboards objectAtIndex:self.keyboardIndex];
            k.hidden = YES;
        }
        self.keyboardIndex = index;
        //直接弹出自定义键盘
        [self wzm_showKeyboardAtIndex:index duration:duration];
    }
}

//直接弹出系统键盘
- (void)wzm_showKeyboardAtIndex:(NSInteger)index duration:(CGFloat)duration {
    //直接弹出自定义键盘
    self.type = WZMInputViewTypeOther;
    UIView *k = [self.keyboards objectAtIndex:self.keyboardIndex];
    k.hidden = NO;
    CGFloat minY = self.startY-k.bounds.size.height;
    [self minYWillChange:minY duration:duration isFinishEditing:NO];
}

#pragma mark - private method
//tool按钮交互
- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        [self wzm_resignFirstResponder];
    }
    else if (btn.tag == 1) {
        [self showKeyboardAtIndex:0 duration:0.3];
    }
    else {
        [self showKeyboardAtIndex:1 duration:0.3];
    }
}

//重设frame
- (void)reset:(UIView *)view y:(CGFloat)y {
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

#pragma mark - super method
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        if (self.startY == -1) {
            self.startY = self.bounds.size.height;
        }
        [self reset:self y:self.startY];
    }
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - getter setter
- (UIView *)toolView {
    if (_toolView == nil) {
        CGFloat toolW = self.bounds.size.width;
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, toolW, 50)];
        _toolView.backgroundColor = [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(40, 7, toolW-120, 35)];
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.textColor = [UIColor darkTextColor];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.delegate = self;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 2;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1].CGColor;
        [_toolView addSubview:_textView];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
        NSArray *images = @[@"wzm_chat_voice",@"wzm_chat_emotion",@"wzm_chat_more"];//ll_chat_board
        UIImage *keyboardImg = [UIImage imageNamed:@"wzm_chat_board"];
        for (NSInteger i = 0; i < 3; i ++) {
            WZMChatBtn *btn = [WZMChatBtn chatButtonWithType:WZMChatButtonTypeInput];
            if (i == 0) {
                btn.frame = CGRectMake(0, 4.5, 40, 40);
            }
            else if (i == 1) {
                btn.frame = CGRectMake(toolW-80, 4.5, 40, 40);
            }
            else {
                btn.frame = CGRectMake(toolW-40, 4.5, 40, 40);
            }
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [btn setImage:keyboardImg forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_toolView addSubview:btn];
            [array addObject:btn];
        }
    }
    return _toolView;
}

- (void)dealloc {
    wzm_log(@"%@释放了",NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
