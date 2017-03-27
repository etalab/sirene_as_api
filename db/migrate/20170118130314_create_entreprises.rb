class CreateEntreprises < ActiveRecord::Migration[5.0]
  def change
    create_table :entreprises do |t|
      t.string :siren, index: true
      t.string :siret, index: true
      t.string :nic
      t.string :l1_normalisee
      t.string :l2_normalisee
      t.string :l3_normalisee
      t.string :l4_normalisee
      t.string :l5_normalisee
      t.string :l6_normalisee, index: true
      t.string :l7_normalisee
      t.string :l1_declaree
      t.string :l2_declaree
      t.string :l3_declaree
      t.string :l4_declaree
      t.string :l5_declaree
      t.string :l6_declaree
      t.string :l7_declaree
      t.string :numero_voie
      t.string :indice_repetition
      t.string :type_voie
      t.string :libelle_voie
      t.string :code_postal
      t.string :cedex
      t.string :region
      t.string :libelle
      t.string :departement
      t.string :arrondissement
      t.string :canton
      t.string :commune
      t.string :libelle_commune
      t.string :departement_unite_urbaine
      t.string :taille_unite_urbaine
      t.string :numero_unite_urbaine
      t.string :etablissement_public_cooperation_intercommunale
      t.string :tranche_commune_detaillee
      t.string :zone_emploi
      t.string :is_siege
      t.string :enseigne
      t.string :indicateur_champ_publipostage
      t.string :statut_diffusion
      t.string :date_introduction_base_diffusion
      t.string :nature_entrepreneur_individuel
      t.string :libelle_nature_entrepreneur_individuel
      t.string :activite_principale, index: true
      t.string :libelle_activite_principale
      t.string :date_validite_activite_principale
      t.string :tranche_effectif_salarie
      t.string :libelle_tranche_effectif_salarie
      t.string :tranche_effectif_salarie_centaine_pret
      t.string :date_validite_effectif_salarie
      t.string :origine_creation
      t.string :date_creation
      t.string :date_debut_activite
      t.string :nature_activite
      t.string :lieu_activite
      t.string :type_magasin
      t.string :is_saisonnier
      t.string :modalite_activite_principale
      t.string :caractere_productif
      t.string :participation_particuliere_production
      t.string :caractere_auxiliaire
      t.string :nom_raison_sociale, index: true
      t.string :sigle
      t.string :nom
      t.string :prenom
      t.string :civilite
      t.string :numero_rna
      t.string :nic_siege
      t.string :region_siege
      t.string :departement_commune_siege
      t.string :email
      t.string :nature_juridique_entreprise
      t.string :libelle_nature_juridique_entreprise
      t.string :activite_principale_entreprise
      t.string :libelle_activite_principale_entreprise
      t.string :date_validite_activite_principale_entreprise
      t.string :activite_principale_registre_metier
      t.string :is_ess
      t.string :date_ess
      t.string :tranche_effectif_salarie_entreprise
      t.string :libelle_tranche_effectif_salarie_entreprise
      t.string :tranche_effectif_salarie_entreprise_centaine_pret
      t.string :date_validite_effectif_salarie_entreprise
      t.string :categorie_entreprise
      t.string :date_creation_entreprise
      t.string :date_introduction_base_diffusion_entreprise
      t.string :indice_monoactivite_entreprise
      t.string :modalite_activite_principale_entreprise
      t.string :caractere_productif_entreprise
      t.string :date_validite_rubrique_niveau_entreprise_esa
      t.string :tranche_chiffre_affaire_entreprise_esa
      t.string :activite_principale_entreprise_esa
      t.string :premiere_activite_secondaire_entreprise_esa
      t.string :deuxieme_activite_secondaire_entreprise_esa
      t.string :troisieme_activite_secondaire_entreprise_esa
      t.string :quatrieme_activite_secondaire_entreprise_esa
      t.string :nature_mise_a_jour
      t.string :indicateur_mise_a_jour_1
      t.string :indicateur_mise_a_jour_2
      t.string :indicateur_mise_a_jour_3
      t.string :date_mise_a_jour
      t.string :type_evenement
      t.string :date_evenement
      t.string :type_creation
      t.string :date_reactivation_etablissement
      t.string :date_reactivation_entreprise
      t.string :indicateur_mise_a_jour_enseigne_entreprise
      t.string :indicateur_mise_a_jour_activite_principale_etablissement
      t.string :indicateur_mise_a_jour_adresse_etablissement
      t.string :indicateur_mise_a_jour_caractere_productif_etablissement
      t.string :indicateur_mise_a_jour_caractere_auxiliaire_etablissement
      t.string :indicateur_mise_a_jour_nom_raison_sociale
      t.string :indicateur_mise_a_jour_sigle
      t.string :indicateur_mise_a_jour_nature_juridique
      t.string :indicateur_mise_a_jour_activite_principale_entreprise
      t.string :indicateur_mise_a_jour_caractere_productif_entreprise
      t.string :indicateur_mise_a_jour_nic_siege
      t.string :siret_predecesseur_successeur
      t.string :telephone
      t.timestamps
    end

    execute "
      create index on entreprises using gin(to_tsvector('french', siren));
      create index on entreprises using gin(to_tsvector('french', siret));
      create index on entreprises using gin(to_tsvector('french', activite_principale));
      create index on entreprises using gin(to_tsvector('french', l6_normalisee));
      create index on entreprises using gin(to_tsvector('french', nom_raison_sociale));"
  end
end
