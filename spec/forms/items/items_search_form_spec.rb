# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ItemsSearchForm' do
  describe '#submit' do
    let(:user) { create(:user, :with_lists_and_items) }

    context 'when we have current user who accessing his list' do
      let(:form) { Forms::Items::ItemsSearchForm.new(current_user: user, list: user.lists.first) }

      it 'returns list items' do
        form.submit

        result = form.results.count
        expected_result = 10
        expect(result).to eql(expected_result)
      end
    end

    context 'when anonymous user accessing list' do
      let(:form) { Forms::Items::ItemsSearchForm.new(list: user.lists.first) }

      context 'when we have public list' do
        it 'returns list items' do
          form.submit

          result = form.results.count
          expected_result = 10
          expect(result).to eql(expected_result)
        end
      end

      context 'when we have private list' do
        let(:user) { create(:user, :with_private_lists_and_items) }

        it 'returns 0 items' do
          form.submit

          result = form.results.count
          expected_result = 0
          expect(result).to eql(expected_result)
        end
      end
    end
  end
end
