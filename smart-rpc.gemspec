# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{smart-rpc}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Suman Mukherjee"]
  s.date = %q{2013-03-14}
  s.description = %q{Gem to send requests to remote applications or push the request to an async message handling or job processing unit.}
  s.email = %q{sumanmukherjee03@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "lib/smart-rpc.rb",
    "lib/smart-rpc/authentication_scheme_registrar.rb",
    "lib/smart-rpc/client.rb",
    "lib/smart-rpc/errors.rb",
    "lib/smart-rpc/request.rb",
    "lib/smart-rpc/request_handler.rb",
    "lib/smart-rpc/request_handler/base.rb",
    "lib/smart-rpc/request_handler/http.rb",
    "lib/smart-rpc/request_handler/http/authentication.rb",
    "lib/smart-rpc/request_handler/http/authentication/api_key.rb",
    "lib/smart-rpc/request_handler/http/authentication/base.rb",
    "lib/smart-rpc/request_handler/http/authentication/name_and_password.rb",
    "lib/smart-rpc/request_handler/http/wrapped_response.rb",
    "lib/smart-rpc/request_strategy_registrar.rb",
    "lib/smart-rpc/resource.rb",
    "lib/smart-rpc/resource_handler.rb",
    "lib/smart-rpc/resource_handler/base_handler.rb",
    "lib/smart-rpc/setting.rb"
  ]
  s.homepage = %q{http://github.com/payrollhero/smart-rpc}
  s.licenses = ["Closed"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A gem similar to ActiveResource that allows you to send a request to a remote application or push the request to an async message handling or job processing system}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httmultiparty>, [">= 0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<retryable>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
      s.add_runtime_dependency(%q<httmultiparty>, [">= 0"])
      s.add_runtime_dependency(%q<retryable>, [">= 0"])
    else
      s.add_dependency(%q<httmultiparty>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<retryable>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
      s.add_dependency(%q<httmultiparty>, [">= 0"])
      s.add_dependency(%q<retryable>, [">= 0"])
    end
  else
    s.add_dependency(%q<httmultiparty>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<retryable>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
    s.add_dependency(%q<httmultiparty>, [">= 0"])
    s.add_dependency(%q<retryable>, [">= 0"])
  end
end

