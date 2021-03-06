
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kt_data_class/version"

Gem::Specification.new do |spec|
  spec.name          = "kt_data_class"
  spec.version       = KtDataClass::VERSION
  spec.authors       = ["YusukeIwaki"]
  spec.email         = ["yusuke.iwaki@crowdworks.co.jp"]

  spec.summary       = "The Ruby porting of `data class` in Kotlin"
  spec.homepage      = "https://github.com/YusukeIwaki/kt_data_class"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 2.2.3'
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter"
end
