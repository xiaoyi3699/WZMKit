#import <UIKit/UIKit.h>

@interface LLDrawView : UIView

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,assign) CGFloat lineWidth;

- (void)recover;
- (void)backforward;

@end
