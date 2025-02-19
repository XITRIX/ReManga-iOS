# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ReManga' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ReManga
  pod 'MvvmFoundation', :path => 'submodules/MvvmFoundation'
  pod 'XTBottomSheet', :path => 'submodules/XTBottomSheet'
  pod 'Kingfisher', :path => 'submodules/Kingfisher'
  pod 'RxSwift', :path => 'submodules/RxSwift'
  pod 'RxCocoa', :path => 'submodules/RxSwift'
  pod 'RxRelay', :path => 'submodules/RxSwift'
  pod 'MarqueeLabel', :path => 'submodules/MarqueeLabel'
  pod 'UIImageColors'

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end

