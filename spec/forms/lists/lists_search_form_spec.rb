# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ListsSearchForm' do
  describe '#submit' do
    context 'when current user accessing his lists' do
      let(:user) { create(:user, :with_lists_and_items) }
      let(:form) { Forms::Lists::ListsSearchForm.new(current_user: user) }

      it 'returns current user lists' do
        form.submit

        result = form.results.count
        expected_result = 6
        expect(result).to eql(expected_result)
      end
    end

    context 'when anonymous user accessing lists' do
      let(:form) { Forms::Lists::ListsSearchForm.new }

      context 'when we have public lists' do
        let!(:user) { create(:user, :with_lists_and_items) }

        it 'returns public lists' do
          form.submit

          result = form.results.count
          expected_result = 6
          expect(result).to eql(expected_result)
        end
      end

      context 'when we have private lists' do
        let!(:user) { create(:user, :with_private_lists_and_items) }

        it 'returns 0 lists' do
          form.submit

          result = form.results.count
          expected_result = 0
          expect(result).to eql(expected_result)
        end
      end
    end
  end
end
