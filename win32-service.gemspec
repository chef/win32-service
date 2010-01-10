require 'rubygems'

spec = Gem::Specification.new do |gem|
   gem.name         = 'win32-service'
   gem.version      = '0.7.1'
   gem.authors      = ['Daniel J. Berger', 'Park Heesob']
   gem.license      = 'Artistic 2.0'
   gem.email        = 'djberg96@gmail.com'
   gem.homepage     = 'http://www.rubyforge.org/projects/win32utils'
   gem.platform     = Gem::Platform::RUBY
   gem.summary      = 'An interface for MS Windows services'
   gem.test_files   = Dir['test/test*.rb']
   gem.has_rdoc     = true
   gem.extensions   = ['ext/extconf.rb']
   
   # Don't include daemon.rb for now
   gem.files = Dir['**/*'].delete_if{ |f|
      f.include?('CVS') || f.include?('daemon.rb')
   }

   gem.extra_rdoc_files = [
      'CHANGES',
      'README',
      'MANIFEST',
      'doc/service.txt',
      'doc/daemon.txt',
      'ext/win32/daemon.c'
   ]

   gem.rubyforge_project = 'win32utils'
   gem.required_ruby_version = '>= 1.8.2'

   gem.add_dependency('windows-pr', '>= 1.0.8')
   gem.add_development_dependency('test-unit', '>= 2.0.2')

   gem.description = <<-EOF
      The win32-service library provides a Ruby interface to services on
      MS Windows. You can create new services, or control, configure and
      inspect existing services.

      In addition, you can create a pure Ruby service by using the Daemon
      class that is included as part of the library.
   EOF
end

Gem::Builder.new(spec).build
