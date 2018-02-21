
Pod::Spec.new do |s|
  s.name         = "RNUnityBridge"
  s.version      = "1.0.0"
  s.summary      = "RNUnityBridge"
  s.description  = <<-DESC
                  RNUnityBridge
                   DESC
  s.homepage     = "https://github.com/jim-lake/react-native-unity-bridge"
  s.license      = "MIT"
  s.author       = { "author" => "jim@blueskylabs.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/jim-lake/react-native-unity-bridge.git", :tag => "master" }
  s.source_files  = "ios/**/*.{h,m}"
  s.requires_arc = true

  s.dependency "React"

end
