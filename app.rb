# frozen_string_literal: true

require 'bundler/setup'
require 'trifle/docs'
require 'puma'

Trifle::Docs.configure do |config|
  config.path = File.join(__dir__, 'docs')
  config.views = File.join(__dir__, 'templates')
  config.register_harvester(Trifle::Docs::Harvester::Markdown)
  config.register_harvester(Trifle::Docs::Harvester::File)
  config.cache = ENV['APP_ENV'] == 'production'
end
