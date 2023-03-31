--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Homebrew)
-- Dumped by pg_dump version 15.2 (Homebrew)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actor_title_character; Type: TABLE; Schema: public; Owner: rohaan
--

CREATE TABLE public.actor_title_character (
    title integer NOT NULL,
    actor integer NOT NULL,
    "character" integer NOT NULL
);


ALTER TABLE public.actor_title_character OWNER TO rohaan;

--
-- Name: character; Type: TABLE; Schema: public; Owner: rohaan
--

CREATE TABLE public."character" (
    id integer NOT NULL,
    "character" text
);


ALTER TABLE public."character" OWNER TO rohaan;

--
-- Name: character_id_seq; Type: SEQUENCE; Schema: public; Owner: rohaan
--

CREATE SEQUENCE public.character_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.character_id_seq OWNER TO rohaan;

--
-- Name: character_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rohaan
--

ALTER SEQUENCE public.character_id_seq OWNED BY public."character".id;


--
-- Name: genre; Type: TABLE; Schema: public; Owner: rohaan
--

CREATE TABLE public.genre (
    id integer NOT NULL,
    genre character varying(15)
);


ALTER TABLE public.genre OWNER TO rohaan;

--
-- Name: genre_id_seq; Type: SEQUENCE; Schema: public; Owner: rohaan
--

CREATE SEQUENCE public.genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.genre_id_seq OWNER TO rohaan;

--
-- Name: genre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rohaan
--

ALTER SEQUENCE public.genre_id_seq OWNED BY public.genre.id;


--
-- Name: title; Type: TABLE; Schema: public; Owner: rohaan
--

CREATE TABLE public.title (
    id integer NOT NULL,
    title_type character varying(50),
    title text,
    originaltitle text,
    startyear smallint,
    endyear smallint,
    runtime integer,
    avgrating numeric(3,1),
    numvotes integer
);


ALTER TABLE public.title OWNER TO rohaan;

--
-- Name: long_movies; Type: VIEW; Schema: public; Owner: rohaan
--

CREATE VIEW public.long_movies AS
 SELECT title.id,
    title.title_type,
    title.title,
    title.originaltitle,
    title.startyear,
    title.endyear,
    title.runtime,
    title.avgrating,
    title.numvotes
   FROM public.title
  WHERE (title.runtime >= 90)
  ORDER BY title.runtime, title.id;


ALTER TABLE public.long_movies OWNER TO rohaan;

--
-- Name: member; Type: TABLE; Schema: public; Owner: rohaan
--

CREATE TABLE public.member (
    id integer NOT NULL,
    name text,
    birthyear smallint,
    deathyear smallint
);


ALTER TABLE public.member OWNER TO rohaan;

--
-- Name: title_genre; Type: TABLE; Schema: public; Owner: rohaan
--

CREATE TABLE public.title_genre (
    genre smallint NOT NULL,
    title integer NOT NULL
);


ALTER TABLE public.title_genre OWNER TO rohaan;

--
-- Name: movie_genres; Type: VIEW; Schema: public; Owner: rohaan
--

CREATE VIEW public.movie_genres AS
 SELECT tg.genre AS "genreID",
    g.genre,
    tg.title
   FROM (public.title_genre tg
     JOIN public.genre g ON ((g.id = tg.genre)));


ALTER TABLE public.movie_genres OWNER TO rohaan;

--
-- Name: title_actor; Type: TABLE; Schema: public; Owner: rohaan
--

CREATE TABLE public.title_actor (
    actor integer NOT NULL,
    title integer NOT NULL
);


ALTER TABLE public.title_actor OWNER TO rohaan;

--
-- Name: title_director; Type: TABLE; Schema: public; Owner: rohaan
--

CREATE TABLE public.title_director (
    director integer NOT NULL,
    title integer NOT NULL
);


ALTER TABLE public.title_director OWNER TO rohaan;

--
-- Name: title_producer; Type: TABLE; Schema: public; Owner: rohaan
--

CREATE TABLE public.title_producer (
    producer integer NOT NULL,
    title integer NOT NULL
);


ALTER TABLE public.title_producer OWNER TO rohaan;

--
-- Name: title_writer; Type: TABLE; Schema: public; Owner: rohaan
--

CREATE TABLE public.title_writer (
    writer integer NOT NULL,
    title integer NOT NULL
);


ALTER TABLE public.title_writer OWNER TO rohaan;

--
-- Name: valid_actors; Type: MATERIALIZED VIEW; Schema: public; Owner: rohaan
--

