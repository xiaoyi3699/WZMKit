#import <UIKit/UIKit.h>

@interface WZMDrawView : UIView

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,strong,readonly) NSMutableArray *lines;

- (void)recover;
- (void)backforward;

@end
