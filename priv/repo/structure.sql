--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: tsm_system_rows; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS tsm_system_rows WITH SCHEMA public;


--
-- Name: EXTENSION tsm_system_rows; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION tsm_system_rows IS 'TABLESAMPLE method which accepts number of rows as a limit';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: authors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authors (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    slug character varying
);


--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.authors_id_seq OWNED BY public.authors.id;


--
-- Name: bde_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bde_questions (
    id bigint NOT NULL,
    bank character varying,
    entity character varying,
    exam character varying,
    year integer,
    content text,
    alternatives jsonb,
    source_id integer,
    broken boolean,
    correct character varying,
    tag1 character varying,
    tag2 character varying,
    tag3 character varying,
    question_uuid uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tag4 character varying,
    tag5 character varying,
    associated_text text,
    question_id bigint
);


--
-- Name: bde_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bde_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bde_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bde_questions_id_seq OWNED BY public.bde_questions.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    content text,
    question_id bigint NOT NULL,
    teacher_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: elixir_schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.elixir_schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    category text,
    action text,
    label text,
    value text,
    properties jsonb,
    user_id bigint,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: exam_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exam_questions (
    id bigint NOT NULL,
    question_uuid uuid,
    exam_uuid uuid,
    "position" integer,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    exam_id bigint,
    question_id bigint
);


--
-- Name: exam_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exam_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exam_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exam_questions_id_seq OWNED BY public.exam_questions.id;


--
-- Name: exam_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exam_sessions (
    id bigint NOT NULL,
    user_id bigint,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    exam_uuid uuid,
    responses_count integer,
    exam_id bigint,
    correct_questions_count integer DEFAULT 0
);


--
-- Name: exam_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exam_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exam_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exam_sessions_id_seq OWNED BY public.exam_sessions.id;


--
-- Name: exams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exams (
    name character varying,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    organization_id bigint,
    year integer,
    edition character varying,
    speciality character varying,
    area character varying,
    author_id bigint,
    exam_questions_count integer,
    job_id bigint,
    id bigint NOT NULL,
    educational_level character varying(255),
    sessions_data jsonb DEFAULT '{"finished_sessions_count": 0, "mean_percentage_correct": 0}'::jsonb
);


--
-- Name: exams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exams_id_seq OWNED BY public.exams.id;


--
-- Name: fd_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fd_questions (
    id bigint NOT NULL,
    source_id character varying,
    content text,
    alternatives jsonb,
    job character varying,
    bank character varying,
    year integer,
    discipline character varying,
    exam character varying,
    broken boolean,
    resolution character varying,
    entity character varying,
    correct integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    question_uuid uuid,
    question_id bigint
);


--
-- Name: fd_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fd_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fd_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fd_questions_id_seq OWNED BY public.fd_questions.id;


