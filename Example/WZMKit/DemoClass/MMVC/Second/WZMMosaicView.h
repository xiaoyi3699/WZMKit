
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WZMMosaicViewType) {
    WZMMosaicViewTypeMosaic = 0, //马赛克
    WZMMosaicViewTypeBlur,       //高斯模糊
    WZMMosaicViewTypeSepia,      //色调
};

@interface WZMMosaicView : UIView

///图片
@property (nonatomic, strong) UIImage *image;
///马赛克图片 可为空
@property (nonatomic, strong) UIImage *mosaicImage;
///马赛克线宽
@property (nonatomic, assign) CGFloat lineWidth;
///样式
@property (nonatomic, assign) WZMMosaicViewType type;
///线条
@property (nonatomic, strong, readonly) NSMutableArray *linesArray;

- (void)recover;
- (void)backforward;

@end
