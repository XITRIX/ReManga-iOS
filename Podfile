platform :ios, '16.0'

target 'ReManga' do
  use_frameworks!

  # Keep the Rx-based MvvmFoundation branch and its dependency graph together.
  # The upstream SPM package uses Combine and is not API-compatible with this app.
  pod 'MvvmFoundation', :path => 'submodules/MvvmFoundation'
  # XTBottomSheet does not have an upstream SPM manifest.
  pod 'XTBottomSheet', :path => 'submodules/XTBottomSheet'
  pod 'RxSwift', :path => 'submodules/RxSwift'
  pod 'RxCocoa', :path => 'submodules/RxSwift'
  pod 'RxRelay', :path => 'submodules/RxSwift'
  pod 'RxBiBinding', :path => 'submodules/RxBiBinding'
end

# Older podspecs declare deployment targets unsupported by current Xcode SDKs.
# Build the retained pods (including their privacy bundles) for the app's minimum.
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      deployment_target = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
      if deployment_target && Gem::Version.new(deployment_target) < Gem::Version.new('16.0')
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      end
    end
  end
end
