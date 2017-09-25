# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kumogata/template/version'

Gem::Specification.new do |spec|
  spec.name          = 'kumogata-template'
  spec.version       = KUMOGATA_TEMPLATE_VERSION
  spec.authors       = ['opt-technologies']
  spec.email         = ['adpv7-info@cg.opt.ne.jp']
  spec.summary       = %q{Template for Kumogata.}
  spec.description   = %q{Template for Kumogata. Kumogata is a tool for AWS CloudFormation. It can define a template in Ruby DSL.}
  spec.homepage      = 'https://github.com/opt-tech/kumogata-template'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://gems.adplan7.com'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
          "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk', '~> 2.3'
  spec.add_dependency 'kumogata2-plugin-ruby', '>= 0.1.6'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
end
