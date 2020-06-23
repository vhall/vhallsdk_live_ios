Pod::Spec.new do |s|
  s.name         = "VHallSDK_Live"
  s.version      = "3.4.7"
  s.summary      = "VHallSDK for IOS"
  s.homepage     = "https://github.com/vhall/vhallsdk_live_ios"
  s.license      = "MIT"
  s.author       = { 'vhall' => 'xiaoxiang.wang@vhall.com' }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/vhall/vhallsdk_live_ios.git", :tag => s.version }
  s.source_files  = "VHallSDK/*"
  s.frameworks = "AVFoundation", "VideoToolbox","OpenAL","CoreMedia","CoreTelephony" ,"OpenGLES" ,"MediaPlayer" ,"AssetsLibrary","QuartzCore" ,"JavaScriptCore","Security"
  s.libraries = 'icucore' ,'iconv','bz2.1.0','z','xml2.2','c++'
  s.vendored_libraries = "VHallSDK/libVHallSDK.a"
  s.vendored_frameworks = "VHallSDK/VhallLiveBaseApi.framework"
  s.requires_arc = true
end

