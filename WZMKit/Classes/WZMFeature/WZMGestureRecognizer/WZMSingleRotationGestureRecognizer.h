#import <UIKit/UIKit.h>

@interface WZMSingleRotationGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGRect activeRect;

@end