CREATE MATERIALIZED VIEW public.valid_actors AS
 SELECT DISTINCT title_actor.actor
   FROM public.title_actor
  WITH NO DATA;


ALTER TABLE public.valid_actors OWNER TO rohaan;

--
-- Name: valid_titles; Type: MATERIALIZED VIEW; Schema: public; Owner: rohaan
--

CREATE MATERIALIZED VIEW public.valid_titles AS
 SELECT DISTINCT title.id
   FROM public.title
  ORDER BY title.id
  WITH NO DATA;


ALTER TABLE public.valid_titles OWNER TO rohaan;

--
-- Name: character id; Type: DEFAULT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public."character" ALTER COLUMN id SET DEFAULT nextval('public.character_id_seq'::regclass);


--
-- Name: genre id; Type: DEFAULT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.genre ALTER COLUMN id SET DEFAULT nextval('public.genre_id_seq'::regclass);


--
-- Name: character character_pkey; Type: CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public."character"
    ADD CONSTRAINT character_pkey PRIMARY KEY (id);


--
-- Name: genre genre_pkey; Type: CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: actor_title_character pk_atc; Type: CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.actor_title_character
    ADD CONSTRAINT pk_atc PRIMARY KEY (title, actor, "character");


--
-- Name: title_actor pk_title_actor; Type: CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_actor
    ADD CONSTRAINT pk_title_actor PRIMARY KEY (actor, title);


--
-- Name: title_director pk_title_director; Type: CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_director
    ADD CONSTRAINT pk_title_director PRIMARY KEY (director, title);


--
-- Name: title_genre pk_title_genre; Type: CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_genre
    ADD CONSTRAINT pk_title_genre PRIMARY KEY (genre, title);


--
-- Name: title_producer pk_title_producer; Type: CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_producer
    ADD CONSTRAINT pk_title_producer PRIMARY KEY (producer, title);


--
-- Name: title_writer pk_title_writer; Type: CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_writer
    ADD CONSTRAINT pk_title_writer PRIMARY KEY (writer, title);


--
-- Name: title title_pkey; Type: CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title
    ADD CONSTRAINT title_pkey PRIMARY KEY (id);


--
-- Name: actor_title_character_title_idx; Type: INDEX; Schema: public; Owner: rohaan
--

CREATE INDEX actor_title_character_title_idx ON public.actor_title_character USING btree (title);


--
-- Name: actor_title_character fk_atc_actor; Type: FK CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.actor_title_character
    ADD CONSTRAINT fk_atc_actor FOREIGN KEY (actor) REFERENCES public.member(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: actor_title_character fk_atc_character; Type: FK CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.actor_title_character
    ADD CONSTRAINT fk_atc_character FOREIGN KEY ("character") REFERENCES public."character"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: actor_title_character fk_atc_title; Type: FK CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.actor_title_character
    ADD CONSTRAINT fk_atc_title FOREIGN KEY (title) REFERENCES public.title(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: title_actor fk_title_actor_actor; Type: FK CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_actor
    ADD CONSTRAINT fk_title_actor_actor FOREIGN KEY (actor) REFERENCES public.member(id);


--
-- Name: title_actor fk_title_actor_title; Type: FK CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_actor
    ADD CONSTRAINT fk_title_actor_title FOREIGN KEY (title) REFERENCES public.title(id);


--
-- Name: title_director fk_title_director_director; Type: FK CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_director
    ADD CONSTRAINT fk_title_director_director FOREIGN KEY (director) REFERENCES public.member(id);


--
-- Name: title_genre fk_title_genre_genre; Type: FK CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_genre
    ADD CONSTRAINT fk_title_genre_genre FOREIGN KEY (genre) REFERENCES public.genre(id);


--
-- Name: title_genre fk_title_genre_title; Type: FK CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_genre
    ADD CONSTRAINT fk_title_genre_title FOREIGN KEY (title) REFERENCES public.title(id);


--
-- Name: title_producer fk_title_producer_producer; Type: FK CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_producer
    ADD CONSTRAINT fk_title_producer_producer FOREIGN KEY (producer) REFERENCES public.member(id);


--
-- Name: title_writer fk_title_writer_writer; Type: FK CONSTRAINT; Schema: public; Owner: rohaan
--

ALTER TABLE ONLY public.title_writer
    ADD CONSTRAINT fk_title_writer_writer FOREIGN KEY (writer) REFERENCES public.member(id);


--
-- PostgreSQL database dump complete
--

