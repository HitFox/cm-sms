source 'https://rubygems.org'

# Specify your gem's dependencies in cm-sms.gemspec
gemspec

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.0.0')
  gem 'tins', '>= 1.5.4', require: false, group: :test
else
  gem 'public_suffix', '< 1.5.0'
  gem 'tins', '< 1.7.0', '>= 1.5.4', require: false, group: :test
  gem 'webmock', '<= 1.24.6', '>= 1.0.0', group: :test
  gem 'term-ansicolor', '< 1.4.0', group: :test
end

gem 'simplecov', require: false, group: :test
gem 'coveralls', require: false, group: :test
