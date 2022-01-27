# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'apollo4' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for apollo4
  pod 'AWSMobileClient'     		# Required dependency
  pod 'AWSAuthUI'          	    	# Optional dependency required to use drop-in UI
  pod 'AWSUserPoolsSignIn'   		# Optional dependency required to use drop-in UI
  # Login with FB and Amplify/Cognito
  pod 'AWSFacebookSignIn'
  # Login with Google and Amplify/Cognito
  pod 'AWSGoogleSignIn'
  pod 'GoogleSignIn'
  pod 'Amplify'                          	# required amplify dependency
  pod 'Amplify/Tools'                     # allows to call amplify CLI from within Xcode

  pod 'AmplifyPlugins/AWSCognitoAuthPlugin' # support for Cognito user authentication
  pod 'AmplifyPlugins/AWSAPIPlugin'
  pod 'NotificationBannerSwift'
  
  target 'apollo4Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'apollo4UITests' do
    # Pods for testing
  end

end
