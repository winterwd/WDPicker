#
# Be sure to run `pod lib lint WDPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WDPicker'
  s.version          = '0.1.2'
  s.summary          = 'A Picker for UI tools'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://www.jianshu.com/u/06f42a993882'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'winter' => 'winterw201501@gmail.com' }
  s.source           = { :git => 'https://git.thy360.com/ios-compose/jh_picker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.subspec 'WDatePicker' do |ss|
  	ss.source_files = 'WDPicker/Classes/WDatePicker/*.{h,m}'
  end

  s.subspec 'WDAreaPicker' do |ss|
  	ss.source_files = 'WDPicker/Classes/WDAreaPicker/*.{h,m}'
  	ss.resource_bundles = {
    	'WDAreaPicker' => ['WDPicker/Assets/*.plist']
  	}
  end

  s.subspec 'WDCustomPicker' do |ss|
    ss.source_files = 'WDPicker/Classes/WDCustomPicker/*.{h,m}'
  end

end