--
-- Name: guardian_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guardian_tokens (
    jti character varying(255) NOT NULL,
    aud character varying(255) NOT NULL,
    typ character varying(255),
    iss character varying(255),
    sub character varying(255),
    exp bigint,
    jwt text,
    claims jsonb,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    slug character varying
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: jwt_blacklists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jwt_blacklists (
    id bigint NOT NULL,
    jti character varying NOT NULL,
    exp timestamp without time zone NOT NULL
);


--
-- Name: jwt_blacklists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jwt_blacklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jwt_blacklists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jwt_blacklists_id_seq OWNED BY public.jwt_blacklists.id;


--
-- Name: notification_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_messages (
    id bigint NOT NULL,
    additional_data jsonb,
    raw_body text,
    raw_title character varying(255),
    viewed_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    recipient_user_id bigint,
    notification_type_id bigint,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: notification_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_messages_id_seq OWNED BY public.notification_messages.id;


--
-- Name: notification_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_types (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(255),
    identifier character varying(255),
    title_template character varying(255),
    body_template text,
    available_placeholders text,
    user_can_optin_out boolean DEFAULT false NOT NULL,
    channels character varying(255)[],
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: notification_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_types_id_seq OWNED BY public.notification_types.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name character varying,
    logo character varying,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    slug character varying
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: qc_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.qc_questions (
    id bigint NOT NULL,
    source_id character varying,
    content text,
    alternatives jsonb,
    stats jsonb,
    comments text,
    bank character varying,
    year character varying,
    exam character varying,
    broken boolean,
    entity character varying,
    tag1 character varying,
    tag2 character varying,
    tag3 character varying,
    question_uuid uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    question_id bigint
);


--
-- Name: qc_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.qc_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: qc_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.qc_questions_id_seq OWNED BY public.qc_questions.id;


--
-- Name: question_alternatives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.question_alternatives (
    id bigint NOT NULL,
    content text,
    letter character varying,
    correct boolean,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    question_uuid uuid,
    counter integer,
    question_id bigint
);


--
-- Name: question_alternatives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.question_alternatives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: question_alternatives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.question_alternatives_id_seq OWNED BY public.question_alternatives.id;


--
-- Name: question_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.question_sources (
    id bigint NOT NULL,
    question_uuid uuid,
    source_id character varying NOT NULL,
    source_name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    question_id bigint
);


--
-- Name: question_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.question_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: question_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.question_sources_id_seq OWNED BY public.question_sources.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    content text,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    cancelled boolean DEFAULT false,
    broken boolean DEFAULT false,
    outdated boolean DEFAULT false,
    id bigint NOT NULL,
    difficulty double precision,
    internal_id character varying
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: questions_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions_tags (
    tag_id bigint NOT NULL,
    question_uuid uuid,
    id bigint NOT NULL,
    question_id bigint
);


--
-- Name: questions_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.questions_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_tags_id_seq OWNED BY public.questions_tags.id;


--
-- Name: responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.responses (
    id bigint NOT NULL,
    question_alternative_id bigint,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    exam_session_id bigint,
    question_uuid uuid,
    user_id bigint,
    training_id bigint,
    question_id bigint
);


--
-- Name: responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.responses_id_seq OWNED BY public.responses.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying,
    kind character varying,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    slug character varying
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: teachers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teachers (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: teachers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teachers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teachers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teachers_id_seq OWNED BY public.teachers.id;


--
-- Name: tec_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tec_questions (
    id bigint NOT NULL,
    source_id character varying,
    question_number integer,
    content text,
    alternatives jsonb,
    discipline character varying,
    subject character varying,
    chapter character varying,
    exam_area character varying,
    exam_speciality character varying,
    entity_logo character varying,
    has_comment boolean,
    canceled boolean,
    bank character varying,
    entity character varying,
    job character varying,
    exam_source_id integer,
    year integer,
    number_exams integer,
    has_unseen_posts boolean,
    has_bank_solution boolean,
    question_format character varying,
    preliminary_answer_key boolean,
    stale boolean,
    stale_with_preliminary_answer_key boolean,
    stale_with_definite_answer_key boolean,
    hidden boolean,
    publication_date date,
    comment jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    exam_edition character varying,
    question_uuid uuid,
    question_id bigint
);


--
-- Name: tec_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tec_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tec_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tec_questions_id_seq OWNED BY public.tec_questions.id;


--
-- Name: training_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.training_questions (
    id bigint NOT NULL,
    training_id bigint NOT NULL,
    question_uuid uuid,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    question_id bigint,
    "position" integer
);


--
-- Name: training_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.training_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.training_questions_id_seq OWNED BY public.training_questions.id;


--
-- Name: trainings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trainings (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    name character varying,
    questions_count integer,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    responses_count integer,
    algorithm character varying(255),
    filter jsonb
);


--
-- Name: trainings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trainings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trainings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trainings_id_seq OWNED BY public.trainings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying,
    email character varying DEFAULT ''::character varying NOT NULL,
    phone character varying,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(0) without time zone,
    remember_created_at timestamp(0) without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp(0) without time zone,
    last_sign_in_at timestamp(0) without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp(0) without time zone,
    confirmation_sent_at timestamp(0) without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp(0) without time zone,
    auth_token character varying(255),
    account_type character varying(255),
    trial_expiration_date date,
    goals jsonb DEFAULT '{"jobs": [], "organizations": []}'::jsonb,
    viewed_tours jsonb DEFAULT '{"menu": false, "search": false, "new_training": false}'::jsonb,
    answered_questions_for_popup integer DEFAULT 0,
    notification_settings jsonb
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id bigint NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone,
    object_changes text
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: authors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authors ALTER COLUMN id SET DEFAULT nextval('public.authors_id_seq'::regclass);


--
-- Name: bde_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bde_questions ALTER COLUMN id SET DEFAULT nextval('public.bde_questions_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: exam_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_questions ALTER COLUMN id SET DEFAULT nextval('public.exam_questions_id_seq'::regclass);


--
-- Name: exam_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_sessions ALTER COLUMN id SET DEFAULT nextval('public.exam_sessions_id_seq'::regclass);


--
-- Name: exams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams ALTER COLUMN id SET DEFAULT nextval('public.exams_id_seq'::regclass);


--
-- Name: fd_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fd_questions ALTER COLUMN id SET DEFAULT nextval('public.fd_questions_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: jwt_blacklists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jwt_blacklists ALTER COLUMN id SET DEFAULT nextval('public.jwt_blacklists_id_seq'::regclass);


--
-- Name: notification_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_messages ALTER COLUMN id SET DEFAULT nextval('public.notification_messages_id_seq'::regclass);


--
-- Name: notification_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_types ALTER COLUMN id SET DEFAULT nextval('public.notification_types_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: qc_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qc_questions ALTER COLUMN id SET DEFAULT nextval('public.qc_questions_id_seq'::regclass);


--
-- Name: question_alternatives id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question_alternatives ALTER COLUMN id SET DEFAULT nextval('public.question_alternatives_id_seq'::regclass);


--
-- Name: question_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question_sources ALTER COLUMN id SET DEFAULT nextval('public.question_sources_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: questions_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions_tags ALTER COLUMN id SET DEFAULT nextval('public.questions_tags_id_seq'::regclass);


--
-- Name: responses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responses ALTER COLUMN id SET DEFAULT nextval('public.responses_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: teachers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teachers ALTER COLUMN id SET DEFAULT nextval('public.teachers_id_seq'::regclass);


--
-- Name: tec_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tec_questions ALTER COLUMN id SET DEFAULT nextval('public.tec_questions_id_seq'::regclass);


--
-- Name: training_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_questions ALTER COLUMN id SET DEFAULT nextval('public.training_questions_id_seq'::regclass);


--
-- Name: trainings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trainings ALTER COLUMN id SET DEFAULT nextval('public.trainings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: bde_questions bde_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bde_questions
    ADD CONSTRAINT bde_questions_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: elixir_schema_migrations elixir_schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elixir_schema_migrations
    ADD CONSTRAINT elixir_schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: exam_questions exam_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_questions
    ADD CONSTRAINT exam_questions_pkey PRIMARY KEY (id);


--
-- Name: exam_sessions exam_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT exam_sessions_pkey PRIMARY KEY (id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- Name: fd_questions fd_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fd_questions
    ADD CONSTRAINT fd_questions_pkey PRIMARY KEY (id);


--
-- Name: guardian_tokens guardian_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guardian_tokens
    ADD CONSTRAINT guardian_tokens_pkey PRIMARY KEY (jti, aud);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: jwt_blacklists jwt_blacklists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jwt_blacklists
    ADD CONSTRAINT jwt_blacklists_pkey PRIMARY KEY (id);


--
-- Name: notification_messages notification_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_messages
    ADD CONSTRAINT notification_messages_pkey PRIMARY KEY (id);


--
-- Name: notification_types notification_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_types
    ADD CONSTRAINT notification_types_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: qc_questions qc_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qc_questions
    ADD CONSTRAINT qc_questions_pkey PRIMARY KEY (id);


--
-- Name: question_alternatives question_alternatives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question_alternatives
    ADD CONSTRAINT question_alternatives_pkey PRIMARY KEY (id);


--
-- Name: question_sources question_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question_sources
    ADD CONSTRAINT question_sources_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: questions_tags questions_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions_tags
    ADD CONSTRAINT questions_tags_pkey PRIMARY KEY (id);


--
-- Name: responses responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT responses_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- Name: tec_questions tec_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tec_questions
    ADD CONSTRAINT tec_questions_pkey PRIMARY KEY (id);


--
-- Name: training_questions training_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_questions
    ADD CONSTRAINT training_questions_pkey PRIMARY KEY (id);


--
-- Name: trainings trainings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trainings
    ADD CONSTRAINT trainings_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: exams_educational_level_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exams_educational_level_index ON public.exams USING btree (educational_level);


--
-- Name: exams_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exams_name_index ON public.exams USING btree (name);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_email ON public.admins USING btree (email);


--
-- Name: index_admins_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_name ON public.admins USING btree (name);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON public.admins USING btree (reset_password_token);


--
-- Name: index_admins_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_unlock_token ON public.admins USING btree (unlock_token);


--
-- Name: index_authors_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_authors_on_name ON public.authors USING btree (name);


--
-- Name: index_bde_questions_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bde_questions_on_question_id ON public.bde_questions USING btree (question_id);


--
-- Name: index_bde_questions_on_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bde_questions_on_question_uuid ON public.bde_questions USING btree (question_uuid);


--
-- Name: index_bde_questions_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bde_questions_on_source_id ON public.bde_questions USING btree (source_id);


--
-- Name: index_comments_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_question_id ON public.comments USING btree (question_id);


--
-- Name: index_comments_on_teacher_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_teacher_id ON public.comments USING btree (teacher_id);


--
-- Name: index_exam_questions_on_exam_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exam_questions_on_exam_id ON public.exam_questions USING btree (exam_id);


--
-- Name: index_exam_questions_on_exam_id_and_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_exam_questions_on_exam_id_and_question_id ON public.exam_questions USING btree (exam_id, question_id);


--
-- Name: index_exam_questions_on_exam_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exam_questions_on_exam_uuid ON public.exam_questions USING btree (exam_uuid);


--
-- Name: index_exam_questions_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exam_questions_on_question_id ON public.exam_questions USING btree (question_id);


--
-- Name: index_exam_questions_on_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exam_questions_on_question_uuid ON public.exam_questions USING btree (question_uuid);


--
-- Name: index_exam_sessions_on_exam_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exam_sessions_on_exam_id ON public.exam_sessions USING btree (exam_id);


--
-- Name: index_exam_sessions_on_exam_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exam_sessions_on_exam_uuid ON public.exam_sessions USING btree (exam_uuid);


--
-- Name: index_exam_sessions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exam_sessions_on_user_id ON public.exam_sessions USING btree (user_id);


--
-- Name: index_exams_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exams_on_author_id ON public.exams USING btree (author_id);


--
-- Name: index_exams_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exams_on_job_id ON public.exams USING btree (job_id);


--
-- Name: index_exams_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exams_on_organization_id ON public.exams USING btree (organization_id);


--
-- Name: index_fd_questions_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fd_questions_on_question_id ON public.fd_questions USING btree (question_id);


--
-- Name: index_fd_questions_on_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fd_questions_on_question_uuid ON public.fd_questions USING btree (question_uuid);


--
-- Name: index_jwt_blacklists_on_jti; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jwt_blacklists_on_jti ON public.jwt_blacklists USING btree (jti);


--
-- Name: index_notification_types_on_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_notification_types_on_identifier ON public.notification_types USING btree (identifier);


--
-- Name: index_organizations_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_name ON public.organizations USING btree (name);


--
-- Name: index_qc_questions_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_qc_questions_on_question_id ON public.qc_questions USING btree (question_id);


--
-- Name: index_qc_questions_on_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_qc_questions_on_question_uuid ON public.qc_questions USING btree (question_uuid);


--
-- Name: index_qc_questions_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_qc_questions_on_source_id ON public.qc_questions USING btree (source_id);


--
-- Name: index_question_alternatives_on_correct_and_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_question_alternatives_on_correct_and_question_id ON public.question_alternatives USING btree (correct, question_id) WHERE (correct = true);


--
-- Name: index_question_alternatives_on_correct_and_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_question_alternatives_on_correct_and_question_uuid ON public.question_alternatives USING btree (correct, question_uuid) WHERE (correct = true);


--
-- Name: index_question_alternatives_on_letter_and_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_question_alternatives_on_letter_and_question_id ON public.question_alternatives USING btree (letter, question_id);


--
-- Name: index_question_alternatives_on_letter_and_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_question_alternatives_on_letter_and_question_uuid ON public.question_alternatives USING btree (letter, question_uuid);


--
-- Name: index_question_alternatives_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_alternatives_on_question_id ON public.question_alternatives USING btree (question_id);


--
-- Name: index_question_alternatives_on_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_alternatives_on_question_uuid ON public.question_alternatives USING btree (question_uuid);


--
-- Name: index_question_sources_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_sources_on_question_id ON public.question_sources USING btree (question_id);


--
-- Name: index_question_sources_on_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_sources_on_question_uuid ON public.question_sources USING btree (question_uuid);


--
-- Name: index_question_sources_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_sources_on_source_id ON public.question_sources USING btree (source_id);


--
-- Name: index_question_sources_on_source_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_sources_on_source_name ON public.question_sources USING btree (source_name);


--
-- Name: index_questions_on_internal_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_questions_on_internal_id ON public.questions USING btree (internal_id);


--
-- Name: index_questions_tags_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_tags_on_question_id ON public.questions_tags USING btree (question_id);


--
-- Name: index_questions_tags_on_question_id_and_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_questions_tags_on_question_id_and_tag_id ON public.questions_tags USING btree (question_id, tag_id);


--
-- Name: index_questions_tags_on_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_tags_on_question_uuid ON public.questions_tags USING btree (question_uuid);


--
-- Name: index_questions_tags_on_question_uuid_and_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_questions_tags_on_question_uuid_and_tag_id ON public.questions_tags USING btree (question_uuid, tag_id);


--
-- Name: index_responses_on_exam_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_responses_on_exam_session_id ON public.responses USING btree (exam_session_id);


--
-- Name: index_responses_on_question_alternative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_responses_on_question_alternative_id ON public.responses USING btree (question_alternative_id);


--
-- Name: index_responses_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_responses_on_question_id ON public.responses USING btree (question_id);


--
-- Name: index_responses_on_question_id_and_exam_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_responses_on_question_id_and_exam_session_id ON public.responses USING btree (question_id, exam_session_id);


--
-- Name: index_responses_on_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_responses_on_question_uuid ON public.responses USING btree (question_uuid);


--
-- Name: index_responses_on_question_uuid_and_exam_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_responses_on_question_uuid_and_exam_session_id ON public.responses USING btree (question_uuid, exam_session_id);


--
-- Name: index_responses_on_training_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_responses_on_training_id ON public.responses USING btree (training_id);


--
-- Name: index_responses_on_training_id_and_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_responses_on_training_id_and_question_id ON public.responses USING btree (training_id, question_id);


--
-- Name: index_responses_on_training_id_and_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_responses_on_training_id_and_question_uuid ON public.responses USING btree (training_id, question_uuid);


--
-- Name: index_responses_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_responses_on_user_id ON public.responses USING btree (user_id);


--
-- Name: index_tags_on_name_and_kind; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name_and_kind ON public.tags USING btree (name, kind);


--
-- Name: index_tec_questions_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tec_questions_on_question_id ON public.tec_questions USING btree (question_id);


--
-- Name: index_tec_questions_on_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tec_questions_on_question_uuid ON public.tec_questions USING btree (question_uuid);


--
-- Name: index_training_questions_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_questions_on_question_id ON public.training_questions USING btree (question_id);


--
-- Name: index_training_questions_on_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_questions_on_question_uuid ON public.training_questions USING btree (question_uuid);


--
-- Name: index_training_questions_on_training_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_questions_on_training_id ON public.training_questions USING btree (training_id);


--
-- Name: index_training_questions_on_training_id_and_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_training_questions_on_training_id_and_question_id ON public.training_questions USING btree (training_id, question_id);


--
-- Name: index_training_questions_on_training_id_and_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_training_questions_on_training_id_and_question_uuid ON public.training_questions USING btree (training_id, question_uuid);


--
-- Name: index_trainings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trainings_on_user_id ON public.trainings USING btree (user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: notification_messages_notification_type_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notification_messages_notification_type_id_index ON public.notification_messages USING btree (notification_type_id);


--
-- Name: notification_messages_recipient_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notification_messages_recipient_user_id_index ON public.notification_messages USING btree (recipient_user_id);


--
-- Name: trainings_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trainings_name_index ON public.trainings USING btree (name);


--
-- Name: events events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: exam_sessions fk_rails_04b9319a2a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT fk_rails_04b9319a2a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: exam_sessions fk_rails_051fc5469b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT fk_rails_051fc5469b FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- Name: training_questions fk_rails_105b4dc9e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_questions
    ADD CONSTRAINT fk_rails_105b4dc9e7 FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: responses fk_rails_2bd9a0753e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT fk_rails_2bd9a0753e FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: question_sources fk_rails_2d0496b581; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question_sources
    ADD CONSTRAINT fk_rails_2d0496b581 FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: comments fk_rails_2f2557d9f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_2f2557d9f5 FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: responses fk_rails_325af149a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT fk_rails_325af149a3 FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: comments fk_rails_3db1ea3362; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_3db1ea3362 FOREIGN KEY (teacher_id) REFERENCES public.teachers(id);


--
-- Name: questions_tags fk_rails_3fd077fb33; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions_tags
    ADD CONSTRAINT fk_rails_3fd077fb33 FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: responses fk_rails_55142ba0a2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT fk_rails_55142ba0a2 FOREIGN KEY (question_alternative_id) REFERENCES public.question_alternatives(id);


--
-- Name: question_alternatives fk_rails_5ad99cbbe5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question_alternatives
    ADD CONSTRAINT fk_rails_5ad99cbbe5 FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: exam_questions fk_rails_819be3c7b2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_questions
    ADD CONSTRAINT fk_rails_819be3c7b2 FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: questions_tags fk_rails_98659cdfc1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions_tags
    ADD CONSTRAINT fk_rails_98659cdfc1 FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: training_questions fk_rails_9b9f79d1dc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_questions
    ADD CONSTRAINT fk_rails_9b9f79d1dc FOREIGN KEY (training_id) REFERENCES public.trainings(id);


--
-- Name: exam_questions fk_rails_b45b8182ff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_questions
    ADD CONSTRAINT fk_rails_b45b8182ff FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- Name: responses fk_rails_c8159ea1eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT fk_rails_c8159ea1eb FOREIGN KEY (training_id) REFERENCES public.trainings(id);


--
-- Name: exams fk_rails_d24e5abd2d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT fk_rails_d24e5abd2d FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: trainings fk_rails_db3101896b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trainings
    ADD CONSTRAINT fk_rails_db3101896b FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: exams fk_rails_e8b83458cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT fk_rails_e8b83458cb FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: responses fk_rails_f10e1eb14a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT fk_rails_f10e1eb14a FOREIGN KEY (exam_session_id) REFERENCES public.exam_sessions(id);


--
-- Name: notification_messages notification_messages_notification_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_messages
    ADD CONSTRAINT notification_messages_notification_type_id_fkey FOREIGN KEY (notification_type_id) REFERENCES public.notification_types(id);


--
-- Name: notification_messages notification_messages_recipient_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_messages
    ADD CONSTRAINT notification_messages_recipient_user_id_fkey FOREIGN KEY (recipient_user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."elixir_schema_migrations" (version) VALUES (20190818174810), (20190821132626), (20190821203854), (20190821203859), (20190829213045), (20190902202649), (20190903183206), (20190917140506), (20191001152345), (20191021153536), (20191022140834), (20191022141257), (20191022150440), (20191023145534), (20191025135831), (20191030015835), (20191104170148), (20191104170619), (20191106142448), (20191114130141), (20191126210407), (20191126211720), (20191126211957), (20191128150230), (20191128194302), (20191129143439), (20191203133000), (20191203133030), (20191203133050), (20191203133953), (20191203134211), (20191203141122), (20191203141503), (20191205132640), (20191205190131), (20191205201356), (20191207124310), (20191210151014), (20191217133028), (20200114191056), (20200115192504);

