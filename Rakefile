# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "smart-rpc"
  gem.homepage = "http://github.com/payrollhero/smart-rpc"
  gem.license = "Closed"
  gem.summary = %Q{A gem similar to ActiveResource that allows you to send a request to a remote application or push the request to an async message handling or job processing system}
  gem.description = %Q{Gem to send requests to remote applications or push the request to an async message handling or job processing unit.}
  gem.email = "sumanmukherjee03@gmail.com"
  gem.authors = ["Suman Mukherjee"]
  # dependencies defined in Gemfile
  gem.add_dependency "httmultiparty"
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec
