#
#  Be sure to run `pod spec lint MTJSONToNSObjectParser.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MTJSONToNSObjectParser"
  s.version      = "1.0.0"
  s.summary      = "Lightweight parser JSON to NSObject's models"
  s.license      = { :type => "BSD", :file => "FILE_LICENSE" }
  s.homepage     = "https://github.com/MetalheadSanya/MTJSONToNSObjectParser"
  s.authors      = {
    "Alexandr Zalutskiy" => "metalhead.sanya@gmail.com",
    "Artur Chernov " => "forgot10soul@gmail.com"
  }
  s.social_media_url   = "https://twitter.com/metalhead_sanya"
  s.source       = { :git => "https://github.com/MetalheadSanya/MTJSONToNSObjectParser.git", :tag => "1.0.0" }
  s.source_files  = "MTJSONToNSObjectParser/*.{h,m}"
  s.requires_arc = true
end
