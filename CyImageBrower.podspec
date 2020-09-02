Pod::Spec.new do |s|

  s.name     = 'CyImageBrowser'

  s.version  = '1.0.0'

  s.license  = { :type => 'MIT' }

  s.summary  = '图片浏览器，支持缩放 ，拖动消失、双击放大等，支持桥接swift 语言'

  s.description = <<-DESC
                    图片浏览器，支持缩放 ，拖动消失、双击放大等，支持桥接swift 语言
                   DESC

  s.homepage = 'https://github.com/lanligang/CyImageBrowser'

  s.authors  = { 'lanligang' => 'lslanligang@sina.com' }

  s.source   = { :git => 'https://github.com/lanligang/CyImageBrowser.git', :tag => s.version }

  s.source_files = 'lib/**/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.dependency  'SDWebImage'
  s.ios.frameworks = ['UIKit', 'CoreGraphics', 'Foundation']
end