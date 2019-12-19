Pod::Spec.new do |s|
  s.name         = "GatheredKit"
  s.version      = "0.1.1"
  s.summary      = <<-SUMM
                   A concistent Combine-based framework for Apple frameworks
                   SUMM
  s.homepage     = "https://github.com/JosephDuffy/GatheredKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Joseph Duffy"
  s.source       = {
    :git => "https://github.com/JosephDuffy/GatheredKit.git",
    :tag => "v#{s.version}"
  }
  s.source_files = "Sources/**/*.swift"
  s.osx.deployment_target = "10.15"
  s.ios.deployment_target = "13.0"
  s.tvos.deployment_target = "13.0"
  s.watchos.deployment_target = "6.0"
  s.swift_versions = "5.0"
end
