

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


  s.source_files  = "FCXCategory/*.{h,m}", "FCXConfig/*.{h,m}", "FCXFoundation/*.{h,m}", "FCXUIKit/*.{h,m}"

  s.dependency "UMengAnalytics", "~> 4.1.8"
  s.dependency "UMengFeedback", "~> 2.3.4"

end
