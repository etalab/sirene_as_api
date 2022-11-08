class RenameExistingIndexes < ActiveRecord::Migration[5.0]
  def change
    each_index_configuration do |table_name, columns|
      index_found = ActiveRecord::Base
        .connection
        .indexes(table_name)
        .find { |idx| idx.columns == columns }

      next if index_found.nil?

      short_name = ['index', table_name, *columns].join('_').first(55)

      next if short_name == index_found.name

      ActiveRecord::Base
        .connection
        .rename_index table_name, index_found.name, "#{short_name}_tmp"
    end
  end

  private

  def each_index_configuration
    index_configurations.each do |table_name, indexes|
      indexes.each do |index_config|
        columns = [index_config[:columns]].flatten
        options = index_config[:options] || {}

        yield table_name, columns, options
      end
    end
  end

  def index_configurations
    Rails.application.config_for(:database_indexes).deep_symbolize_keys
  end
end
