--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4
-- Dumped by pg_dump version 11.4

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
-- Name: etablissements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.etablissements (
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
-- Name: etablissements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.etablissements ALTER COLUMN id SET DEFAULT nextval('public.etablissements_id_seq'::regclass);


--
-- Name: stocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stocks ALTER COLUMN id SET DEFAULT nextval('public.stocks_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: etablissements etablissements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.etablissements
    ADD CONSTRAINT etablissements_pkey PRIMARY KEY (id);


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
-- Name: entreprises_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entreprises_to_tsvector_idx ON public.etablissements USING gin (to_tsvector('french'::regconfig, (siren)::text));


--
-- Name: entreprises_to_tsvector_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entreprises_to_tsvector_idx1 ON public.etablissements USING gin (to_tsvector('french'::regconfig, (siret)::text));


--
-- Name: entreprises_to_tsvector_idx2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entreprises_to_tsvector_idx2 ON public.etablissements USING gin (to_tsvector('french'::regconfig, (activite_principale)::text));


--
-- Name: entreprises_to_tsvector_idx3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entreprises_to_tsvector_idx3 ON public.etablissements USING gin (to_tsvector('french'::regconfig, (l6_normalisee)::text));


--
-- Name: entreprises_to_tsvector_idx4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entreprises_to_tsvector_idx4 ON public.etablissements USING gin (to_tsvector('french'::regconfig, (nom_raison_sociale)::text));


--
-- Name: etablissements_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX etablissements_to_tsvector_idx ON public.etablissements USING gin (to_tsvector('french'::regconfig, (numero_rna)::text));


--
-- Name: index_etablissements_on_activite_principale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_on_activite_principale ON public.etablissements USING btree (activite_principale);


--
-- Name: index_etablissements_on_l6_normalisee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_on_l6_normalisee ON public.etablissements USING btree (l6_normalisee);


--
-- Name: index_etablissements_on_nom_raison_sociale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_on_nom_raison_sociale ON public.etablissements USING btree (nom_raison_sociale);


--
-- Name: index_etablissements_on_numero_rna; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_on_numero_rna ON public.etablissements USING btree (numero_rna);


--
-- Name: index_etablissements_on_siren; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_on_siren ON public.etablissements USING btree (siren);


--
-- Name: index_etablissements_on_siret; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_etablissements_on_siret ON public.etablissements USING btree (siret);


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
('20190603115019');


