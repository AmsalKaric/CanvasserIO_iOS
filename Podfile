platform :ios, '8.2'

pod 'p2.OAuth2', :git => 'https://github.com/p2/OAuth2', :submodules => true
pod 'Alamofire', '~> 4.3’
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'FBSDKCoreKit', '4.8.0'
pod 'FBSDKLoginKit', '4.8.0'
pod 'FBSDKShareKit', '4.8.0'
pod 'KeychainAccess'
pod 'Dollar'
pod 'FLAnimatedImage', '~> 1.0'
pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift2'
pod 'KFSwiftImageLoader', '~> 2.0'
pod 'XCGLogger'
pod 'RealmSwift'
pod 'Heap'
pod 'Parse'
pod 'HockeySDK'
pod 'SCLAlertView'

def testing_pods
    pod 'Quick'
    pod 'Nimble', '2.0.0'
end

target 'FieldTheBernTests' do
    testing_pods
end

target 'FieldTheBernUITests' do
    testing_pods
end

use_frameworks!