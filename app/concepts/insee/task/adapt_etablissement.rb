module INSEE
  module Task
    class AdaptEtablissement < Trailblazer::Operation
      step :get_latest_informations
      step :get_address_1
      step :get_address_2
      step :rename_all_keys
      pass :delete_extra_keys

      PERIODES_KEY = :periodesEtablissement
      ADDRESS_1_KEY = :adresseEtablissement
      ADDRESS_2_KEY = :adresse2Etablissement

      def get_latest_informations(_, result:, **)
        data = result[PERIODES_KEY]&.first || {}
        result.delete(PERIODES_KEY)
        result.merge!(data)
      end

      def get_address_1(_, result:, **)
        data = result[ADDRESS_1_KEY] || {}
        result.delete(ADDRESS_1_KEY)
        result.merge!(data)
      end

      def get_address_2(_, result:, **)
        data = result[ADDRESS_2_KEY] || {}
        result.delete(ADDRESS_2_KEY)
        result.merge!(data)
      end

      def delete_extra_keys(_, result:, **)
        result.reject! do |key|
          key.to_s.start_with?('changement_') ||
            %i[unite_legale date_fin].include?(key)
        end
      end

      def rename_all_keys(ctx, result:, **)
        updated_etablissement = result.map do |key, value|
          [rename(key), value]
        end

        ctx[:result] = updated_etablissement.to_h
      end

      private

      def rename(key)
        # :enseigne3Etablissement => :enseigne_3
        key
          .to_s
          .tap { |s| s.slice!('Etablissement') }
          .underscore
          .gsub(/(\d+)/, '_\1')
          .to_sym
      end
    end
  end
end
