//
//  NSArray+AddPart.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/9/14.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "NSArray+LLAddPart.h"
#import "NSString+LLAddPart.h"
#import "LLEnum.h"

@implementation NSArray (LLAddPart)

- (id)ll_getRandomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (id)ll_getResultWithStyle:(LLTakingValueStyle)style {
    NSString *keyPath;
    if (style == LLTakingValueStyleMin) {
        //keyPath = @"@min.floatValue";
        keyPath = @"@min.self";
    }
    else if (style == LLTakingValueStyleMax) {
        //keyPath = @"@max.floatValue";
        keyPath = @"@max.self";
    }
    else if (style == LLTakingValueStyleAvg) {
        //keyPath = @"@avg.floatValue";
        keyPath = @"@avg.self";
    }
    else {
        //keyPath = @"@sum.floatValue";
        keyPath = @"@sum.self";
    }
    return [self valueForKeyPath:keyPath];
}

///谓词搜索
- (NSArray *)ll_searchWithKey:(NSString *)key{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",key];
    return [self filteredArrayUsingPredicate:predicate];
}

@end

@implementation NSMutableArray (LLAddPart)

+ (NSMutableArray *)ll_getEmojis {
    NSMutableArray *emojis = [[NSMutableArray alloc] initWithCapacity:0];
    for (unsigned int i = 0x1f600; i < 0x1f64f; i ++) {
        NSString *emjio = [NSString ll_getEmojiByIntCode:i];
        [emojis addObject:emjio];
    }
    return emojis;
}

+ (NSMutableArray *)ll_getEmojisBeginCode:(unsigned int)code1 endCode:(unsigned int)code2 {
    NSMutableArray *emojis = [[NSMutableArray alloc] initWithCapacity:0];
    for (unsigned int i = code1; i < code2; i ++) {
        NSString *emjio = [NSString ll_getEmojiByIntCode:i];
        [emojis addObject:emjio];
    }
    return emojis;
}

- (void)ll_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count-(i+1))];
    }
}

- (void)ll_shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end
