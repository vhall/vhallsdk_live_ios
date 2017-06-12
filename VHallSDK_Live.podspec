Pod::Spec.new do |s|
  s.name         = "VHallSDK_Live"
  s.version      = "2.9.0"
  s.summary      = "VHallSDK for IOS"
  s.homepage     = "https://github.com/vhall/vhallsdk_live_ios"
  s.license      = "MIT"
  s.author       = { 'vhall20' => 'xiaoxiang.wang@vhall.com' }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/vhall/vhallsdk_live_ios.git", :tag => s.version }
  s.source_files  = "VHallSDK/*"
  s.frameworks = "AVFoundation", "VideoToolbox","OpenAL","CoreMedia","CoreTelephony" ,"OpenGLES" ,"MediaPlayer" ,"AssetsLibrary","QuartzCore" ,"JavaScriptCore","Security"
  s.libraries = 'icucore' ,'iconv','bz2.1.0','z'
  s.vendored_libraries = "VHallSDK/libVHallSDK.a", "VHallSDK/libVHLivePlay.a","VHallSDK/libVhallLiveApi.a"
  s.requires_arc = true
end

