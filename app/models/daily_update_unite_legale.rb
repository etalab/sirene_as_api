class DailyUpdateUniteLegale < DailyUpdate
  def log_filename
    'daily_update_unite_legale.log'
  end

  def related_model
    UniteLegale
  end

  def business_key
    :siren
  end

  def insee_results_body_key
    :unitesLegales
  end

  def insee_resource_suffix
    'siren/'
  end

  def adapter_task
    INSEE::Task::AdaptUniteLegale
  end
end
