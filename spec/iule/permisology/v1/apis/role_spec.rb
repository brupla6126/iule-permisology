#!/usr/bin/env ruby
# encoding: utf-8
require "rack/test"

require 'iule/permisology/v1/apis/role'

RSpec.describe PermisologyService::RoleAPIv1 do
  include Rack::Test::Methods

  def app
    PermisologyService::RoleAPIv1
  end

  before do
    # restart the service so it removes stored entities
    Repository.for(Roles::Role, :storage).clear
  end

  describe 'GET /v1/role/' do

    context 'there are no entities in the storage' do
      before { get '/v1/role/', format: :json }

      it 'should return status 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should return empty list of entities ' do
        body = JSON.parse(last_response.body)

        expect(body['entities']).to eq([])
      end
    end

    context 'there are entities in the storage' do
      before do
        post '/v1/role/', 'name' => 'name1', 'permissions' => ['abc']
        post '/v1/role/', 'name' => 'name2', 'permissions' => ['abc', 'xyz']

        get '/v1/role/', format: :json
      end

      it 'should return status 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should return entities' do
        body = JSON.parse(last_response.body)

        expect(body['entities'].count).to eq(2)
      end
    end
  end

  describe 'GET /v1/role/:id' do
    context 'entity does not already exists' do
      let(:name) { 'ff' }

      before do
        get "/v1/role/#{name}", format: :json
      end

      it 'should return status 404' do
        expect(last_response.status).to eq(404)
      end
    end

    context 'entity already exists' do
      let(:name) { 'ff' }

      before do
        post '/v1/role/', 'name' => name, 'permissions' => ['abc']

        body = JSON.parse(last_response.body)
        id = body['entity']['id']

        get "/v1/role/#{id}", format: :json
      end

      it 'should return status 200 and the entity' do
        expect(last_response.status).to eq(200)

        body = JSON.parse(last_response.body)

        expect(body['entity']).not_to eq(nil)
      end
    end
  end

  describe 'POST /v1/role/' do
    context 'entity does not already exists' do
      context 'with parameter permissions missing' do
        let(:name) { 'ff' }

        before { post '/v1/role/', 'name' => name }

        it 'should return entity with permissions defaulting to []' do
          expect(last_response.status).to eq(201)

          body = JSON.parse(last_response.body)

          expect(body['entity']['name']).to eq(name)
          expect(body['entity']['permissions']).to eq([])
        end
      end

      context 'with permissions set' do
        let(:name) { 'fif' }
        let(:permissions) { ['abc', 'xyz'] }

        before { post '/v1/role/', 'name' => name, 'permissions' => permissions }

        it 'should return entity with permissions' do
          expect(last_response.status).to eq(201)

          body = JSON.parse(last_response.body)

          expect(body['entity']['name']).to eq(name)
          expect(body['entity']['permissions']).to eq(permissions)
        end
      end
    end

    context 'entity already exists' do
      let(:name) { 'aa' }

      before do
        post '/v1/role/', 'name' => name, 'permissions' => ['abc']
        post '/v1/role/', 'name' => name
      end

      it 'should return status 409' do
        expect(last_response.status).to eq(409)
      end
    end
  end

  describe 'PUT /v1/role/:id' do
    let(:name) { 'fif' }
    let(:permissions) { ['abc', 'xyz'] }

    context 'updating inexisting role' do
      before do
        put '/v1/role/vu', 'name' => name, 'permissions' => permissions
      end

      it 'returns status 200' do
        expect(last_response.status).to eq(200)

        body = JSON.parse(last_response.body)

        expect(body['entity']['name']).to eq(name)
        expect(body['entity']['permissions']).to eq(permissions)
      end
    end

    context 'updating existing role' do
      let(:name) { 'lc' }
      let(:new_permissions) { ['abc', 'def', 'xyz'] }

      before do
        post "/v1/role/", 'name' => name, 'permissions' => permissions

        body = JSON.parse(last_response.body)
        @id = body['entity']['id']

        put "/v1/role/#{@id}", 'name' => name, 'permissions' => new_permissions
      end

      it 'should return status 200 and updates entity' do
        expect(last_response.status).to eq(200)

        body = JSON.parse(last_response.body)

        expect(body['entity']['name']).to eq(name)
        expect(body['entity']['permissions']).to eq(new_permissions)
      end
    end
  end

  describe 'DELETE /v1/role/:id' do
    context 'deleting inexisting role' do
      it 'returns status 404' do
        delete '/v1/role/xx'

        expect(last_response.status).to eq(404)
      end
    end

    context 'deleting existing role' do
      let(:name) { 'ff' }

      before do
        post '/v1/role/', 'name' => name, 'permissions' => ['abc']

        body = JSON.parse(last_response.body)
        @id = body['entity']['id']
      end

      it 'returns status 200' do
        delete "/v1/role/#{@id}"

        expect(last_response.status).to eq(200)
      end
    end
  end
end
