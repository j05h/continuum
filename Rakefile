require 'bundler'

require "rake/testtask"
Rake::TestTask.new(:test) do |test|
  test.libs   << "./lib" << "./test"
  test.pattern = "test/**/*_test.rb"
  test.verbose = true
end

Bundler::GemHelper.install_tasks

task :irb do
  exec 'irb -I.:lib -rubygems -rcontinuum'
end

task :autotest do
  exec 'autotest -b'
end

task :default= => :test
