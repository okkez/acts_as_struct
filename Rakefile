require 'rake'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

desc 'Default: run unit tests.'
task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  t.spec_opts = ['-c']
end

PKG_FILES = FileList[
  'lib/**/*.rb',
  'rails/init.rb',
  'spec/*'
]
spec = Gem::Specification.new do |s|
  s.name = 'acts_as_struct'
  s.version = '1.1.0'
  s.author = 'okkez'
  s.email = 'okkez000@gmail.com'
  s.homepage = 'http://github.com/okkez/acts_as_struct'
  s.platform = Gem::Platform::RUBY
  s.summary = "Add extra columns to existing models without modifying its schema"
  s.files = PKG_FILES.to_a
  s.require_path = 'lib'
  s.has_rdoc = false
  s.extra_rdoc_files = ['README']
end

desc 'Turn this plugin into a gem.'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc 'Generate documentation for the context_monitor plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActsAsStruct'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.exclude('lib/core_ext/**/*.rb')
end

