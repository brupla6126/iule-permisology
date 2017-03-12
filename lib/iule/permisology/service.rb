#!/usr/bin/env ruby
# encoding: UTF-8
require 'grape'
require_relative 'dependencies'

# load apis
Dir.glob(File.join(File.dirname(__FILE__), 'v*/apis/**/*.rb')).each do |file|
  require_relative file.to_s
end

# PermisologyService REST module
module PermisologyService
  class << self
    attr_accessor :root
  end

  # Permisology REST API
  class PermisologyAPIv1 < Grape::API
    version 'v1'
    default_format :json

    def initialize
      super

      # require global initializers
      Dir.glob(File.join(File.dirname(__FILE__), 'initializers/**/*.rb')).each do |file|
        require_relative file.to_s
      end

      Log.info { '----------------------------' }
      Log.info { 'Starting Permisology Service' }

      Log.debug { "repository: #{Repository.helpers}" }

      PermisologyAPIv1.routes.each do |route|
        Log.debug { "#{route.options[:method]} #{route.origin}" }
      end
    end
    
    before do
      api = request.env['REQUEST_URI'].split('/')[1].to_sym rescue :default

      Log[api].info { "#{request.env['REQUEST_METHOD']} #{request.env['REQUEST_URI']}" }

      Log[api].debug { "params: #{params.to_h}" }
    end

    rescue_from :all do |e|
      Log.error { e.message }
      Log.error { e.backtrace }

      error!({ error: 'Server error.' }, 500, 'Content-Type' => 'text/error')
    end

    get '/info' do
      response = { app: 'PermisologyService', version: 'v1' }

      Log.info { "response: #{response}" }

      response
    end

    mount PermisologyService::RoleAPIv1
  end
end
