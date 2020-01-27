class DailyUpdateEtablissement < DailyUpdate
  def related_model
    Etablissement
  end

  def primary_key
    :siret
  end

  def insee_results_body_key
    :etablissements
  end

  def insee_resource_suffix
    'siret/'
  end

  def adapter_task
    DailyUpdate::Task::AdaptEtablissement
  end
end
