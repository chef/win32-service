require "bundler/gem_tasks"
require "rake"
require "rake/clean"
require "rake/testtask"
require "rbconfig"
require_relative "tasks/rspec"
include RbConfig

CLEAN.include(
  "**/*.gem", # Gem files
  "**/*.rbc"  # Rubinius
)

namespace :example do
  desc "Run the services example program."
  task :services do
    sh "ruby -Ilib examples/demo_services.rb"
  end
end

namespace "test" do
  desc "Run all tests for the win32-service library"
  Rake::TestTask.new("all") do |t|
    t.verbose = true
    t.warning = true
  end

  desc "Run the tests for the Win32::Daemon class"
  Rake::TestTask.new("daemon") do |t|
    task :daemon
    t.verbose = true
    t.warning = true
    t.test_files = FileList["test/test_win32_daemon.rb"]
  end

  namespace "service" do
    desc "Run the tests for the Win32::Service class"
    Rake::TestTask.new("all") do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList["test/test_win32_service*.rb"]
    end

    Rake::TestTask.new("configure") do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList["test/test_win32_service_configure.rb"]
    end

    Rake::TestTask.new("control") do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList["test/test_win32_service.rb"]
    end

    Rake::TestTask.new("create") do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList["test/test_win32_service_create.rb"]
    end

    Rake::TestTask.new("info") do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList["test/test_win32_service_info.rb"]
    end

    Rake::TestTask.new("status") do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList["test/test_win32_service_status.rb"]
    end

    Rake::TestTask.new("close_service_handle") do |t|
      t.verbose = true
      t.warning = true
      t.test_files = FileList["test/test_win32_service_close_service_handle.rb"]
    end
  end

  task :all do
    Rake.application[:clean].execute
  end

  task :daemon do
    Rake.application[:clean].execute
  end
end

desc "Check Linting and code style."
task :style do
  require "rubocop/rake_task"
  require "cookstyle/chefstyle"

  if RbConfig::CONFIG["host_os"] =~ /mswin|mingw|cygwin/
    # Windows-specific command, rubocop erroneously reports the CRLF in each file which is removed when your PR is uploaeded to GitHub.
    # This is a workaround to ignore the CRLF from the files before running cookstyle.
    sh "cookstyle --chefstyle -c .rubocop.yml --except Layout/EndOfLine"
  else
    sh "cookstyle --chefstyle -c .rubocop.yml"
  end
rescue LoadError
  puts "Rubocop or Cookstyle gems are not installed. bundle install first to make sure all dependencies are installed."
end

task :console do
  require "irb"
  require "irb/completion"
  ARGV.clear
  IRB.start
end

task default: "test:all"
