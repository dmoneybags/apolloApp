# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'apollo4' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for apollo4
  pod 'Amplify', '~> 1.0'                             # required amplify dependency
  pod 'Amplify/Tools', '~> 1.0'                       # allows to call amplify CLI from within Xcode

  pod 'AmplifyPlugins/AWSCognitoAuthPlugin', '~> 1.0' # support for Cognito user authentication
  pod 'AmplifyPlugins/AWSAPIPlugin', '~> 1.0'
  pod 'NotificationBannerSwift', '~> 3.0.0'
  target 'apollo4Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'apollo4UITests' do
    # Pods for testing
  end

end
