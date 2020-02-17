module INSEE
  module Task
    class AdaptUniteLegale < Trailblazer::Operation
      step :get_latest_informations
      step :rename_all_keys
      pass :delete_extra_keys

      PERIODES_KEY = :periodesUniteLegale

      def get_latest_informations(_, result:, **)
        data = result[PERIODES_KEY]&.first || {}
        result.delete(PERIODES_KEY)
        result.merge!(data)
      end

      def rename_all_keys(ctx, result:, **)
        updated_unite_legale = result.map do |key, value|
          [rename(key), value]
        end

        ctx[:result] = updated_unite_legale.to_h
      end

      def delete_extra_keys(_, result:, **)
        result.reject! do |key|
          key.to_s.start_with?('changement_')
        end
      end

      private

      def rename(key)
        # :denominationUsuelle3UniteLegale => :denomination_usuelle_3
        key
          .to_s
          .tap { |s| s.slice!('UniteLegale') }
          .underscore
          .gsub(/(\d+)/, '_\1')
          .to_sym
      end
    end
  end
end
