class UpdateEtablissementRowsJob < EtablissementRowJobs
  attr_accessor :lines

  def initialize(lines)
    @lines = lines
  end

  def perform
    etablissements = fill_etablissements

    begin
      update_attrs(etablissements)
    rescue StandardError => e
      stdout_error_log "Error: Could not update etablissement attributes:  #{e.class}
        Make sure Solr server is launched on the right environment and accessible."
      exit
    end
  end

  def update_attrs(etablissements)
    etablissements.each do |etablissement_attrs|
      etablissement = EtablissementV2.find_or_initialize_by(siret: etablissement_attrs[:siret])

      nature_mise_a_jour = etablissement_attrs[:nature_mise_a_jour]
      # Il y a une paire I/F, I etant l'etat initial
      next if nature_mise_a_jour == 'I'

      if nature_mise_a_jour == 'E'
        # On supprime l'etablissement si il est persiste
        # Si non persiste veut dire qu on rejoue un patch interrompu
        etablissement.destroy if etablissement.persisted?
        next
      end
      etablissement.update_attributes(etablissement_attrs)
    end
  end
end
