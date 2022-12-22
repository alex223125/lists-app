# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  describe 'GET /index' do
    context 'when we have authorized user' do
      let(:user) { create(:user, :with_public_and_private_lists) }

      before do
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        request.headers.merge!(auth_headers)
        list_id = user.lists.first.id

        get :index, params: { list_id: list_id }
      end

      it 'returns list items' do
        items = JSON.parse(response.body)
        result = items.count
        expected_result = 10

        expect(result).to eq(expected_result)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when we dont have authorized user' do
      context 'when we have public list' do
        let(:user) { create(:user, :with_lists_and_items) }

        before do
          list_id = user.lists.first.id

          get :index, params: { list_id: list_id }
        end

        it 'returns items of list' do
          items = JSON.parse(response.body)
          result = items.count
          expected_result = 10

          expect(result).to eq(expected_result)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:success)
        end
      end

      context 'when we have private list' do
        let(:user) { create(:user, :with_private_lists_and_items) }

        before do
          list_id = user.lists.first.id

          get :index, params: { list_id: list_id }
        end

        it 'returns zero items' do
          items = JSON.parse(response.body)
          result = items.count
          expected_result = 0

          expect(result).to eq(expected_result)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:success)
        end
      end
    end
  end

  describe 'GET /show' do
    let(:user) { create(:user, :with_lists_and_items) }
    let(:item) { user.lists.first.items.first }

    context 'when we have authorized user' do
      before do
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        request.headers.merge!(auth_headers)
        item_id = item.id

        get :show, params: { id: item_id }
      end

      it 'returns correct item' do
        result = JSON.parse(response.body)
        expected_result = item.as_json

        expect(result).to eq(expected_result)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when we dont have authorized user' do
      before do
        item = user.lists.first.items.first
        item_id = item.id

        get :show, params: { id: item_id }
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'POST /create' do
    let!(:user) { create(:user, :with_lists_and_items) }
    let!(:items_before_create) { Item.all.count }

    context 'when we have authorized user' do
      context 'when we have correct params' do
        let(:list_id) { user.lists.first.id }
        let(:params) do
          { item: { name: 'test_name',
                    completion_status: 'test_completion_status',
                    description: 'test description',
                    list_id: list_id } }
        end

        before do
          headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          request.headers.merge!(auth_headers)

          post :create, params: params
        end

        it 'adds one list item' do
          epxected_result = items_before_create + 1
          result = Item.all.count

          expect(result).to eq(epxected_result)
        end

        it 'returns correct name' do
          result = JSON.parse(response.body)['name']
          expected_result = params[:item][:name]

          expect(result).to eq(expected_result)
        end

        it 'returns correct completion_status' do
          result = JSON.parse(response.body)['completion_status']
          expected_result = params[:item][:completion_status]

          expect(result).to eq(expected_result)
        end

        it 'returns correct description' do
          result = JSON.parse(response.body)['description']
          expected_result = params[:item][:description]

          expect(result).to eq(expected_result)
        end

        it 'returns correct list_id' do
          result = JSON.parse(response.body)['list_id']
          expected_result = params[:item][:list_id]

          expect(result).to eq(expected_result)
        end

        it 'returns created status' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'when we have incorrect params' do
        let(:params) do
          { item: { name: nil,
                    completion_status: nil,
                    description: nil,
                    list_id: nil } }
        end

        before do
          headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          request.headers.merge!(auth_headers)

          post :create, params: params
        end

        it 'returns 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when we dont have authorized user' do
      let(:list_id) { user.lists.first.id }
      let(:params) do
        { item: { name: 'test_name',
                  completion_status: 'test_completion_status',
                  description: 'test description',
                  list_id: list_id } }
      end

      before do
        get :create, params: params
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PUT /update' do
    let(:user) { create(:user, :with_lists_and_items) }

    context 'when we have authorized user' do
      context 'when we have correct params' do
        let(:item_id) { user.lists.first.items.first.id }
        let(:params) do
          { id: item_id,
            item: { name: 'new_item_test_name',
                    completion_status: 'new_test_completion_status',
                    description: 'new test description' } }
        end

        before do
          headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          request.headers.merge!(auth_headers)

          put :update, params: params
        end

        it 'returns new name' do
          result = JSON.parse(response.body)['name']
          expected_result = params[:item][:name]

          expect(result).to eq(expected_result)
        end

        it 'returns new completion_status' do
          result = JSON.parse(response.body)['completion_status']
          expected_result = params[:item][:completion_status]

          expect(result).to eq(expected_result)
        end

        it 'returns new description' do
          result = JSON.parse(response.body)['description']
          expected_result = params[:item][:description]

          expect(result).to eq(expected_result)
        end

        it 'returns status 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when we have incorrect params' do
        let(:item_id) { user.lists.first.items.first.id }
        let(:params) do
          { id: item_id,
            item: { name: 'new_item_test_name',
                    completion_status: 'new_test_completion_status',
                    description: 'new test description',
                    list_id: nil } }
        end

        before do
          headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          request.headers.merge!(auth_headers)

          put :update, params: params
        end

        it 'returns 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when we dont have authorized user' do
      let(:item_id) { user.lists.first.items.first.id }
      let(:params) do
        { id: item_id,
          item: { name: 'test_name',
                  completion_status: 'test_completion_status',
                  description: 'test description' } }
      end

      before do
        get :update, params: params
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:user) { create(:user, :with_lists_and_items) }

    context 'when we have authorized user' do
      let!(:items_before_destroy) { Item.all.count }
      let(:item_id) { user.lists.first.items.first.id }
      let(:params) { { id: item_id } }

      before do
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        request.headers.merge!(auth_headers)

        delete :destroy, params: params
      end

      it 'removes one list item' do
        epxected_result = items_before_destroy - 1
        result = Item.all.count

        expect(result).to eq(epxected_result)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when we dont have authorized user' do
      let(:item_id) { user.lists.first.items.first.id }
      let(:params) { { id: item_id } }

      before do
        delete :destroy, params: params
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(:found)
      end
    end
  end
end
