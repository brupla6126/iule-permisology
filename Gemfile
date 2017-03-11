# usr/bin/env ruby
# encoding: UTF-8

source "https://rubygems.org" do
  group :development, :test do
    gem 'rake'
    gem 'rspec'
    gem 'rspec-mocks'
    gem 'simplecov'
    gem 'timecop'
  end

  group :development do
    gem 'listen', '~> 3.0'
    gem 'guard'
    gem 'guard-rubocop'
    gem 'guard-rspec'
    gem 'rack-test'
    gem 'rack-contrib'
    gem 'rubocop'
    gem 'yard'
  end
end

gem 'capistrano', '>= 3.8.0'
gem 'capistrano-service', '>= 0.0.2'

gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"

gem 'araignee', :github => 'brupla6126/araignee', :branch => 'WIP-adjustments' # master
gem 'cloporte-permisology', :github => 'brupla6126/cloporte-permisology', :branch => 'WIP-adjustments' # master

# Specify your gem's dependencies in iule-permisology.gemspec
gemspec

