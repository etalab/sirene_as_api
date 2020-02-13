class DailyUpdateUniteLegaleNonDiffusable < DailyUpdate
  def log_filename
    'daily_update_unite_legale_non_diffusable.log'
  end

  def related_model
    UniteLegale
  end

  def business_key
    :siren
  end

  def insee_results_body_key
    :unitesLegalesNonDiffusibles
  end

  def insee_resource_suffix
    'siren/nonDiffusibles'
  end

  def adapter_task
    INSEE::Task::AdaptUniteLegale
  end
end
