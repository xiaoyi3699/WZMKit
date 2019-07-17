#
# Be sure to run `pod lib lint WZMKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WZMKit'
  s.version          = '0.1.3'
  s.summary          = 'WZMKit简介:'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
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
  @wzm_weakify(self)、@wzm_strongify(self)
  [UIImage wzm_imageByColor]、WZM_R_G_B(50,50,50)
  view.wzm_width、.wzm_height、.wzm_minX、.wzm_minY
  ...等等扩展类便捷方法、宏定义、自定义
  ------------------------------------------------------
  ======================== 结束 =========================
  ------------------------------------------------------
                       DESC

  s.homepage         = 'https://github.com/wangzhaomeng/WZMKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangzhaomeng' => '122589615@qq.com' }
  s.source           = { :git => 'https://github.com/wangzhaomeng/WZMKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WZMKit/Classes/**/*'
  
  s.resource_bundles = {
    'WZMKit' => ['WZMKit/Assets/*.*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
