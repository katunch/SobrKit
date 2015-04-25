Pod::Spec.new do |s|
  s.name             = "SobrKit"
  s.version          = "0.1.0"
  s.summary          = "A collection of UIKit, Foundation and other extensions written in Swift"
  s.homepage         = "https://github.com/katunch/SobrKit"
  s.social_media_url = 'http://twitter.com/silasknobel'
  s.license          = 'MIT'
  s.author           = { "Silas Knobel" => "dev@katun.ch" }
  s.source           = { :git => "https://github.com/katunch/SobrKit.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  
  s.dependency 'Alamofire', '~> 1.2'
  s.source_files = 'SobrKit/*.swift'
  s.requires_arc = true
end