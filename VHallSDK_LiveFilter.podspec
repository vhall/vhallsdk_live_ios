Pod::Spec.new do |s|
  s.name         = "VHallSDK_LiveFilter"
  s.version      = "2.8.0"
  s.summary      = "VHallSDK for IOS"
  s.homepage     = "https://github.com/vhall/vhallsdk_live_ios"
  s.license      = "MIT"
  s.author       = { 'vhall20' => 'xiaoxiang.wang@vhall.com' }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/vhall/vhallsdk_live_ios.git", :tag => s.version }
  s.source_files  = "VHallSDK/*" ,"VHallSDK/VHallFilterSDK/*"
  s.frameworks = "AVFoundation", "VideoToolbox","OpenAL","CoreMedia","CoreTelephony" ,"OpenGLES" ,"MediaPlayer" ,"AssetsLibrary","QuartzCore" ,"JavaScriptCore","Security"
  s.libraries = 'icucore' ,'iconv','bz2.1.0','z'
  s.vendored_libraries = "VHallSDK/libVHallSDK.a", "VHallSDK/libVHLivePlay.a", "VHallSDK/libVinnyLive.a" ,"VHallSDK/VHallFilterSDK/libGPUImage.a","VHallSDK/VHallFilterSDK/libVHallFilterSDK.a","VHallSDK/libVhallLiveApi.a","VHallSDK/kodak.inf"
  s.requires_arc = true
end

