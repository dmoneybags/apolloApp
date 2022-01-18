# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'apollo4' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for apollo4
  pod 'AWSMobileClient', '~> 2.26.6'      # Required dependency
  pod 'AWSAuthUI'          	        # Optional dependency required to use drop-in UI
  pod 'AWSUserPoolsSignIn', '~> 2.26.6'   # Optional dependency required to use drop-in UI
  # Login with FB and Amplify/Cognito
  pod 'AWSFacebookSignIn', '~> 2.26.6'
  # Login with Google and Amplify/Cognito
  pod 'AWSGoogleSignIn', '~> 2.26.6'
  pod 'GoogleSignIn', '~> 4.0'
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
