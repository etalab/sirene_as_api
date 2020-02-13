class DailyUpdateEtablissementNonDiffusable < DailyUpdate
  def log_filename
    'daily_update_etablissement_non_diffusable.log'
  end

  def related_model
    Etablissement
  end

  def business_key
    :siret
  end

  def insee_results_body_key
    :etablissementsNonDiffusibles
  end

  def insee_resource_suffix
    'siret/nonDiffusibles'
  end

  def adapter_task
    INSEE::Task::AdaptEtablissement
  end
end
