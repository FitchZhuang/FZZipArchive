Pod::Spec.new do |s|
  s.name         = 'FZZipArchive'
  s.version      = '1.0.0'
  s.summary      = '基于SSZipArchive-2.4.3版本, 添加2个方法'
  s.description  = '基于SSZipArchive-2.4.3版本, 添加读取zip包内目录结构和读取zip包内文件的方法'
  s.homepage     = 'https://github.com/FitchZhuang/FZZipArchive.git'
  s.license      = { :type => 'MIT' }
  s.authors      = { 'FitchZhuang' => 'fitchzhuang@163.com' }
  s.source       = { :git => 'https://github.com/FitchZhuang/FZZipArchive.git', :tag => "#{s.version}" }
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.source_files = 'SSZipArchive/*.{m,h}', 'SSZipArchive/include/*.{m,h}', 'SSZipArchive/minizip/*.{c,h}'
  s.public_header_files = 'SSZipArchive/*.h'
  s.libraries = 'z', 'iconv'
  s.framework = 'Security'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES',
    'GCC_PREPROCESSOR_DEFINITIONS' => 'HAVE_INTTYPES_H HAVE_PKCRYPT HAVE_STDINT_H HAVE_WZAES HAVE_ZLIB' }
end
