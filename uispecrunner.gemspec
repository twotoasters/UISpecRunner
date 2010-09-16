# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{uispecrunner}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Blake Watters"]
  s.date = %q{2010-09-16}
  s.default_executable = %q{uispec}
  s.description = %q{Provides a simple Ruby interface for running UISpec iPhone tests}
  s.email = %q{blake@twotoasters.com}
  s.executables = ["uispec"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG",
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "bin/uispec",
     "lib/uispecrunner.rb",
     "lib/uispecrunner/application.rb",
     "lib/uispecrunner/drivers/osascript.rb",
     "lib/uispecrunner/drivers/shell.rb",
     "lib/uispecrunner/options.rb",
     "spec/options_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/uispecrunner_spec.rb",
     "src/UISpec+UISpecRunner.h",
     "src/UISpec+UISpecRunner.m",
     "src/main.m",
     "tasks/uispec.rake",
     "uispecrunner.gemspec"
  ]
  s.homepage = %q{http://github.com/twotoasters/UISpecRunner}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Flexible spec runner for UISpec on iOS}
  s.test_files = [
    "spec/options_spec.rb",
     "spec/spec_helper.rb",
     "spec/uispecrunner_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

