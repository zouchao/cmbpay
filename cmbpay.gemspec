lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cmbpay/version"

Gem::Specification.new do |spec|
  spec.name          = "cmbpay"
  spec.version       = Cmbpay::VERSION
  spec.authors       = ["zouchao"]
  spec.email         = ["zouchao2008@gmail.com"]

  spec.summary       = %q{An unofficial simple cmb netpayment gem}
  spec.description   = %q{An unofficial simple cmb netpayment gem, copied from alipay}
  spec.homepage      = "https://github.com/zouchao/cmbpay"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rest-client", '>= 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
