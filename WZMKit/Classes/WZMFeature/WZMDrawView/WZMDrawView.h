#import <UIKit/UIKit.h>

@interface WZMDrawView : UIView

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,assign) CGFloat lineWidth;

- (void)recover;
- (void)backforward;

@end
