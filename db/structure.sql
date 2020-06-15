--
-- PostgreSQL database dump
--

-- Dumped from database version 10.12 (Ubuntu 10.12-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.12 (Ubuntu 10.12-0ubuntu0.18.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: daily_updates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daily_updates (
    id integer NOT NULL,
    status character varying,
    "from" timestamp without time zone,
    "to" timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying,
    update_type character varying DEFAULT 'limited'::character varying
);


--
-- Name: daily_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.daily_updates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: daily_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.daily_updates_id_seq OWNED BY public.daily_updates.id;


--
-- Name: etablissements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.etablissements (
    id integer NOT NULL,
    siren character varying,
    nic character varying,
    siret character varying,
    statut_diffusion character varying,
    date_creation character varying,
    tranche_effectifs character varying,
    annee_effectifs character varying,
    activite_principale_registre_metiers character varying,
    date_dernier_traitement character varying,
    etablissement_siege character varying,
    nombre_periodes character varying,
    complement_adresse character varying,
    numero_voie character varying,
    indice_repetition character varying,
    type_voie character varying,
    libelle_voie character varying,
    code_postal character varying,
    libelle_commune character varying,
    libelle_commune_etranger character varying,
    distribution_speciale character varying,
    code_commune character varying,
    code_cedex character varying,
    libelle_cedex character varying,
    code_pays_etranger character varying,
    libelle_pays_etranger character varying,
    complement_adresse_2 character varying,
    numero_voie_2 character varying,
    indice_repetition_2 character varying,
    type_voie_2 character varying,
    libelle_voie_2 character varying,
    code_postal_2 character varying,
    libelle_commune_2 character varying,
    libelle_commune_etranger_2 character varying,
    distribution_speciale_2 character varying,
    code_commune_2 character varying,
    code_cedex_2 character varying,
    libelle_cedex_2 character varying,
    code_pays_etranger_2 character varying,
    libelle_pays_etranger_2 character varying,
    date_debut character varying,
    etat_administratif character varying,
    enseigne_1 character varying,
    enseigne_2 character varying,
    enseigne_3 character varying,
    denomination_usuelle character varying,
    activite_principale character varying,
    nomenclature_activite_principale character varying,
    caractere_employeur character varying,
    longitude character varying,
    latitude character varying,
    geo_score character varying,
    geo_type character varying,
    geo_adresse character varying,
    geo_id character varying,
    geo_ligne character varying,
    geo_l4 character varying,
    geo_l5 character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    unite_legale_id integer
);


--
-- Name: etablissements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.etablissements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: etablissements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.etablissements_id_seq OWNED BY public.etablissements.id;


--
-- Name: etablissements_tmp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.etablissements_tmp (
    id integer NOT NULL,
    siren character varying,
    nic character varying,
    siret character varying,
    statut_diffusion character varying,
    date_creation character varying,
    tranche_effectifs character varying,
    annee_effectifs character varying,
    activite_principale_registre_metiers character varying,
    date_dernier_traitement character varying,
    etablissement_siege character varying,
    nombre_periodes character varying,
    complement_adresse character varying,
    numero_voie character varying,
    indice_repetition character varying,
    type_voie character varying,
    libelle_voie character varying,
    code_postal character varying,
    libelle_commune character varying,
    libelle_commune_etranger character varying,
    distribution_speciale character varying,
    code_commune character varying,
    code_cedex character varying,
    libelle_cedex character varying,
    code_pays_etranger character varying,
    libelle_pays_etranger character varying,
    complement_adresse_2 character varying,
    numero_voie_2 character varying,
    indice_repetition_2 character varying,
    type_voie_2 character varying,
    libelle_voie_2 character varying,
    code_postal_2 character varying,
    libelle_commune_2 character varying,
    libelle_commune_etranger_2 character varying,
    distribution_speciale_2 character varying,
    code_commune_2 character varying,
    code_cedex_2 character varying,
    libelle_cedex_2 character varying,
    code_pays_etranger_2 character varying,
    libelle_pays_etranger_2 character varying,
    date_debut character varying,
    etat_administratif character varying,
    enseigne_1 character varying,
    enseigne_2 character varying,
    enseigne_3 character varying,
    denomination_usuelle character varying,
    activite_principale character varying,
    nomenclature_activite_principale character varying,
    caractere_employeur character varying,
    longitude character varying,
    latitude character varying,
    geo_score character varying,
    geo_type character varying,
    geo_adresse character varying,
    geo_id character varying,
    geo_ligne character varying,
    geo_l4 character varying,
    geo_l5 character varying,
    unite_legale_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: etablissements_tmp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.etablissements_tmp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: etablissements_tmp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.etablissements_tmp_id_seq OWNED BY public.etablissements_tmp.id;


--
-- Name: etablissements_v2; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.etablissements_v2 (
    id integer NOT NULL,
    siren character varying,
    siret character varying,
    nic character varying,
    l1_normalisee character varying,
    l2_normalisee character varying,
    l3_normalisee character varying,
    l4_normalisee character varying,
    l5_normalisee character varying,
    l6_normalisee character varying,
    l7_normalisee character varying,
    l1_declaree character varying,
    l2_declaree character varying,
    l3_declaree character varying,
    l4_declaree character varying,
    l5_declaree character varying,
    l6_declaree character varying,
    l7_declaree character varying,
    numero_voie character varying,
    indice_repetition character varying,
    type_voie character varying,
    libelle_voie character varying,
    code_postal character varying,
    cedex character varying,
    region character varying,
    libelle_region character varying,
    departement character varying,
    arrondissement character varying,
    canton character varying,
    commune character varying,
    libelle_commune character varying,
    departement_unite_urbaine character varying,
    taille_unite_urbaine character varying,
    numero_unite_urbaine character varying,
    etablissement_public_cooperation_intercommunale character varying,
    tranche_commune_detaillee character varying,
    zone_emploi character varying,
    is_siege character varying,
    enseigne character varying,
    indicateur_champ_publipostage character varying,
    statut_prospection character varying,
    date_introduction_base_diffusion character varying,
    nature_entrepreneur_individuel character varying,
    libelle_nature_entrepreneur_individuel character varying,
    activite_principale character varying,
    libelle_activite_principale character varying,
    date_validite_activite_principale character varying,
    tranche_effectif_salarie character varying,
    libelle_tranche_effectif_salarie character varying,
    tranche_effectif_salarie_centaine_pret character varying,
    date_validite_effectif_salarie character varying,
    origine_creation character varying,
    date_creation character varying,
    date_debut_activite character varying,
    nature_activite character varying,
    lieu_activite character varying,
    type_magasin character varying,
    is_saisonnier character varying,
    modalite_activite_principale character varying,
    caractere_productif character varying,
    participation_particuliere_production character varying,
    caractere_auxiliaire character varying,
    nom_raison_sociale character varying,
    sigle character varying,
    nom character varying,
    prenom character varying,
    civilite character varying,
    numero_rna character varying,
    nic_siege character varying,
    region_siege character varying,
    departement_commune_siege character varying,
    email character varying,
    nature_juridique_entreprise character varying,
    libelle_nature_juridique_entreprise character varying,
    activite_principale_entreprise character varying,
    libelle_activite_principale_entreprise character varying,
    date_validite_activite_principale_entreprise character varying,
    activite_principale_registre_metier character varying,
    is_ess character varying,
    date_ess character varying,
    tranche_effectif_salarie_entreprise character varying,
    libelle_tranche_effectif_salarie_entreprise character varying,
    tranche_effectif_salarie_entreprise_centaine_pret character varying,
    date_validite_effectif_salarie_entreprise character varying,
    categorie_entreprise character varying,
    date_creation_entreprise character varying,
    date_introduction_base_diffusion_entreprise character varying,
    indice_monoactivite_entreprise character varying,
    modalite_activite_principale_entreprise character varying,
    caractere_productif_entreprise character varying,
    date_validite_rubrique_niveau_entreprise_esa character varying,
    tranche_chiffre_affaire_entreprise_esa character varying,
    activite_principale_entreprise_esa character varying,
    premiere_activite_secondaire_entreprise_esa character varying,
    deuxieme_activite_secondaire_entreprise_esa character varying,
    troisieme_activite_secondaire_entreprise_esa character varying,
    quatrieme_activite_secondaire_entreprise_esa character varying,
    nature_mise_a_jour character varying,
    indicateur_mise_a_jour_1 character varying,
    indicateur_mise_a_jour_2 character varying,
    indicateur_mise_a_jour_3 character varying,
    date_mise_a_jour character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    longitude character varying,
    latitude character varying,
    geo_score character varying,
    geo_type character varying,
    geo_adresse character varying,
    geo_id character varying,
    geo_ligne character varying,
    geo_l4 character varying,
    geo_l5 character varying
);


--
-- Name: etablissements_v2_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.etablissements_v2_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: etablissements_v2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.etablissements_v2_id_seq OWNED BY public.etablissements_v2.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: stocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stocks (
    id integer NOT NULL,
    type character varying,
    year character varying,
    month character varying,
    status character varying,
    uri character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stocks_id_seq OWNED BY public.stocks.id;


--
-- Name: unites_legales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unites_legales (
    id integer NOT NULL,
    siren character varying,
    statut_diffusion character varying,
    unite_purgee character varying,
    date_creation character varying,
    sigle character varying,
    sexe character varying,
    prenom_1 character varying,
    prenom_2 character varying,
    prenom_3 character varying,
    prenom_4 character varying,
    prenom_usuel character varying,
    pseudonyme character varying,
    identifiant_association character varying,
    tranche_effectifs character varying,
    annee_effectifs character varying,
    date_dernier_traitement character varying,
    nombre_periodes character varying,
    categorie_entreprise character varying,
    annee_categorie_entreprise character varying,
    date_fin character varying,
    date_debut character varying,
    etat_administratif character varying,
    nom character varying,
    nom_usage character varying,
    denomination character varying,
    denomination_usuelle_1 character varying,
    denomination_usuelle_2 character varying,
    denomination_usuelle_3 character varying,
    categorie_juridique character varying,
    activite_principale character varying,
    nomenclature_activite_principale character varying,
    nic_siege character varying,
    economie_sociale_solidaire character varying,
    caractere_employeur character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: unites_legales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.unites_legales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: unites_legales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.unites_legales_id_seq OWNED BY public.unites_legales.id;


--
-- Name: unites_legales_tmp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unites_legales_tmp (
    id integer NOT NULL,
    siren character varying,
    statut_diffusion character varying,
    unite_purgee character varying,
    date_creation character varying,
    sigle character varying,
    sexe character varying,
    prenom_1 character varying,
    prenom_2 character varying,
    prenom_3 character varying,
    prenom_4 character varying,
    prenom_usuel character varying,
    pseudonyme character varying,
    identifiant_association character varying,
    tranche_effectifs character varying,
    annee_effectifs character varying,
    date_dernier_traitement character varying,
    nombre_periodes character varying,
    categorie_entreprise character varying,
    annee_categorie_entreprise character varying,
    date_fin character varying,
    date_debut character varying,
    etat_administratif character varying,
    nom character varying,
    nom_usage character varying,
    denomination character varying,
    denomination_usuelle_1 character varying,
    denomination_usuelle_2 character varying,
    denomination_usuelle_3 character varying,
    categorie_juridique character varying,
    activite_principale character varying,
    nomenclature_activite_principale character varying,
    nic_siege character varying,
    economie_sociale_solidaire character varying,
    caractere_employeur character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: unites_legales_tmp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.unites_legales_tmp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: unites_legales_tmp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.unites_legales_tmp_id_seq OWNED BY public.unites_legales_tmp.id;


--
-- Name: daily_updates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_updates ALTER COLUMN id SET DEFAULT nextval('public.daily_updates_id_seq'::regclass);


--
-- Name: etablissements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.etablissements ALTER COLUMN id SET DEFAULT nextval('public.etablissements_id_seq'::regclass);


--
-- Name: etablissements_tmp id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.etablissements_tmp ALTER COLUMN id SET DEFAULT nextval('public.etablissements_tmp_id_seq'::regclass);


--
-- Name: etablissements_v2 id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.etablissements_v2 ALTER COLUMN id SET DEFAULT nextval('public.etablissements_v2_id_seq'::regclass);


--
-- Name: stocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stocks ALTER COLUMN id SET DEFAULT nextval('public.stocks_id_seq'::regclass);


--
-- Name: unites_legales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unites_legales ALTER COLUMN id SET DEFAULT nextval('public.unites_legales_id_seq'::regclass);


--
-- Name: unites_legales_tmp id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unites_legales_tmp ALTER COLUMN id SET DEFAULT nextval('public.unites_legales_tmp_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: daily_updates daily_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_updates
    ADD CONSTRAINT daily_updates_pkey PRIMARY KEY (id);


--
-- Name: etablissements etablissements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.etablissements
    ADD CONSTRAINT etablissements_pkey PRIMARY KEY (id);


--
-- Name: etablissements_tmp etablissements_tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.etablissements_tmp
    ADD CONSTRAINT etablissements_tmp_pkey PRIMARY KEY (id);


--
-- Name: etablissements_v2 etablissements_v2_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.etablissements_v2
    ADD CONSTRAINT etablissements_v2_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: stocks stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stocks
    ADD CONSTRAINT stocks_pkey PRIMARY KEY (id);


--
-- Name: unites_legales unites_legales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unites_legales
    ADD CONSTRAINT unites_legales_pkey PRIMARY KEY (id);


--
-- Name: unites_legales_tmp unites_legales_tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unites_legales_tmp
    ADD CONSTRAINT unites_legales_tmp_pkey PRIMARY KEY (id);


--
-- Name: entreprises_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entreprises_to_tsvector_idx ON public.etablissements_v2 USING gin (to_tsvector('french'::regconfig, (siren)::text));


--
-- Name: entreprises_to_tsvector_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entreprises_to_tsvector_idx1 ON public.etablissements_v2 USING gin (to_tsvector('french'::regconfig, (siret)::text));


--
-- Name: entreprises_to_tsvector_idx2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entreprises_to_tsvector_idx2 ON public.etablissements_v2 USING gin (to_tsvector('french'::regconfig, (activite_principale)::text));


--
-- Name: entreprises_to_tsvector_idx3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entreprises_to_tsvector_idx3 ON public.etablissements_v2 USING gin (to_tsvector('french'::regconfig, (l6_normalisee)::text));


--
-- Name: entreprises_to_tsvector_idx4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entreprises_to_tsvector_idx4 ON public.etablissements_v2 USING gin (to_tsvector('french'::regconfig, (nom_raison_sociale)::text));


--
-- Name: etablissements_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX etablissements_to_tsvector_idx ON public.etablissements_v2 USING gin (to_tsvector('french'::regconfig, (numero_rna)::text));


--
-- Name: index_etablissements_siren_tmp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_siren_tmp ON public.etablissements USING btree (siren);


--
-- Name: index_etablissements_siret_tmp; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_etablissements_siret_tmp ON public.etablissements USING btree (siret);


--
-- Name: index_etablissements_v2_on_activite_principale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_v2_on_activite_principale ON public.etablissements_v2 USING btree (activite_principale);


--
-- Name: index_etablissements_v2_on_l6_normalisee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_v2_on_l6_normalisee ON public.etablissements_v2 USING btree (l6_normalisee);


--
-- Name: index_etablissements_v2_on_nom_raison_sociale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_v2_on_nom_raison_sociale ON public.etablissements_v2 USING btree (nom_raison_sociale);


--
-- Name: index_etablissements_v2_on_numero_rna; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_v2_on_numero_rna ON public.etablissements_v2 USING btree (numero_rna);


--
-- Name: index_etablissements_v2_on_siren; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_v2_on_siren ON public.etablissements_v2 USING btree (siren);


--
-- Name: index_etablissements_v2_on_siret; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_v2_on_siret ON public.etablissements_v2 USING btree (siret);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170118130314'),
('20170124130819'),
('20170130100203'),
('20170922094826'),
('20170925105117'),
('20180420104754'),
('20180827112250'),
('20181129151018'),
('20190602130719'),
('20190603115019'),
('20190606142656'),
('20190619121622'),
('20190703100825'),
('20191126124448'),
('20191126124456'),
('20200119132507'),
('20200127073524'),
('20200127074730'),
('20200210140344'),
('20200613110234');


