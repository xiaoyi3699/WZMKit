#import <UIKit/UIKit.h>

@interface WZMDrawView : UIView

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,strong,readonly) NSMutableArray *lines;
@property (nonatomic,assign,getter=isDotted) BOOL dotted;

- (void)recover;
- (void)backforward;

@end
