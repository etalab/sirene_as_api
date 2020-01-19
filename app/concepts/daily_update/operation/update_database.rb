class DailyUpdate
  module Operation
    class UpdateDatabase < Trailblazer::Operation
      step Nested Task::CurrentStockCompleted
      step :update_unite_legale
      step :update_etablissement

      def update_unite_legale(_, **)
        DailyUpdateModelJob.perform_later 'unite_legale'
      end

      def update_etablissement(_, **)
        DailyUpdateModelJob.perform_later 'etablissement'
      end
    end
  end
end
