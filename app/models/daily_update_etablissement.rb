class DailyUpdateEtablissement < DailyUpdate
  def log_filename
    'daily_update_etablissement.log'
  end

  def related_model
    Etablissement
  end

  def business_key
    :siret
  end

  def insee_results_body_key
    :etablissements
  end

  def insee_resource_suffix
    'siret/'
  end

  def adapter_task
    INSEE::Task::AdaptEtablissement
  end
end
