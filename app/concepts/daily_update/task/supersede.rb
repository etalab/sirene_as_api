class DailyUpdate
  module Task
    class Supersede < Trailblazer::Operation
      step :find_primary_key_value
      fail :log_primary_key_not_found
      step :supersede

      def find_primary_key_value(ctx, primary_key:, data:, **)
        ctx[:primary_key_value] = data[primary_key]
      end

      # rubocop:disable Metrics/ParameterLists
      def supersede(_, model:, primary_key:, primary_key_value:, data:, logger:, **)
        entity = model.find_or_initialize_by("#{primary_key}": primary_key_value)

        begin
          entity.update_attributes(data)
        rescue ActiveRecord::ActiveRecordError, ActiveModel::UnknownAttributeError => e
          logger.error "#{e.class}: #{e.message}. Invalid hash: #{data}"
          false
        end
      end
      # rubocop:enable Metrics/ParameterLists

      def log_primary_key_not_found(_, primary_key:, data:, logger:, **)
        logger.error "Supersede failed, primary key (#{primary_key}) not found in #{data}"
      end
    end
  end
end
