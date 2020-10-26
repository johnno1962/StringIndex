Pod::Spec.new do |s|
    s.name        = "StringIndex"
    s.version     = "1.1.0"
    s.summary     = "Simplified String indexing"
    s.homepage    = "https://github.com/johnno1962/StringIndex"
    s.social_media_url = "https://twitter.com/Injection4Xcode"
    s.documentation_url = "https://github.com/johnno1962/StringIndex/blob/master/README.md"
    s.license     = { :type => "MIT" }
    s.authors     = { "johnno1962" => "stringindex@johnholdsworth.com" }

    s.osx.deployment_target = "10.10"
    s.ios.deployment_target = "10.0"
    s.source   = { :git => "https://github.com/johnno1962/StringIndex.git", :tag => s.version }
    s.source_files = "Sources/StringIndex/*.swift"
end
