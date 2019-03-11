lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "win32/windows/version"

Gem::Specification.new do |spec|
  spec.name       = 'win32-service'
  spec.version    = Win32::Service::VERSION
  spec.authors    = ['Daniel J. Berger', 'Park Heesob']
  spec.license    = 'Artistic-2.0'
  spec.email      = 'djberg96@gmail.com'
  spec.homepage   = 'https://github.com/chef/win32-service'
  spec.summary    = 'An interface for MS Windows services'

  spec.files         = Dir["LICENSE", "lib/**/*"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2"

  spec.add_dependency('ffi')
  spec.add_dependency('ffi-win32-extensions')

  spec.add_development_dependency('rspec-core')
  spec.add_development_dependency('rspec-expectations')
  spec.add_development_dependency('rspec-mocks')
  spec.add_development_dependency('test-unit')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('win32-security')

  spec.description = <<-EOF
    The win32-service library provides a Ruby interface to services on
    MS Windows. You can create new services, or control, configure and
    inspect existing services.

    In addition, you can create a pure Ruby service by using the Daemon
    class that is included as part of the library.
  EOF
end
