# WZMKit

[![CI Status](https://img.shields.io/travis/wangzhaomeng/WZMKit.svg?style=flat)](https://travis-ci.org/wangzhaomeng/WZMKit)
[![Version](https://img.shields.io/cocoapods/v/WZMKit.svg?style=flat)](https://cocoapods.org/pods/WZMKit)
[![License](https://img.shields.io/cocoapods/l/WZMKit.svg?style=flat)](https://cocoapods.org/pods/WZMKit)
[![Platform](https://img.shields.io/cocoapods/p/WZMKit.svg?style=flat)](https://cocoapods.org/pods/WZMKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

WZMKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WZMKit'
```

## Author

wangzhaomeng, 122589615@qq.com

## License

WZMKit is available under the MIT license. See the LICENSE file for more info.

/* 快速掌握WZMKit的基础使用类库和常用方法 */

/*
------------------------------------------------------
====================↓ 常用类库举例 ↓====================
------------------------------------------------------

📂 WZMImageCache: 网络图片缓存
📂 WZMRefresh: 上拉加载、下拉刷新
📂 WZMNetWorking: 网络请求(GET POST PUT DELETE等等)
📂 WZMGifImageView: GIF展示, 优化了GIF图片的内存占用
📂 WZMPhotoBrowser: 图片浏览器, 支持网络或本地, 支持GIF
📂 WZMPlayer: 高度自定义音/视频播放, 支持播放状态回调
📂 WZMVideoPlayerView: 一个功能齐全的视频播放器
📂 WZMReaction: 仿rac, 响应式交互, 使用block方式回调

------------------------------------------------------
====================↓ 常用方法举例 ↓====================
------------------------------------------------------

强弱引用:
@wzm_weakify(self)
@wzm_strongify(self)

UIImage扩展:
+[wzm_getImageByColor:]
+[wzm_getImageByBase64:]
+[wzm_getScreenImageByView:]
-[wzm_savedToAlbum]
-[wzm_getColorAtPixel:]

UIColor扩展:
+[wzm_getColorByHex:]
+[wzm_getColorByImage:]

UIView扩展:
view.wzm_cornerRadius
view.wzm_viewController
view.wzm_width、.wzm_height、.wzm_minX、.wzm_minY
-[wzm_colorWithPoint:]
-[wzm_savePDFToDocumentsWithFileName:]

NSObject扩展:
[self className]
[NSObject className]

NSString扩展:
+[wzm_isBlankString:]
-[wzm_getMD5]
-[wzm_getUniEncode]
-[wzm_getURLEncoded]、
-[wzm_getPinyin]、
-[wzm_base64EncodedString]

宏定义:
WZM_IS_iPad、WZM_IS_iPhone
WZM_SCREEN_WIDTH、WZM_SCREEN_HEIGHT
WZM_APP_NAME、WZM_APP_VERSION
WZM_R_G_B(50,50,50)

...等等扩展类便捷方法、宏定义、自定义

------------------------------------------------------
======================== 结束 =========================
------------------------------------------------------
*/
