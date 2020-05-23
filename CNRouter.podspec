
Pod::Spec.new do |s|

  s.name         = "CNRouter"
  s.version      = "0.0.1"
  s.summary      = "CNRouter"

  s.homepage     = "https://github.com/haixi595282775/CNRouter"
  s.license      = "MIT"
  s.author       = { "caven" => "595282775@qq.com" }

  s.source       = { :git => "git@github.com:haixi595282775/CNRouter.git", :tag => "#{s.version}" }
  s.source_files  = "CNRouter/**/*.{h,m}"

  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
  
  s.requires_arc = true
  s.ios.deployment_target = "9.0"
  s.frameworks = "Foundation", "UIKit"

end
