Pod::Spec.new do |s|

s.name     = 'LGCyImageBrowser'

s.version  = '2.0.11'

s.license  = { :type => 'MIT' }

s.summary  = '可拖动的 图片浏览器，支持缩放 ，拖动消失、双击放大等，支持桥接swift 语言'

s.description = <<-DESC
                   可拖动的 图片浏览器，支持缩放 ，拖动消失、双击放大等，支持桥接swift 语言
                   DESC

s.homepage = 'https://github.com/lanligang/CyImageBrowser'

s.authors  = { 'LenSky' => 'lslanligang@sina.com' }

s.source   = { :git => 'https://github.com/lanligang/CyImageBrowser.git', :tag => s.version}

s.source_files = 'LGCyImageBrowser/*.{h,m}'

s.requires_arc = true

s.platform     = :ios, '7.0'

s.ios.frameworks = ['UIKit', 'CoreGraphics', 'Foundation']

s.dependency  'SDWebImage'


end