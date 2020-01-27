class DailyUpdateUniteLegale < DailyUpdate
  def related_model
    UniteLegale
  end

  def primary_key
    :siren
  end

  def insee_results_body_key
    :unitesLegales
  end

  def insee_resource_suffix
    'siren/'
  end

  def adapter_task
    DailyUpdate::Task::AdaptUniteLegale
  end
end
