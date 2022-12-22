# frozen_string_literal: true

module Forms
  module Items
    class ItemsSearchForm
      include ActiveModel::Model

      attr_accessor :current_user, :list

      def submit
        if current_user.present? && list.user == current_user
          @results = list.items
        elsif list.is_public
          @results = list.items
        end
      end

      def results
        @results || []
      end
    end
  end
end
