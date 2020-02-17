class Stock
  module Task
    class UpdateNonDiffusable < Trailblazer::Operation
      step :daily_update_unite_legale_non_diffusable
      step :daily_update_etablissement_non_diffusable
      step :update_unite_legale_non_diffusable
      step :update_etablissement_non_diffusable

      def daily_update_unite_legale_non_diffusable(ctx, **)
        ctx[:du_unite_legale_nd] = DailyUpdateUniteLegaleNonDiffusable.create(
          status: 'PENDING',
          update_type: 'full'
        )
      end

      def daily_update_etablissement_non_diffusable(ctx, **)
        ctx[:du_etablissement_nd] = DailyUpdateEtablissementNonDiffusable.create(
          status: 'PENDING',
          update_type: 'full'
        )
      end

      def update_unite_legale_non_diffusable(_, du_unite_legale_nd:, **)
        DailyUpdateModelJob.perform_later du_unite_legale_nd.id
      end

      def update_etablissement_non_diffusable(_, du_etablissement_nd:, **)
        DailyUpdateModelJob.perform_later du_etablissement_nd.id
      end
    end
  end
end
