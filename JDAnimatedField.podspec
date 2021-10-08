
Pod::Spec.new do |s|
  s.name         = "JDTextField"
  s.version      = "1.0.0"
  s.summary      = "JDAnimatedTextField framework"
  s.description  = <<-DESC
                  JDAnimatedTextField can enhance user experience UX of the application with animated textField
                   DESC
  s.homepage     = "https://github.com/jwd-ali/IOS-Portfolio"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Jawad Ali" => "L060214@gmail.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/jwd-ali/JDAnimatedTextField.git", :tag => "#{s.version}" }

  s.source_files = "Sources/**/*.{h,m,swift}"
  s.swift_version = "5.0"
end
