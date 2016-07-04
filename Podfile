# Uncomment this line to define a global platform for your project

source 'https://github.com/CocoaPods/Specs.git'
# TODO: github
source 'http://git.baijiahulian.com/app/specs.git'

# platform :ios, '9.0'

target 'LivePlayerDemo' do
    # Uncomment this line if you're using Swift or would like to use dynamic frameworks
    # use_frameworks!

    # Pods for LivePlayerDemo
    pod 'AFNetworking'
    pod 'FLEX', '~> 2.0', :configurations => ['Debug']
    pod 'Masonry'
    pod 'ReactiveCocoa'
    pod 'YYModel'
    # pod 'BJHL-LivePlayer-iOS'
    pod 'BJHL-LivePlayer-iOS', :git => 'http://git.baijiahulian.com/mobileliveplayer/liveplayer-iOS.git', :branch => 'dev'

    target 'LivePlayerDemoTests' do
        inherit! :search_paths
        # Pods for testing
    end

    target 'LivePlayerDemoUITests' do
        inherit! :search_paths
        # Pods for testing
    end

end
