#import <UIKit/UIKit.h>

@interface WZMEraserView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic, strong, readonly) NSMutableArray *lines;

- (void)recover;
- (void)backforward;

@end
