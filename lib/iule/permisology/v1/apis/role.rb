#!/usr/bin/env ruby
# encoding: utf-8
require 'grape'

require_relative '../initializers/role'

# PermisologyService REST module
module PermisologyService
  # Role REST API
  class RoleAPIv1 < Grape::API
    default_format :json

    resource :role do
      get '/' do
        response = {}

        parameters = {
          klass: Roles::Role,
          filters: {}
        }

        result = Repository.for(Roles::Role, :finder).many(parameters)

        if result.successful?
          response['entities'] = result.entities.map(&:attributes)
          status 200
        else
          response['errors'] = result.messages
          status 500
        end

        Log[:role].debug { "response: #{response}" }

        response
      end

      params do
        requires :id, type: String
      end
      get '/:id' do
        response = {}

        parameters = {
          klass: Roles::Role,
          filters: { id: params[:id] }
        }

        result = Repository.for(Roles::Role, :finder).one(parameters)

        if result.successful?
          if result.entity
            response['entity'] = result.entity.try(:attributes)
            status 200
          else
            status 404
          end
        else
          response['errors'] = result.messages
          status 500
        end

        Log[:role].debug { "response: #{response}" }

        response
      end

      params do
        requires :name, type: String, desc: 'role name'

        optional :permissions, type: Array, default: []
      end
      post '/' do
        response = {}

        parameters_find = {
          klass: Roles::Role,
          filters: { name: params[:name] }
        }

        if Repository.for(Roles::Role, :finder).one(parameters_find).entity
          status 409
        else
          parameters_create = {
            klass: Roles::Role,
            attributes: params.select { |k, _v| %(name permissions).include? k }
          }

          result = Repository.for(Roles::Role, :creator).create(parameters_create)

          if result.successful?
            response['entity'] = result.entity.try(:attributes)
            status 201
          else
            response['errors'] = result.messages
            status 500
          end
        end

        Log[:role].debug { "response: #{response}" }

        response
      end

      desc 'Update a role'
      params do
        requires :id, type: String, desc: 'role id'
        requires :name, type: String, desc: 'role name'
        optional :permissions, type: Array, default: []
      end
      put '/:id' do
        response = {}

        parameters_update = {
          klass: Roles::Role,
          id: params[:id],
          attributes: params.select { |k, _v| %(name permissions).include? k }
        }

        result = Repository.for(Roles::Role, :updater).update(parameters_update)

        if result.successful?
          response['entity'] = result.entity.try(:attributes)
          status 200
        else
          response['errors'] = result.messages
          status 500
        end

        Log[:role].debug { "response: #{response}" }

        response
      end

      desc 'Delete a role'
      params do
        requires :id, type: String, desc: 'role id'
      end
      delete '/:id' do
        response = {}

        parameters_find = {
          klass: Roles::Role,
          filters: { id: params[:id] }
        }

        if !Repository.for(Roles::Role, :finder).one(parameters_find).entity
          response['ok'] = false
          status 404
        else
          parameters_delete = {
            klass: Roles::Role,
            filters: { id: params[:id] }
          }

          result = Repository.for(Roles::Role, :deleter).delete(parameters_delete)

          if result.successful?
            response['ok'] = true
            status 200
          else
            response['ok'] = false
            response['errors'] = result.messages
            status 404
          end
        end

        Log[:role].debug { "response: #{response}" }

        response
      end
    end
  end
end
