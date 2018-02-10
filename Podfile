source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

abstract_target 'TVGemistAbstract' do
    pod 'XCGLogger'
    pod 'SwiftLint'

    target 'TVGemist' do
        platform :tvos, '11.0'

        #pod 'NPOKit', :path => '../NPOKit'
        #pod 'GHKit', :path => '../GHKit'

        pod 'NPOKit', :git => 'https://github.com/4np/NPOKit.git', :tag => '0.0.4'
        pod 'GHKit', :git => 'https://github.com/4np/GHKit.git', :tag => '0.0.3'
    end

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            print "Setting #{target}'s SWIFT_VERSION to 4.0\n"
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
