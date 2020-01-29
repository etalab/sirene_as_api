class DailyUpdate
  module Operation
    class UpdateDatabase < Trailblazer::Operation
      step Nested Task::CurrentStockCompleted
      step :set_period_to_update

      step :daily_updates_unite_legale
      step :daily_updates_etablissement
      step :daily_update_unite_legale_non_diffusable
      step :daily_update_etablissement_non_diffusable

      step :update_unite_legale
      step :update_etablissement
      step :update_unite_legale_non_diffusable
      step :update_etablissement_non_diffusable

      def set_period_to_update(ctx, **)
        ctx[:from] = Time.zone.now.beginning_of_month
        ctx[:to]   = Time.zone.now
      end

      def daily_updates_unite_legale(ctx, from:, to:, **)
        ctx[:du_unite_legale] = DailyUpdateUniteLegale.create(
          status: 'PENDING',
          from: from,
          to: to
        )
      end

      def daily_updates_etablissement(ctx, from:, to:, **)
        ctx[:du_etablissement] = DailyUpdateEtablissement.create(
          status: 'PENDING',
          from: from,
          to: to
        )
      end

      def daily_update_unite_legale_non_diffusable(ctx, from:, to:, **)
        ctx[:du_unite_legale_nd] = DailyUpdateUniteLegaleNonDiffusable.create(
          status: 'PENDING',
          from: from,
          to: to
        )
      end

      def daily_update_etablissement_non_diffusable(ctx, from:, to:, **)
        ctx[:du_etablissement_nd] = DailyUpdateEtablissementNonDiffusable.create(
          status: 'PENDING',
          from: from,
          to: to
        )
      end

      def update_unite_legale(_, du_unite_legale:, **)
        DailyUpdateModelJob.perform_later du_unite_legale.id
      end

      def update_etablissement(_, du_etablissement:, **)
        DailyUpdateModelJob.perform_later du_etablissement.id
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
