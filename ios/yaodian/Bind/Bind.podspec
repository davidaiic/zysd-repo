#
# Be sure to run `pod lib lint Bind.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Bind'
  s.version          = '0.1.0'
  s.summary          = 'Bind Compont'
  s.description      = <<-DESC
      bind Compont
                       DESC
  s.homepage         = 'https://github.com/wangteng/Bind'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangteng' => 'wangteng6680@163.com' }
  s.source           = { :git => 'https://github.com/wangteng/Bind.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.source_files = 'Bind/**/*'
  s.swift_version = '5.0'
  
  # s.resource_bundles = {
  #   'Bind' => ['Bind/Assets/*.png']
  # }
  s.ios.resources = 'Bind/**/*.{xib,storyboard,bundle}'
  s.dependency 'SnapKit', '4.2.0'
  s.dependency 'KakaJSON', '1.1.2'
end
