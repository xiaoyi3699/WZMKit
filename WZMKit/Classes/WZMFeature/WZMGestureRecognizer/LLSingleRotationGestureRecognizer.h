#import <UIKit/UIKit.h>

@interface LLSingleRotationGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGRect activeRect;

@end
