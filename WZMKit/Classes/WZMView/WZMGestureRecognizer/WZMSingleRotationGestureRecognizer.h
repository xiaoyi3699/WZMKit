#import <UIKit/UIKit.h>

@interface WZMSingleRotationGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) CGRect activeRect;
@property (nonatomic, assign, readonly) CGFloat rotation;

@end
