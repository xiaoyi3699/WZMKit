//
//  ThirdViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()<UITextFieldDelegate>

@end

@implementation ThirdViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第三页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 200, 40)];
    textField.borderStyle = UIButtonTypeRoundedRect;
    textField.delegate = self;
    [self.view addSubview:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //最多10个字符
    NSInteger limitNums = 10;
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSString *language = self.textInputMode.primaryLanguage;
    if ([language isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        if (selectedRange) {
            return YES;
        }
    }
    if (textField.text.length < limitNums) {
        if (textField.text.length + string.length > limitNums) {
            textField.text = [textField.text stringByAppendingString:[string substringToIndex:(limitNums-textField.text.length)]];
            return NO;
        }
        else {
            return YES;
        }
    }
    return NO;
}

@end
