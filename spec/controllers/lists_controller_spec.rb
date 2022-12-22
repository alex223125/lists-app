# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListsController, type: :controller do
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

      it 'returns correct amount of lists' do
        lists = JSON.parse(response.body)
        result = lists.count
        expected_result = 15

        expect(result).to eq(expected_result)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when we dont have authorized user' do
      context 'when we have public lists' do
        let(:user) { create(:user, :with_lists_and_items) }

        before do
          list_id = user.lists.first.id

          get :index, params: { list_id: list_id }
        end

        it 'returns correct amount of lists' do
          lists = JSON.parse(response.body)
          result = lists.count
          expected_result = 6

          expect(result).to eq(expected_result)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:success)
        end
      end

      context 'when we have private lists' do
        let(:user) { create(:user, :with_private_lists_and_items) }

        before do
          list_id = user.lists.first.id

          get :index, params: { list_id: list_id }
        end

        it 'corrects amount of lists' do
          lists = JSON.parse(response.body)
          result = lists.count
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

    context 'when we have authorized user' do
      before do
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        request.headers.merge!(auth_headers)
        @list = user.lists.first
        list_id = @list.id

        get :show, params: { id: list_id }
      end

      it 'returns correct list' do
        result = JSON.parse(response.body)
        expected_result = @list.as_json

        expect(result).to eq(expected_result)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when we dont have authorized user' do
      before do
        @list = user.lists.first
        list_id = @list.id

        get :show, params: { id: list_id }
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user, :with_lists_and_items) }

    context 'when we have authorized user' do
      context 'when we have correct params' do
        before do
          headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          request.headers.merge!(auth_headers)
          @lists_before_create = List.all.count

          @params = { list: { name: 'test_name',
                              is_public: true } }

          post :create, params: @params
        end

        it 'adds one list' do
          epxected_result = @lists_before_create + 1
          result = List.all.count

          expect(result).to eq(epxected_result)
        end

        it 'returns correct name' do
          result = JSON.parse(response.body)['name']
          expected_result = @params[:list][:name]

          expect(result).to eq(expected_result)
        end

        it 'returns correct is_public flag' do
          result = JSON.parse(response.body)['is_public']
          expected_result = @params[:list][:is_public]

          expect(result).to eq(expected_result)
        end

        it 'returns created status' do
          expect(response).to have_http_status(:created)
        end
      end
    end

    context 'when we dont have authorized user' do
      before do
        @params = { list: { name: 'test_name',
                            is_public: true } }

        get :create, params: @params
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
        before do
          headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          request.headers.merge!(auth_headers)
          list_id = user.lists.first.id
          @params = { id: list_id,
                      list: { name: 'test_name_test_name',
                              is_public: true } }

          put :update, params: @params
        end

        it 'returns new name' do
          result = JSON.parse(response.body)['name']
          expected_result = @params[:list][:name]

          expect(result).to eq(expected_result)
        end

        it 'returns new value for is_public' do
          result = JSON.parse(response.body)['is_public']
          expected_result = @params[:list][:is_public]

          expect(result).to eq(expected_result)
        end

        it 'returns status 200' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when we dont have authorized user' do
      before do
        list_id = user.lists.first.id
        @params = { id: list_id,
                    item: { name: 'test_name',
                            completion_status: 'test_completion_status',
                            description: 'test description' } }

        get :update, params: @params
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:user) { create(:user, :with_lists_and_items) }

    context 'when we have authorized user' do
      before do
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        request.headers.merge!(auth_headers)

        @lists_before_destroy = List.all.count
        list_id = user.lists.first.id
        @params = { id: list_id }

        delete :destroy, params: @params
      end

      it 'removes one list item' do
        epxected_result = @lists_before_destroy - 1
        result = List.all.count

        expect(result).to eq(epxected_result)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when we dont have authorized user' do
      before do
        list_id = user.lists.first.id
        @params = { id: list_id }

        delete :destroy, params: @params
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(:found)
      end
    end
  end
end
