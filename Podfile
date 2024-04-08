# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'godot-ios-firebase-analytics' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for godot-ios-firebase-analytics
  # # Add the Firebase pod for Google Analytics
  pod 'FirebaseAnalytics'

  # For Analytics without IDFA collection capability, use this pod instead
  # pod ‘Firebase/AnalyticsWithoutAdIdSupport’

  # Add the pods for any other Firebase products you want to use in your app
  # For example, to use Firebase Authentication and Cloud Firestore
  pod 'FirebaseCrashlytics'
  pod 'FirebaseAuth'
  pod 'FirebaseUI/Auth'
  pod 'FirebaseUI/Google'
  pod 'FirebaseUI/OAuth'
  pod 'GoogleSignIn'
  #pod 'Firebase/Firestore'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
