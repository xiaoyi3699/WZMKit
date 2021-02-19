//
//  NSMutableAttributedString+wzmcate.m
//  test
//
//  Created by wangzhaomeng on 16/8/5.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "NSAttributedString+wzmcate.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (wzmcate)

- (UIBezierPath *)wzm_getBezierPath {
    CGMutablePathRef letters = CGPathCreateMutable();
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++) {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);

            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    CGRect boundingBox = CGPathGetBoundingBox(letters);
    CGPathRelease(letters);
    CFRelease(line);
    
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    return path;
}

@end

@implementation NSMutableAttributedString (wzmcate)

- (void)wzm_setImage:(UIImage *)image rect:(CGRect)rect range:(NSRange)range{
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = rect;
    NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
    [self replaceCharactersInRange:range withAttributedString:attStr];
}

- (void)wzm_insertImage:(UIImage *)image rect:(CGRect)rect index:(NSInteger)index{
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = rect;
    NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
    [self insertAttributedString:attStr atIndex:index];
}

- (void)wzm_addParagraphStyle:(NSParagraphStyle *)style{
    [self addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, 0)];
}

- (void)wzm_addLink:(NSString *)link range:(NSRange)range{
    NSURL *url = [NSURL URLWithString:link];
    [self addAttributes:@{NSLinkAttributeName:url} range:range];
}

- (void)wzm_addForegroundColor:(UIColor *)color range:(NSRange)range{
    [self addAttributes:@{NSForegroundColorAttributeName:color} range:range];
}

- (void)wzm_addFont:(UIFont *)font range:(NSRange)range{
    [self addAttributes:@{NSFontAttributeName:font} range:range];
}

- (void)wzm_addSingleDeletelineColor:(UIColor *)color range:(NSRange)range{
    [self addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                          NSStrikethroughColorAttributeName:color}
                  range:range];
}

- (void)wzm_addSingleUnderlineColor:(UIColor *)color range:(NSRange)range{
    NSUnderlineStyle style = NSUnderlineStyleSingle | NSUnderlinePatternDot;
    [self addAttributes:@{NSUnderlineStyleAttributeName:@(style)} range:range];
    [self addAttributes:@{NSUnderlineColorAttributeName:color} range:range];
}

- (void)wzm_addDoubleUnderlineColor:(UIColor *)color range:(NSRange)range{
    NSUnderlineStyle style = NSUnderlineStyleSingle;
    //虚线
    //style = NSUnderlineStyleSingle | NSUnderlinePatternDot;
    [self addAttributes:@{NSUnderlineStyleAttributeName:@(style)} range:range];
    [self addAttributes:@{NSUnderlineColorAttributeName:color} range:range];
}

- (void)wzm_addStrokeWidth:(CGFloat)width range:(NSRange)range{
    [self addAttribute:NSStrokeWidthAttributeName value:@(width) range:range];
}

- (void)wzm_addTextEffectWithRange:(NSRange)range{
    [self addAttributes:@{NSTextEffectAttributeName: NSTextEffectLetterpressStyle} range:range];
}

@end
