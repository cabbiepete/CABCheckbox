Pod::Spec.new do |s|

  s.name         = "CABCheckbox"
  s.version      = "0.0.1"
  s.summary      = "A resizeable checkbox for iOS apps."

  s.description  = <<-DESC
					A resizeable checkbox for iOS apps. I just needed something to work on all resolutions/device sizes fairly easily.
					DESC

  s.homepage     = "https://github.com/cabbiepete/CABCheckbox"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"


  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "Peter Simmons" => "cabbiepete@gmail.com" }
  s.social_media_url = "http://twitter.com/cabbiepete"

  s.platform     = :ios, '6.0'

  s.source       = { :git => "https://github.com/cabbiepete/CABCheckbox.git", :commit => "#{s.version}" }


  s.source_files  = 'Classes', 'Classes/**/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'

  s.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'

  s.requires_arc = true

end
