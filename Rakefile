require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include Config

desc "Cleans up the C related files created during the build"
task :clean do
   Dir.chdir('ext') do
      if File.exists?('daemon.o') || File.exists?('daemon.so')
         sh 'nmake distclean'
      end
      File.delete('win32/daemon.so') if File.exists?('win32/daemon.so')
   end
end

desc "Builds, but does not install, the win32-service library"
task :build => [:clean] do
   Dir.chdir('ext') do
      ruby 'extconf.rb'
      sh 'nmake'
      FileUtils.cp('daemon.so', 'win32/daemon.so')      
   end  
end

desc "Install the win32-service library (non-gem)"
task :install => [:build] do
   Dir.chdir('ext') do
      sh 'nmake install'
   end
   install_dir = File.join(CONFIG['sitelibdir'], 'win32')
   Dir.mkdir(install_dir) unless File.exists?(install_dir)
   FileUtils.cp('lib/win32/service.rb', install_dir, :verbose => true)
end

desc 'Install the win32-service library as a gem'
task :install_gem => [:clean] do
   ruby 'win32-service.gemspec'
   file = Dir['win32-service*.gem'].first
   sh "gem install #{file}"
end

desc 'Uninstall the (non-gem) win32-service library.'
task :uninstall do
   service = File.join(CONFIG['sitelibdir'], 'win32', 'service.rb')
   FileUtils.rm(service, :verbose => true) if File.exists?(service)

   daemon = File.join(CONFIG['sitearchdir'], 'win32', 'daemon.so')
   FileUtils.rm(daemon, :verbose => true) if File.exists?(daemon)
end

desc "Build a binary gem"
task :build_binary_gem => [:build] do
   if File.exists?('lib/win32/daemon.rb')
      mv 'lib/win32/daemon.rb', 'lib/win32/daemon.orig'
   end

   cp 'ext/win32/daemon.so', 'lib/win32/daemon.so'

   task :build_binary_gem => [:clean]

   spec = Gem::Specification.new do |gem|
      gem.name         = 'win32-service'
      gem.version      = '0.7.0'
      gem.authors      = ['Daniel J. Berger', 'Park Heesob']
      gem.email        = 'djberg96@gmail.com'
      gem.license      = 'Artistic 2.0'
      gem.homepage     = 'http://www.rubyforge.org/projects/win32utils'
      gem.platform     = Gem::Platform::CURRENT
      gem.summary      = 'An interface for MS Windows services'
      gem.test_files   = Dir['test/test*.rb']
      gem.has_rdoc     = true
      gem.files        = Dir['**/*'].delete_if{ |f|
         f.include?('CVS') || f.include?('ext') || f.include?('daemon.orig')
      }

      gem.extra_rdoc_files = [
         'CHANGES',
         'README',
         'MANIFEST',
         'doc/service.txt',
         'doc/daemon.txt',
         'ext/win32/daemon.c'
      ]

      gem.rubyforge_project     = 'win32utils'
      gem.required_ruby_version = '>= 1.8.2'

      gem.add_dependency('windows-pr', '>= 1.0.5')
      gem.add_dependency('test-unit', '>= 2.0.2')

      gem.description = <<-EOF
         The win32-service library provides a Ruby interface to services on
         MS Windows. You can create new services, or control, configure and
         inspect existing services.

         In addition, you can create a pure Ruby service by using the Daemon
         class that is included as part of the library.
      EOF
   end

   Gem::Builder.new(spec).build
end

desc "Run the test suite for the win32-service library"
Rake::TestTask.new do |t|
   task :test => :build
   t.libs << 'ext'
   t.verbose = true
   t.warning = true
end

desc "Run the test suite for the Win32::Daemon class (only)"
Rake::TestTask.new('test_daemon') do |t|
   task :test_daemon => :build
   t.libs << 'ext'
   t.verbose = true
   t.warning = true
   t.test_files = FileList['test/test_win32_daemon.rb']
end

task :test do
   Rake.application[:clean].execute
end

task :test_daemon do
   Rake.application[:clean].execute
end
