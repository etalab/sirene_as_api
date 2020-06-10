class Stock
  module Helper
    module DatabaseIndexes
      def each_index_configuration
        index_configurations.each do |table_name, indexes|
          indexes.each do |index_config|
            columns = [index_config[:columns]].flatten
            options = index_config[:options] || {}

            yield table_name, columns, options
          end
        end
      end

      private

      def index_configurations
        Rails.application.config_for(:database_indexes).deep_symbolize_keys
      end
    end
  end
end
