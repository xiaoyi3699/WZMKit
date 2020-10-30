
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WZMMosaicViewType) {
    //滤镜实现
    WZMMosaicViewTypeFilterBlur = 0, //模糊
    WZMMosaicViewTypeFilterMosaic,   //马赛克
    WZMMosaicViewTypeFilterSepia,    //色调
    //代码实现
    WZMMosaicViewTypeCodeBlur,       //模糊
    WZMMosaicViewTypeCodeMosaic,
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
@property (nonatomic, strong, readonly) NSMutableArray *lines;

///清空
- (void)recover;
///撤销
- (void)backforward;

@end
