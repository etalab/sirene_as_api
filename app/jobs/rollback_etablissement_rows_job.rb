class RollbackEtablissementRowsJob
  # attr_accessor :lines
  # def initialize(lines)
  #   @lines = lines
  # end
  #
  # def perform
  #   etablissements = []
  #
  #   for line in lines do
  #     etablissement_attrs = EtablissementAttrsFromLine.instance.call(line)
  #     etablissements << etablissement_attrs
  #   end
  #
  #   etablissements.each do |etablissement_attrs|
  #     siret = etablissement_attrs[:siret]
  #     etablissement = Etablissement.find_or_initialize_by(siret: siret)
  #
  #     nature_mise_a_jour = etablissement_attrs[:nature_mise_a_jour]
  #
  #     if nature_mise_a_jour== "I"
  #       # Il y a une paire I/F, I étant l'état initial
  #       next
  #     elsif nature_mise_a_jour == 'E'
  #       # On supprime l'établissement si il est persisté
  #       # Si non persisté veut dire qu on rejoue un patch interrompu
  #       if etablissement.persisted?
  #         etablissement.destroy
  #       end
  #
  #       next
  #     end
  #
  #
  #     etablissement.update_attributes(etablissement_attrs)
  #   end
  # end
end
