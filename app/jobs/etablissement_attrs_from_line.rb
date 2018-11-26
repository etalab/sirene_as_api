# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength

class EtablissementAttrsFromLine
  include Singleton

  def call(line)
    etablissement_attrs = {
      siren: line[:siren],
      siret: line[:siret],
      nic: line[:nic],
      denomination: line[:denominationusuelleetablissement],
      is_actif: line[:etatadministratifetablissement],
      date_creation_etablissement: line[:datecreationetablissement],
      date_derniere_modification: line[:datedebut],
      statut_prospection: line[:statutdiffusionetablissement],
      is_siege: line[:etablissementsiege],
      is_etablissement_employeur: line[:caractereemployeuretablissement],
      tranche_effectif_salarie: line[:trancheeffectifsetablissement],
      date_validite_effectif_salarie: line[:anneeeffectifsetablissement],
      activite_principale: line[:activiteprincipaleetablissement],
      activite_principale_nomenclature: line[:nomenclatureactiviteprincipaleetablissement],
      activite_principale_registre_metier: line[:activiteprincipaleregistremetiersetablissement],
      nombre_periodes_traitement: line[:nombreperiodesetablissement],
      date_dernier_traitement_sirene: line[:datederniertraitementetablissement],
      enseigne_ligne_1: line[:enseigne1etablissement],
      enseigne_ligne_2: line[:enseigne2etablissement],
      enseigne_ligne_3: line[:enseigne3etablissement],
      adresse_numero_voie: line[:numerovoieetablissement],
      adresse_numero_voie_repetition: line[:indicerepetitionetablissement],
      adresse_type_voie: line[:typevoieetablissement],
      adresse_libelle_voie: line[:libellevoieetablissement],
      adresse_code_postal: line[:codepostaletablissement],
      adresse_complement: line[:complementadresseetablissement],
      adresse_libelle_commune: line[:libellecommuneetablissement],
      adresse_libelle_commune_etranger: line[:libellecommuneetrangeretablissement],
      adresse_code_commune: line[:codecommuneetablissement],
      adresse_distribution_speciale: line[:distributionspecialeetablissement],
      adresse_code_cedex: line[:codecedexetablissement],
      adresse_libelle_cedex: line[:libellecedexetablissement],
      adresse_code_pays_etranger: line[:codepaysetrangeretablissement],
      adresse_secondaire_numero_voie: line[:numerovoieetablissement],
      adresse_secondaire_numero_voie_repetition: line[:indicerepetitionetablissement],
      adresse_secondaire_type_voie: line[:typevoieetablissement],
      adresse_secondaire_libelle_voie: line[:libellevoieetablissement],
      adresse_secondaire_code_postal: line[:codepostaletablissement],
      adresse_secondaire_complement: line[:complementadresseetablissement],
      adresse_secondaire_libelle_commune: line[:libellecommuneetablissement],
      adresse_secondaire_libelle_commune_etranger: line[:libellecommuneetrangeretablissement],
      adresse_secondaire_code_commune: line[:codecommuneetablissement],
      adresse_secondaire_distribution_speciale: line[:distributionspecialeetablissement],
      adresse_secondaire_code_cedex: line[:codecedexetablissement],
      adresse_secondaire_libelle_cedex: line[:libellecedexetablissement],
      adresse_secondaire_code_pays_etranger: line[:codepaysetrangeretablissement],
      adresse_secondaire_libelle_pays_etranger: line[:libellepaysetrangeretablissement],
      longitude: line[:longitude],
      latitude: line[:latitude],
      geo_score: line[:geo_score],
      geo_type: line[:geo_type],
      geo_adresse: line[:geo_adresse],
      geo_id: line[:geo_id],
      geo_ligne: line[:geo_ligne]
    }
    etablissement_attrs
  end
end

# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
