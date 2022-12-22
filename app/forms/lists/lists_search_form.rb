# frozen_string_literal: true

module Forms
  module Lists
    class ListsSearchForm
      include ActiveModel::Model

      attr_accessor :current_user

      def submit
        @results = if current_user.present?
                     current_user.lists
                   else
                     List.where(is_public: true)
                   end
      end

      def results
        @results || []
      end
    end
  end
end
