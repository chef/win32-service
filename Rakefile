require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include RbConfig

CLEAN.include(
  '**/*.gem', # Gem files
  '**/*.rbc'  # Rubinius
)

namespace 'gem' do
  desc "Create the win32-service gem"
  task :create => [:clean] do
    spec = eval(IO.read('win32-service.gemspec'))
    if Gem::VERSION.to_f < 2.0
      Gem::Builder.new(spec).build
    else
      require 'rubygems/package'
      Gem::Package.build(spec)
    end
  end

  desc "Install the win32-service gem"
  task :install => [:create] do
    file = Dir['*.gem'].first
    sh "gem install -l #{file}"
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
    t.verbose = true
    t.warning = true
  end

  desc 'Run the tests for the Win32::Daemon class'
  Rake::TestTask.new('daemon') do |t|
    task :daemon
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
