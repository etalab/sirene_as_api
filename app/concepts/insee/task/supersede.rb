module INSEE
  module Task
    class Supersede < Trailblazer::Operation
      step :find_business_key_value
      fail :log_business_key_not_found
      step :supersede

      def find_business_key_value(ctx, business_key:, data:, **)
        ctx[:business_key_value] = data[business_key]
      end

      # rubocop:disable Metrics/ParameterLists
      def supersede(_, model:, business_key:, business_key_value:, data:, logger:, **)
        entity = model.find_or_initialize_by("#{business_key}": business_key_value)

        begin
          entity.assign_attributes(data)
          entity.nullify_non_diffusable_fields
          entity.save
        rescue ActiveRecord::ActiveRecordError, ActiveModel::UnknownAttributeError => e
          logger.error "#{e.class}: #{e.message}. Invalid hash: #{data}"
          false
        end
      end
      # rubocop:enable Metrics/ParameterLists

      def log_business_key_not_found(_, business_key:, data:, logger:, **)
        logger.error "Supersede failed, primary key (#{business_key}) not found in #{data}"
      end
    end
  end
end
