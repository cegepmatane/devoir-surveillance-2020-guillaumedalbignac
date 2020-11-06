--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4
-- Dumped by pg_dump version 12.4

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
-- Name: surveillance; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE surveillance WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'French_France.1252' LC_CTYPE = 'French_France.1252';


ALTER DATABASE surveillance OWNER TO postgres;

\connect surveillance

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
-- Name: journaliser(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.journaliser() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
	description text;
    objetAvant text;
    objetApres text;
    operation text;
BEGIN
	objetAvant := '';
	objetApres := '';

	IF TG_OP = 'UPDATE' THEN
    	objetAvant := '{'||OLD.moment||','||OLD.nombre||','||OLD.poidsMoyen||','||OLD.checksum||'}';
   		objetApres := '{'||NEW.moment||','||NEW.nombre||','||NEW.poidsMoyen||','||OLD.checksum||'}';
        operation := 'MODIFIER';
    END IF;
	IF TG_OP = 'INSERT' THEN
    	objetAvant := '{}';
   		objetApres := '{'||NEW.moment||','||NEW.nombre||','||NEW.poidsMoyen||','||OLD.checksum||'}';
        operation := 'AJOUTER';
    END IF;
	IF TG_OP = 'DELETE' THEN
    	objetAvant := '{'||OLD.moment||','||OLD.nombre||','||OLD.poidsMoyen||','||OLD.checksum||'}';
    	objetApres := '{}';
        operation := 'EFFACER';
    END IF;

	description := objetAvant || ' -> ' || objetApres;
    
	INSERT into journal(moment, operation, objet, description) VALUES(NOW(), operation, 'robot', description);
    
	IF TG_OP = 'DELETE' THEN
		return OLD;
	END IF; 
    return NEW;
END
$$;


ALTER FUNCTION public.journaliser() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: concepteur_statistiques; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.concepteur_statistiques (
    id integer NOT NULL,
    moment timestamp with time zone,
    nombre integer,
    "ageMoyen" double precision,
    checksum text
);


ALTER TABLE public.concepteur_statistiques OWNER TO postgres;

--
-- Name: concepteur_statistiques_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.concepteur_statistiques_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.concepteur_statistiques_id_seq OWNER TO postgres;

--
-- Name: concepteur_statistiques_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.concepteur_statistiques_id_seq OWNED BY public.concepteur_statistiques.id;


--
-- Name: journal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.journal (
    id integer NOT NULL,
    moment timestamp with time zone,
    operation text,
    objet text,
    description text
);


ALTER TABLE public.journal OWNER TO postgres;

--
-- Name: journal_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.journal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_id_seq OWNER TO postgres;

--
-- Name: journal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.journal_id_seq OWNED BY public.journal.id;


--
-- Name: robot_statistiques; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.robot_statistiques (
    id integer NOT NULL,
    moment timestamp with time zone,
    nombre integer,
    "poidsMoyen" double precision,
    checksum text
);


ALTER TABLE public.robot_statistiques OWNER TO postgres;

--
-- Name: robot_statistiques_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.robot_statistiques_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.robot_statistiques_id_seq OWNER TO postgres;

--
-- Name: robot_statistiques_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.robot_statistiques_id_seq OWNED BY public.robot_statistiques.id;


--
-- Name: concepteur_statistiques id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.concepteur_statistiques ALTER COLUMN id SET DEFAULT nextval('public.concepteur_statistiques_id_seq'::regclass);


--
-- Name: journal id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal ALTER COLUMN id SET DEFAULT nextval('public.journal_id_seq'::regclass);


--
-- Name: robot_statistiques id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.robot_statistiques ALTER COLUMN id SET DEFAULT nextval('public.robot_statistiques_id_seq'::regclass);


--
-- Data for Name: concepteur_statistiques; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.concepteur_statistiques VALUES (1, '2020-10-20 13:13:13+02', 3, 27, '...
');
INSERT INTO public.concepteur_statistiques VALUES (2, '2020-10-25 06:43:10+01', 15, 32, '...');
INSERT INTO public.concepteur_statistiques VALUES (3, '2020-10-26 14:06:12+01', 14, 24, '...');


--
-- Data for Name: journal; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: robot_statistiques; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.robot_statistiques VALUES (1, '2020-10-19 10:23:54+02', 2, 5.1, 'df5ea29924d39c3be8785734f13169c6');
INSERT INTO public.robot_statistiques VALUES (2, '2020-10-23 08:56:24+02', 4, 7.2, '721a9b52bfceacc503c056e3b9b93cfa');
INSERT INTO public.robot_statistiques VALUES (3, '2020-10-28 15:34:11+01', 7, 6.5, 'ded2a04774ebf30df7b601b08b09c999');
INSERT INTO public.robot_statistiques VALUES (4, '2020-11-28 04:24:11+01', 3, 8.4, 'frd2a04774ebf40df7b601b08b09c666');


--
-- Name: concepteur_statistiques_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.concepteur_statistiques_id_seq', 1, false);


--
-- Name: journal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.journal_id_seq', 1, false);


--
-- Name: robot_statistiques_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.robot_statistiques_id_seq', 1, false);


--
-- Name: concepteur_statistiques concepteur_statistiques_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.concepteur_statistiques
    ADD CONSTRAINT concepteur_statistiques_pkey PRIMARY KEY (id);


--
-- Name: journal journal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_pkey PRIMARY KEY (id);


--
-- Name: robot_statistiques robot_statistiques_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.robot_statistiques
    ADD CONSTRAINT robot_statistiques_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

