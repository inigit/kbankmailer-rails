$:.push File.expand_path("../lib", __FILE__)
require "kbankmailer-rails/version"

Gem::Specification.new do |s|
  s.name = %q{kbankmailer-rails}
  s.version = KbankmailerRails::VERSION
  s.authors = ["Steven", "Start"]
  s.description = %q{The Kbankmailer Rails Gem is a drop-in plug-in for ActionMailer to send emails via Kbankmailer, an email delivery service for web apps.}
  s.email = %q{tema@wildbit.com}
  s.homepage = %q{https://kbtg.tech}
  s.summary = %q{Kbankmailer adapter for ActionMailer}

  s.metadata = {
    "source_code_uri" => "https://github.com/inigit/kbankmailer-rails"
  }

  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.rdoc_options = ["--charset=UTF-8"]

  s.add_dependency('actionmailer', ">= 3.0.0")

  s.add_dependency('faraday')

  s.add_development_dependency("rake")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
end
