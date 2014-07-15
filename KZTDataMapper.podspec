Pod::Spec.new do |s|
  s.name        = "KZTDataMapper"
  s.summary     = "Small dictionary-object mapper library"
  s.version     = "1.0"
  s.license     = "MIT"
  s.homepage    = "https://github.com/kazyk/KZTDataMapper"
  s.author      = { "Kazuyuki Takahashi" => "kazyk" }
  s.source      = { :git => "https://github.com/kazyk/KZTDataMapper.git", :tag => "#{s.version}" }
  s.platform    = :ios, "7.0"
  s.requires_arc = true
  s.source_files = "DataMapper/*.{h,m}"
  s.frameworks  = "CoreData"
end

