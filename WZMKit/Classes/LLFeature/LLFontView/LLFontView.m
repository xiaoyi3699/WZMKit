//
//  LLFontView.m
//  JLChat
//
//  Created by WangZhaomeng on 2019/6/26.
//  Copyright © 2019 AiZhe. All rights reserved.
//

#import "LLFontView.h"
#import "LLLog.h"

@interface LLFontView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *fonts;
@property (nonatomic, strong) NSMutableArray *familys;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LLFontView 

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setConfig:CGRectZero];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setConfig:frame];
    }
    return self;
}

- (void)setConfig:(CGRect)rect {
    _familys = [[UIFont familyNames] mutableCopy];
    _fonts = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *blankFamilys = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *familyName in _familys) {
        NSArray *fonts = [UIFont fontNamesForFamilyName:familyName];
        if (fonts.count == 0) {
            [blankFamilys addObject:familyName];
        }
        else {
            [_fonts addObject:fonts];
        }
    }
    [_familys removeObjectsInArray:blankFamilys];
    
    rect.origin.x = 0;
    rect.origin.y = 0;
    self.tableView = [[UITableView alloc] initWithFrame:rect];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.tableView.frame = frame;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _fonts.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* fontArr = [_fonts objectAtIndex:section];
    return fontArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.backgroundView = [UIView new];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *fontName = [[_fonts objectAtIndex:section] objectAtIndex:row];
    cell.textLabel.text = @"字体展示abcABC123";
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:fontName size:15];
    NSString* fontFamilyName = [_familys objectAtIndex:section];
    fontFamilyName = [fontFamilyName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([fontFamilyName isEqualToString:@"Bodoni72Oldstyle"]) {
        fontFamilyName = @"BodoniSvtyTwoOSITCTT";
    }
    NSString* fontDetail = [fontName stringByReplacingOccurrencesOfString:fontFamilyName withString:@""];
    fontDetail = [fontDetail stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cell.detailTextLabel.text = fontDetail;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_familys objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString* fontName = [[_fonts objectAtIndex:section] objectAtIndex:row];
    
    ll_log(@"字体名称为：%@",fontName);
}

@end
