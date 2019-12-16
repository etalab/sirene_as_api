module DailyUpdate
  module Task
    class Supersede < Trailblazer::Operation
      pass :log_supersede_starts
      step :init_counters
      step :set_primary_key
      step :supersede
      step :log_update_done

      def init_counters(ctx, **)
        ctx[:counter_new] = 0
        ctx[:counter_updates] = 0
      end

      def set_primary_key(ctx, model:, **)
        case model.name
        when UniteLegale.name
          ctx[:primary_key] = :siren
        when Etablissement.name
          ctx[:primary_key] = :siret
        end
      end

      # rubocop:disable Metrics/ParameterLists
      def supersede(ctx, model:, primary_key:, results:, logger:, **)
        results.each do |result|
          entity = model.find_or_initialize_by("#{primary_key}": result[primary_key])

          increment_counters(ctx, entity)

          begin
            entity.update_attributes(result)
          rescue ActiveRecord::ActiveRecordError, ActiveModel::UnknownAttributeError => e
            logger.error "#{e.class}: #{e.message}. Invalid hash: #{result}"
          end
        end
      end

      def log_supersede_starts(_, results:, logger:, **)
        logger.info "Supersede starts ; #{results.size} update to perform"
      end

      def log_update_done(_, counter_new:, counter_updates:, model:, logger:, **)
        logger.info "#{model}: #{counter_new} created, #{counter_updates} updated"
      end
      # rubocop:enable Metrics/ParameterLists

      private

      def increment_counters(context, entity)
        if entity.new_record?
          context[:counter_new] += 1
        else
          context[:counter_updates] += 1
        end
      end
    end
  end
end
