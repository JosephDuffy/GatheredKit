Pod::Spec.new do |s|
  s.name         = "GatheredKit"
  s.version      = "0.1.1"
  s.summary      = <<-SUMM
                   A consistent and easy to use API for various iOS data
                   sources
                   SUMM
  s.description  = <<-DESC
                   A framework that provides a consistent and easy to use API for various data sources offered by iOS
                   DESC
  s.homepage     = "https://github.com/JosephDuffy/GatheredKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Joseph Duffy"
  s.source       = {
    :git => "https://github.com/JosephDuffy/GatheredKit.git",
    :tag => "v#{s.version}"
  }
  s.source_files = "Source/**/*.{swift,h,m}"
  s.platform      = :ios, '9.0'
  s.frameworks    = "SystemConfiguration"
end