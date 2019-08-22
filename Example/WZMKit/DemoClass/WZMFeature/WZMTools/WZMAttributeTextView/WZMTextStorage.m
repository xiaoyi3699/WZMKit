//
//  WZMTextStorage.m
//  textkit
//
//  Created by Mr.Wang on 16/12/19.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMTextStorage.h"

@implementation WZMTextStorage {
    NSMutableAttributedString *_storingText; //存储的文字
    BOOL _dynamicTextNeedsUpdate;            //文字是否需要更新
    NSDictionary *_replacements;             //正则表达式与富文本属性的映射字典
    NSDictionary *_normalAttributes;         //富文本的默认属性
}

-(id)init{
    self = [super init];
    if (self) {
        _storingText = [[NSMutableAttributedString alloc] init];
        [self createMarkupStyledPatterns];
    }
    return self;
}

#pragma mark - 重写父类的4个方法
//1、返回保存的文字
-(NSString *)string{
    return [_storingText string];
}

//2、获取指定范围内的文字属性
-(NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range{
    return [_storingText attributesAtIndex:location effectiveRange:range];
}

//3、设置指定范围内的文字属性
-(void)setAttributes:(NSDictionary *)attrs range:(NSRange)range{
    [self beginEditing];
    [_storingText setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

//4、修改指定范围内的文字
-(void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [self beginEditing];
    [_storingText replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedAttributes | NSTextStorageEditedCharacters range:range changeInLength:str.length - range.length];
    _dynamicTextNeedsUpdate = YES;
    [self endEditing];
}

#pragma mark - 富文本处理
-(void)processEditing {
    if (_dynamicTextNeedsUpdate) {
        _dynamicTextNeedsUpdate = NO;
        [self performReplacementsForRange:NSMakeRange(0, self.length)];
    }
    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange {
    NSRange extendedRange = NSUnionRange(changedRange, [[_storingText string]
                                                lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    [self applyStylesToRange:extendedRange];
}

//创建正则及其对应的富文本属性
- (void)createMarkupStyledPatterns{
    _normalAttributes              = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *URLAttributes    = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    NSDictionary *cutAttributes    = @{NSForegroundColorAttributeName:[UIColor redColor]};
    
    NSString *URLExpression = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSString *cutExpression = @"#(.*?)#";
    
    _replacements = @{URLExpression:URLAttributes,
                      cutExpression:cutAttributes};
}

//使用正则替换富文本
- (void)applyStylesToRange:(NSRange)searchRange{
    [self addAttributes:_normalAttributes range:NSMakeRange(0, _storingText.length)];
    for (NSString *key in _replacements) {
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:key
                                      options:0
                                      error:nil];
        NSDictionary* attributes = _replacements[key];
        [regex enumerateMatchesInString:[_storingText string]
                                options:0
                                  range:searchRange
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                                 [self addAttributes:attributes range:match.range];
                             }];
    }
}

@end
