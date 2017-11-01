

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "FCXUni"
  s.version      = "0.0.1"
  s.summary      = "FCX's FCXUni."
  s.description  = <<-DESC
                    FCXUni of FCX
                   DESC

  s.homepage     = "https://github.com/FCXPods/FCXUni"

  s.license      = "MIT"

  s.author             = { "fengchuanxiang" => "fengchuanxiang@126.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/FCXPods/FCXUni.git", :tag => "0.0.1" }


  s.source_files  = "FCXCategory/*.{h,m}", "FCXConfig/*.{h,m}", "FCXFoundation/*.{h,m}", "FCXUIKit/*.{h,m}", "FCXShare/*.{h,m}", "MTA/*.h"
  s.resources = "FCXShare/ShareIcon/*.png"
  s.vendored_libraries = "MTA/*.a"
  s.vendored_frameworks = "UMOnlineConfig/UMOnlineConfig.framework", "QuartzCore", "Security", "CFNetwork", "SystemConfiguration", "CoreTelephony", "Foundation", "CoreGraphics"
  s.libraries = "z", "iconv", "sqlite3"


  s.dependency "UMengAnalytics", "~> 4.2.4"
  s.dependency "AlicloudFeedback", "~> 3.2.0"
  s.dependency "UMengUShare/Social/Sina", "~> 6.4.6"
  s.dependency "UMengUShare/Social/WeChat", "~> 6.4.6"
  s.dependency "UMengUShare/Social/QQ", "~> 6.4.6"
  s.dependency "UMengUShare/Social/SMS", "~> 6.4.6"

end
