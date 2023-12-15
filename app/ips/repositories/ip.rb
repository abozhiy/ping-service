# frozen_string_literal: true

module Repositories
  class Ip
    class << self
      def find_by(**attributes)
        dataset
          .where(attributes)
          .first
      end

      def create(**attributes)
        dataset.insert(attributes)
      end

      def update(uuid, **attributes)
        dataset
          .where(id: uuid)
          .update(attributes)
      end

      def delete(uuid)
        dataset
          .where(id: uuid)
          .delete
      end

      private

      def dataset
        DB[:ips]
      end
    end
  end
end
