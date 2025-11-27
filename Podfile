# Uncomment the next line to define a global platform for your project
platform :ios, '26.0'

target 'weaning' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for weaning
  pod 'FirebaseAnalytics'
  pod 'FirebaseAppCheck'
  pod 'FirebaseAuth'
  pod 'FirebaseCrashlytics'
  pod 'FirebaseFirestore'
  pod 'FirebaseFirestoreSwift'
  pod 'FirebaseStorage'
  pod 'FirebaseStorageUI'
  pod 'HCVimeoVideoExtractor'
  pod 'ImageViewer.swift'
  pod 'ImageScrollView'
  pod 'RevenueCat'
  
  platform :ios, '26.0' # set IPHONEOS_DEPLOYMENT_TARGET for the pods project
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '26.0'
      end
      if target.name == 'BoringSSL-GRPC'
        target.source_build_phase.files.each do |file|
          if file.settings && file.settings['COMPILER_FLAGS']
            flags = file.settings['COMPILER_FLAGS'].split
            flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
            file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
    end
  end
end
end
end
