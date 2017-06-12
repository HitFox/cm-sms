require 'coveralls'
Coveralls.wear!

require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'simplecov'

SimpleCov.start
Bundler.setup

require 'phony'
require 'phonelib'
require 'builder'
require 'cm-sms'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random

  Kernel.srand config.seed
end
