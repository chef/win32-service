require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include Config

CLEAN.include(
  '**/*.gem',    # Gem files
  '**/*.rbc',    # Rubinius
  '**/*.o',      # C object file
  '**/*.log',    # Ruby extension build log
  '**/Makefile', # C Makefile
  "**/*.so",     # C shared object
  "**/*.lib",    # C build file
  "**/*.def",    # C build file
  "**/*.pdb",    # C build file
  "**/*.exp",    # C build file
  "**/*.obj",    # C build file
  "**/*.log"     # C build file
)

desc "Build the win32-service library"
task :build => [:clean] do
  make = "nmake"
  make = "make" if CONFIG['host_os'] =~ /mingw|cygwin/i

  Dir.chdir('ext') do
    ruby 'extconf.rb'
    sh "#{make}"
    FileUtils.cp('daemon.so', 'win32/daemon.so')      
  end  
end

namespace 'gem' do
  desc 'Build the gem'
  task :create => [:clean] do
    spec = eval(IO.read('win32-service.gemspec')) 
    Gem::Builder.new(spec).build
  end

  desc 'Install the gem'
  task :install => [:create] do
    file = Dir['*.gem'].first
    sh "gem install #{file}"
  end

  desc 'Build a binary gem'
  task :binary => [:build] do
    mkdir_p 'lib/win32'
    mv 'ext/win32/daemon.so', 'lib/win32/daemon.so'

    spec = eval(IO.read('win32-service.gemspec'))
    spec.extensions = nil
    spec.platform = Gem::Platform::CURRENT

    spec.files = spec.files.reject{ |f| f.include?('ext') }

    Gem::Builder.new(spec).build
  end
end

namespace :example do
  desc "Run the services example program."
  task :services do
    sh "ruby -Ilib examples/demo_services.rb"
  end
end

namespace 'test' do
  desc 'Run all tests for the win32-service library'
  Rake::TestTask.new('all') do |t|
    task :all => :build
    t.libs << 'ext'
    t.verbose = true
    t.warning = true
  end

  desc 'Run the tests for the Win32::Daemon class'
  Rake::TestTask.new('daemon') do |t|
    task :daemon => :build
    t.libs << 'ext'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_win32_daemon.rb']
  end

  namespace 'service' do
    desc 'Run the tests for the Win32::Service class'
    Rake::TestTask.new('all') do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList['test/test_win32_service*.rb']
    end

    Rake::TestTask.new('configure') do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList['test/test_win32_service_configure.rb']
    end

    Rake::TestTask.new('control') do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList['test/test_win32_service.rb']
    end

    Rake::TestTask.new('create') do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList['test/test_win32_service_create.rb']
    end

    Rake::TestTask.new('info') do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList['test/test_win32_service_info.rb']
    end

    Rake::TestTask.new('status') do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList['test/test_win32_service_status.rb']
    end
  end

  task :all do
    Rake.application[:clean].execute
  end

  task :daemon do
    Rake.application[:clean].execute
  end
end

task :default => 'test:all'
