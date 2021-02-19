#import <UIKit/UIKit.h>

@interface WZMDrawView : UIView

///橡皮擦
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, getter=isEraser) BOOL eraser;

///画笔
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign, getter=isDotted) BOOL dotted;

///图片画笔
@property (nonatomic, strong) NSArray *hbImages;
@property (nonatomic, assign) CGFloat hbSize;
@property (nonatomic, assign) CGFloat spacing;

///public
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic, strong, readonly) NSMutableArray *lines;

- (void)recover;
- (void)backforward;

@end
