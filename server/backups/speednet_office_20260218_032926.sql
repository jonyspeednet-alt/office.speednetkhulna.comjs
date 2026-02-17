--
-- PostgreSQL database dump
--

\restrict 3EtYaUoyFBUGZXSRdP6FCjEWyxIwkVYbvMb8epvDcaM8OVQOXrLI503rzzG4M8L

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_role_id_fkey;
ALTER TABLE IF EXISTS ONLY public.leave_entitlements DROP CONSTRAINT IF EXISTS leave_entitlements_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.leave_entitlements DROP CONSTRAINT IF EXISTS leave_entitlements_leave_type_id_fkey;
DROP TRIGGER IF EXISTS update_roles_updated_at ON public.roles;
DROP TRIGGER IF EXISTS trg_leave_entitlements_updated_at ON public.leave_entitlements;
DROP INDEX IF EXISTS public.user_id;
DROP INDEX IF EXISTS public.reseller_id;
DROP INDEX IF EXISTS public.proposed_by;
DROP INDEX IF EXISTS public.po_id;
DROP INDEX IF EXISTS public.idx_leave_requests_leave_type_id;
DROP INDEX IF EXISTS public.idx_leave_entitlements_user_year;
DROP INDEX IF EXISTS public.fk_leave_request_rel;
DROP INDEX IF EXISTS public.fk_bw_request_reseller;
DROP INDEX IF EXISTS public.fk_billing_reseller;
DROP INDEX IF EXISTS public.effective_date;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.user_permissions DROP CONSTRAINT IF EXISTS user_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.leave_entitlements DROP CONSTRAINT IF EXISTS uq_leave_entitlements;
ALTER TABLE IF EXISTS ONLY public.monthly_bills DROP CONSTRAINT IF EXISTS uk_reseller_month;
ALTER TABLE IF EXISTS ONLY public.sidebar_menus DROP CONSTRAINT IF EXISTS sidebar_menus_pkey;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS roles_pkey;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS roles_name_key;
ALTER TABLE IF EXISTS ONLY public.resellers DROP CONSTRAINT IF EXISTS resellers_pkey;
ALTER TABLE IF EXISTS ONLY public.reseller_rate_history DROP CONSTRAINT IF EXISTS reseller_rate_history_pkey;
ALTER TABLE IF EXISTS ONLY public.rate_change_requests DROP CONSTRAINT IF EXISTS rate_change_requests_pkey;
ALTER TABLE IF EXISTS ONLY public.purchase_orders DROP CONSTRAINT IF EXISTS purchase_orders_pkey;
ALTER TABLE IF EXISTS ONLY public.po_items DROP CONSTRAINT IF EXISTS po_items_pkey;
ALTER TABLE IF EXISTS ONLY public.office_phones DROP CONSTRAINT IF EXISTS office_phones_pkey;
ALTER TABLE IF EXISTS ONLY public.monthly_bills DROP CONSTRAINT IF EXISTS monthly_bills_pkey;
ALTER TABLE IF EXISTS ONLY public.leave_types DROP CONSTRAINT IF EXISTS leave_types_pkey;
ALTER TABLE IF EXISTS ONLY public.leave_requests DROP CONSTRAINT IF EXISTS leave_requests_pkey;
ALTER TABLE IF EXISTS ONLY public.leave_request_items DROP CONSTRAINT IF EXISTS leave_request_items_pkey;
ALTER TABLE IF EXISTS ONLY public.leave_entitlements DROP CONSTRAINT IF EXISTS leave_entitlements_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS employee_id;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS email;
ALTER TABLE IF EXISTS ONLY public.departments DROP CONSTRAINT IF EXISTS departments_pkey;
ALTER TABLE IF EXISTS ONLY public.billing_logs DROP CONSTRAINT IF EXISTS billing_logs_pkey;
ALTER TABLE IF EXISTS ONLY public.bandwidth_requests DROP CONSTRAINT IF EXISTS bandwidth_requests_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.sidebar_menus ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.roles ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.resellers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.reseller_rate_history ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.rate_change_requests ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.purchase_orders ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.po_items ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.office_phones ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.monthly_bills ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.leave_types ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.leave_requests ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.leave_request_items ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.leave_entitlements ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.departments ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.billing_logs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.bandwidth_requests ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.user_permissions;
DROP SEQUENCE IF EXISTS public.sidebar_menus_id_seq;
DROP TABLE IF EXISTS public.sidebar_menus;
DROP SEQUENCE IF EXISTS public.roles_id_seq;
DROP TABLE IF EXISTS public.roles;
DROP SEQUENCE IF EXISTS public.resellers_id_seq;
DROP TABLE IF EXISTS public.resellers;
DROP SEQUENCE IF EXISTS public.reseller_rate_history_id_seq;
DROP TABLE IF EXISTS public.reseller_rate_history;
DROP SEQUENCE IF EXISTS public.rate_change_requests_id_seq;
DROP TABLE IF EXISTS public.rate_change_requests;
DROP SEQUENCE IF EXISTS public.purchase_orders_id_seq;
DROP TABLE IF EXISTS public.purchase_orders;
DROP SEQUENCE IF EXISTS public.po_items_id_seq;
DROP TABLE IF EXISTS public.po_items;
DROP SEQUENCE IF EXISTS public.office_phones_id_seq;
DROP TABLE IF EXISTS public.office_phones;
DROP SEQUENCE IF EXISTS public.monthly_bills_id_seq;
DROP TABLE IF EXISTS public.monthly_bills;
DROP SEQUENCE IF EXISTS public.leave_types_id_seq;
DROP TABLE IF EXISTS public.leave_types;
DROP SEQUENCE IF EXISTS public.leave_requests_id_seq;
DROP TABLE IF EXISTS public.leave_requests;
DROP SEQUENCE IF EXISTS public.leave_request_items_id_seq;
DROP TABLE IF EXISTS public.leave_request_items;
DROP SEQUENCE IF EXISTS public.leave_entitlements_id_seq;
DROP TABLE IF EXISTS public.leave_entitlements;
DROP SEQUENCE IF EXISTS public.departments_id_seq;
DROP TABLE IF EXISTS public.departments;
DROP SEQUENCE IF EXISTS public.billing_logs_id_seq;
DROP TABLE IF EXISTS public.billing_logs;
DROP SEQUENCE IF EXISTS public.bandwidth_requests_id_seq;
DROP TABLE IF EXISTS public.bandwidth_requests;
DROP FUNCTION IF EXISTS public.update_updated_at_column();
DROP FUNCTION IF EXISTS public.set_timestamp_leave_entitlements();
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: set_timestamp_leave_entitlements(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_timestamp_leave_entitlements() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bandwidth_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bandwidth_requests (
    id integer NOT NULL,
    reseller_id integer NOT NULL,
    bw_type text,
    change_type text NOT NULL,
    amount integer NOT NULL,
    requested_effective_date date,
    reseller_note text,
    requested_by integer,
    admin_status text DEFAULT 'pending'::text,
    engineer_status text DEFAULT 'pending'::text,
    admin_note text,
    tech_note text,
    implementation_date timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: bandwidth_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bandwidth_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bandwidth_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bandwidth_requests_id_seq OWNED BY public.bandwidth_requests.id;


--
-- Name: billing_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.billing_logs (
    id integer NOT NULL,
    reseller_id integer NOT NULL,
    request_id integer,
    change_desc text,
    transaction_amount numeric(15,2) DEFAULT 0.00,
    effective_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: billing_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.billing_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: billing_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.billing_logs_id_seq OWNED BY public.billing_logs.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    dept_name character varying(100) NOT NULL
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: leave_entitlements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leave_entitlements (
    id integer NOT NULL,
    user_id integer NOT NULL,
    leave_type_id integer NOT NULL,
    year integer NOT NULL,
    total_days numeric(8,2) DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: leave_entitlements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leave_entitlements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leave_entitlements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leave_entitlements_id_seq OWNED BY public.leave_entitlements.id;


--
-- Name: leave_request_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leave_request_items (
    id integer NOT NULL,
    request_id integer NOT NULL,
    leave_type_id integer NOT NULL,
    start_date_item date,
    end_date_item date,
    days_count numeric(4,1) DEFAULT 1.0 NOT NULL
);


--
-- Name: leave_request_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leave_request_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leave_request_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leave_request_items_id_seq OWNED BY public.leave_request_items.id;


--
-- Name: leave_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leave_requests (
    id integer NOT NULL,
    user_id integer,
    group_id character varying(50) DEFAULT NULL::character varying,
    leave_type_id integer DEFAULT 1,
    start_date date,
    end_date date,
    reason text,
    status text DEFAULT 'Pending'::text,
    admin_remark text,
    action_by_id integer,
    rejection_note text,
    applied_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    approved_by integer,
    action_at timestamp without time zone,
    half_day_period text
);


--
-- Name: leave_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leave_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leave_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leave_requests_id_seq OWNED BY public.leave_requests.id;


--
-- Name: leave_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leave_types (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


--
-- Name: leave_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leave_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leave_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leave_types_id_seq OWNED BY public.leave_types.id;


--
-- Name: monthly_bills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monthly_bills (
    id integer NOT NULL,
    reseller_id integer NOT NULL,
    bill_month date NOT NULL,
    amount numeric(15,2) DEFAULT 0.00 NOT NULL,
    adjustment numeric(15,2) DEFAULT 0.00,
    adjustment_note character varying(255) DEFAULT NULL::character varying,
    bill_details text,
    previous_due numeric(15,2) DEFAULT 0.00 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: monthly_bills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.monthly_bills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monthly_bills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.monthly_bills_id_seq OWNED BY public.monthly_bills.id;


--
-- Name: office_phones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.office_phones (
    id integer NOT NULL,
    desk_name character varying(100) DEFAULT NULL::character varying,
    assign_to character varying(100) DEFAULT NULL::character varying,
    extension character varying(50) DEFAULT NULL::character varying,
    phone_number character varying(50) DEFAULT NULL::character varying,
    device_model character varying(100) DEFAULT NULL::character varying,
    ip_address character varying(50) DEFAULT NULL::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: office_phones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.office_phones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: office_phones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.office_phones_id_seq OWNED BY public.office_phones.id;


--
-- Name: po_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.po_items (
    id integer NOT NULL,
    po_id integer NOT NULL,
    item_description text NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(15,2) NOT NULL,
    total numeric(15,2) NOT NULL
);


--
-- Name: po_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.po_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: po_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.po_items_id_seq OWNED BY public.po_items.id;


--
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_orders (
    id integer NOT NULL,
    po_number character varying(50) NOT NULL,
    vendor_name character varying(255) NOT NULL,
    vendor_address text,
    po_date date NOT NULL,
    total_amount numeric(15,2) DEFAULT 0.00 NOT NULL,
    status text DEFAULT 'Pending'::text,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: purchase_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.purchase_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: purchase_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.purchase_orders_id_seq OWNED BY public.purchase_orders.id;


--
-- Name: rate_change_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rate_change_requests (
    id integer NOT NULL,
    reseller_id integer NOT NULL,
    proposed_by integer NOT NULL,
    bw_type character varying(20) NOT NULL,
    old_rate numeric(10,2) NOT NULL,
    new_rate numeric(10,2) NOT NULL,
    effective_date date NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    approved_by integer,
    approved_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: rate_change_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rate_change_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rate_change_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rate_change_requests_id_seq OWNED BY public.rate_change_requests.id;


--
-- Name: reseller_rate_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reseller_rate_history (
    id integer NOT NULL,
    reseller_id integer NOT NULL,
    bw_type character varying(20) NOT NULL,
    rate numeric(10,2) NOT NULL,
    effective_date date NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: reseller_rate_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reseller_rate_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reseller_rate_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reseller_rate_history_id_seq OWNED BY public.reseller_rate_history.id;


--
-- Name: resellers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resellers (
    id integer NOT NULL,
    user_id character varying(50) DEFAULT NULL::character varying,
    reseller_name character varying(100) NOT NULL,
    company_name character varying(150) DEFAULT NULL::character varying,
    pop_location character varying(100) DEFAULT NULL::character varying,
    latitude character varying(50) DEFAULT NULL::character varying,
    longitude character varying(50) DEFAULT NULL::character varying,
    contact_no character varying(20) DEFAULT NULL::character varying,
    password character varying(255) NOT NULL,
    credit_limit numeric(10,2) DEFAULT 0.00,
    security_deposit numeric(15,2) DEFAULT 0.00 NOT NULL,
    previous_month_due numeric(15,2) DEFAULT 0.00 NOT NULL,
    status text DEFAULT 'active'::text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    iig_bw integer DEFAULT 0,
    bdix_bw integer DEFAULT 0,
    ggc_bw integer DEFAULT 0,
    fna_bw integer DEFAULT 0,
    cdn_bw integer DEFAULT 0,
    bcdn_bw integer DEFAULT 0,
    nttn_capacity integer DEFAULT 0,
    nttn_type character varying(50) DEFAULT NULL::character varying,
    nttn_link character varying(255) DEFAULT NULL::character varying,
    connection_type character varying(50) DEFAULT NULL::character varying,
    accumulated_bill numeric(15,2) DEFAULT 0.00,
    last_activity_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    next_pay_date date,
    rate_iig numeric(10,2) DEFAULT 0.00,
    rate_bdix numeric(10,2) DEFAULT 0.00,
    rate_ggc numeric(10,2) DEFAULT 0.00,
    rate_fna numeric(10,2) DEFAULT 0.00,
    rate_cdn numeric(10,2) DEFAULT 0.00,
    rate_bcdn numeric(10,2) DEFAULT 0.00,
    rate_nttn numeric(10,2) DEFAULT 0.00,
    current_projected_bill numeric(15,2) DEFAULT 0.00,
    total_paid_this_month numeric(15,2) DEFAULT 0.00,
    profile_image character varying(255) DEFAULT NULL::character varying
);


--
-- Name: resellers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resellers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resellers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resellers_id_seq OWNED BY public.resellers.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    permissions jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: sidebar_menus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sidebar_menus (
    id integer NOT NULL,
    parent_id integer,
    menu_name character varying(100) NOT NULL,
    link character varying(255) NOT NULL,
    icon character varying(50) DEFAULT 'fa-circle'::character varying,
    permission_column character varying(50) NOT NULL,
    category character varying(50) NOT NULL,
    sort_order integer DEFAULT 0,
    is_visible smallint DEFAULT 1 NOT NULL
);


--
-- Name: sidebar_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sidebar_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sidebar_menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sidebar_menus_id_seq OWNED BY public.sidebar_menus.id;


--
-- Name: user_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_permissions (
    user_id integer NOT NULL,
    permission_key character varying(64) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    employee_id character varying(50) NOT NULL,
    full_name character varying(100) NOT NULL,
    designation character varying(100) DEFAULT NULL::character varying,
    email character varying(191) DEFAULT NULL::character varying,
    password character varying(255) NOT NULL,
    role text DEFAULT 'Staff'::text,
    can_take_action smallint DEFAULT 0,
    department character varying(50) DEFAULT 'General'::character varying,
    status text DEFAULT 'Active'::text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    phone character varying(20) DEFAULT NULL::character varying,
    emergency_phone character varying(20) DEFAULT NULL::character varying,
    nid_number character varying(30) DEFAULT NULL::character varying,
    nid_pic character varying(255) DEFAULT NULL::character varying,
    blood_group character varying(10) DEFAULT NULL::character varying,
    present_address text,
    permanent_address text,
    joining_date date,
    profile_pic character varying(255) DEFAULT 'default.png'::character varying,
    weekly_off character varying(20) DEFAULT 'Friday'::character varying,
    allowed_leave_types character varying(255) DEFAULT '1,2,3,4'::character varying,
    digital_seal character varying(255) DEFAULT NULL::character varying,
    can_approve_bw smallint DEFAULT 0,
    can_tech_task smallint DEFAULT 0,
    can_view_billing smallint DEFAULT 0,
    can_manage_users smallint DEFAULT 0,
    p_reseller_list smallint DEFAULT 0,
    p_approve_request smallint DEFAULT 0,
    p_tech_task smallint DEFAULT 0,
    p_billing_logs smallint DEFAULT 0,
    p_manage_users smallint DEFAULT 0,
    p_manage_leaves smallint DEFAULT 0,
    p_reports smallint DEFAULT 0,
    p_apply_leave smallint DEFAULT 0,
    p_my_leaves smallint,
    p_manage_procurement smallint DEFAULT 0,
    role_id integer
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
-- Name: bandwidth_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bandwidth_requests ALTER COLUMN id SET DEFAULT nextval('public.bandwidth_requests_id_seq'::regclass);


--
-- Name: billing_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_logs ALTER COLUMN id SET DEFAULT nextval('public.billing_logs_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: leave_entitlements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_entitlements ALTER COLUMN id SET DEFAULT nextval('public.leave_entitlements_id_seq'::regclass);


--
-- Name: leave_request_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_request_items ALTER COLUMN id SET DEFAULT nextval('public.leave_request_items_id_seq'::regclass);


--
-- Name: leave_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests ALTER COLUMN id SET DEFAULT nextval('public.leave_requests_id_seq'::regclass);


--
-- Name: leave_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_types ALTER COLUMN id SET DEFAULT nextval('public.leave_types_id_seq'::regclass);


--
-- Name: monthly_bills id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monthly_bills ALTER COLUMN id SET DEFAULT nextval('public.monthly_bills_id_seq'::regclass);


--
-- Name: office_phones id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.office_phones ALTER COLUMN id SET DEFAULT nextval('public.office_phones_id_seq'::regclass);


--
-- Name: po_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.po_items ALTER COLUMN id SET DEFAULT nextval('public.po_items_id_seq'::regclass);


--
-- Name: purchase_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders ALTER COLUMN id SET DEFAULT nextval('public.purchase_orders_id_seq'::regclass);


--
-- Name: rate_change_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rate_change_requests ALTER COLUMN id SET DEFAULT nextval('public.rate_change_requests_id_seq'::regclass);


--
-- Name: reseller_rate_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reseller_rate_history ALTER COLUMN id SET DEFAULT nextval('public.reseller_rate_history_id_seq'::regclass);


--
-- Name: resellers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resellers ALTER COLUMN id SET DEFAULT nextval('public.resellers_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: sidebar_menus id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sidebar_menus ALTER COLUMN id SET DEFAULT nextval('public.sidebar_menus_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: bandwidth_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bandwidth_requests (id, reseller_id, bw_type, change_type, amount, requested_effective_date, reseller_note, requested_by, admin_status, engineer_status, admin_note, tech_note, implementation_date, created_at) FROM stdin;
1	1	IIG	increase	50	\N		\N	approved	implemented	\N	Barano holo	2026-01-24 02:59:39	2026-01-24 07:57:27
2	1	GGC	increase	50	\N		\N	rejected	pending	\N	\N	\N	2026-01-25 06:01:37
3	1	GGC	increase	50	\N	As soon as possible	\N	approved	implemented	\N	Complete all task	2026-01-25 01:23:26	2026-01-25 06:05:18
4	1	IIG	decrease	10	\N	komate chai \\r\\n	\N	approved	implemented	\N	Complete all task	2026-01-25 01:23:26	2026-01-25 06:20:38
5	1	CDN	increase	60	\N	baray den	\N	approved	implemented	\N	ok	2026-01-25 01:56:56	2026-01-25 06:54:46
6	1	IIG	increase	10	\N	as soon as possible	\N	approved	implemented	\N	Complete	2026-01-25 02:07:53	2026-01-25 07:06:48
7	1	IIG	increase	50	2026-01-25	barate hobe	\N	approved	implemented	\N	hi	2026-01-25 07:55:49	2026-01-25 12:55:14
8	1	GGC	increase	10	2026-01-26	05/01/2026	\N	approved	implemented	\N	Complete	2026-01-29 13:29:40	2026-01-26 08:29:43
9	1	IIG	increase	10	2026-01-26	07/01/2026	\N	approved	implemented	\N	ok previous date	2026-01-07 16:36:40	2026-01-26 08:30:27
10	1	NTTN	increase	20	2026-01-26	07/01/2026	\N	approved	implemented	\N	Complete	2026-01-29 13:29:40	2026-01-26 08:30:27
11	4	GGC	increase	10	2026-01-26	05/01/2026	\N	approved	implemented	\N	ok	2026-01-05 17:17:34	2026-01-26 11:13:02
12	4	IIG	increase	10	2026-01-26	07/01/2026	\N	approved	implemented	\N	ok	2026-01-07 17:17:34	2026-01-26 11:13:42
13	4	NTTN	increase	20	2026-01-26	07/01/2026	\N	approved	implemented	\N	ok	2026-01-07 17:17:34	2026-01-26 11:13:42
14	4	CDN	increase	10	2026-01-26	24/01/2026	\N	approved	implemented	\N	ok	2026-01-24 17:17:34	2026-01-26 11:14:36
15	4	GGC	increase	30	2026-01-26	26/01/2026	\N	approved	implemented	\N	ok	2026-01-26 17:17:34	2026-01-26 11:15:50
16	4	FNA	increase	30	2026-01-26	26/01/2026	\N	approved	implemented	\N	ok	2026-01-26 17:17:34	2026-01-26 11:15:50
17	4	NTTN	increase	50	2026-01-26	26/01/2026	\N	approved	implemented	\N	ok	2026-01-26 17:17:34	2026-01-26 11:15:50
18	3	FNA	increase	50	2026-01-27	15/01/2026	\N	approved	implemented	\N	complete\\r\\n	2026-01-15 14:06:30	2026-01-27 08:03:09
19	3	IIG	increase	20	2026-01-27	20/01/2026	\N	approved	implemented	\N	complete\\r\\n	2026-01-20 14:06:30	2026-01-27 08:04:38
20	3	NTTN	increase	50	2026-01-27	20/01/2026	\N	approved	implemented	\N	complete\\r\\n	2026-01-20 14:06:30	2026-01-27 08:04:38
21	6	CDN	increase	40	2026-01-27	10/01/2026	\N	approved	implemented	\N	complete	2026-01-10 18:41:01	2026-01-27 12:34:30
22	8	GGC	increase	200	2026-01-02	03-01-2026	\N	approved	implemented	\N	Complete\\r\\n	2026-01-02 14:56:56	2026-01-28 08:56:11
23	8	FNA	increase	100	2026-01-02	03-01-2026	\N	approved	implemented	\N	Complete\\r\\n	2026-01-02 14:56:56	2026-01-28 08:56:11
24	1	IIG	increase	10	2026-01-29		\N	approved	implemented	\N	Complete	2026-01-29 13:29:40	2026-01-29 07:28:38
25	1	BDIX	increase	12	2026-01-29		\N	approved	implemented	\N	Complete	2026-01-29 13:29:40	2026-01-29 07:28:38
26	1	IIG	increase	20	2026-01-29		\N	approved	implemented	\N	.	2026-01-29 14:16:32	2026-01-29 08:14:50
27	1	BDIX	increase	20	2026-01-29		\N	approved	implemented	\N	.	2026-01-29 14:16:32	2026-01-29 08:14:50
28	1	GGC	increase	20	2026-01-29		\N	approved	implemented	\N	.	2026-01-29 14:16:32	2026-01-29 08:14:50
29	7	NTTN	increase	500	2026-01-29		\N	approved	implemented	\N	complete	2026-01-29 17:25:15	2026-01-29 11:23:09
30	4	GGC	increase	20	2026-01-31	31/01/2026	\N	approved	implemented	\N	ggc 190 Mbps  থেকে ২১০ mbps করা হয়েছে,  FNA  150 Mbps  থেকে ১৮০ mbps করা হয়েছে	2026-01-31 17:56:38	2026-01-31 11:45:51
31	4	FNA	increase	30	2026-01-31	31/01/2026	\N	approved	implemented	\N	ggc 190 Mbps  থেকে ২১০ mbps করা হয়েছে,  FNA  150 Mbps  থেকে ১৮০ mbps করা হয়েছে	2026-01-31 17:56:38	2026-01-31 11:45:51
32	8	IIG	increase	40	2026-01-31	31/01/2026	\N	approved	implemented	\N	গতকাল রাত্রে কমপ্লিট করে দেওয়া হয়েছে 	2026-02-01 15:05:03	2026-01-31 16:01:09
33	8	GGC	increase	100	2026-01-31	31/01/2026	\N	approved	implemented	\N	গতকাল রাত্রে কমপ্লিট করে দেওয়া হয়েছে 	2026-02-01 15:05:03	2026-01-31 16:01:09
34	8	FNA	increase	100	2026-01-31	31/01/2026	\N	approved	implemented	\N	গতকাল রাত্রে কমপ্লিট করে দেওয়া হয়েছে 	2026-02-01 15:05:03	2026-01-31 16:01:09
36	5	IIG	decrease	50	2026-02-04		\N	rejected	pending	\N	\N	\N	2026-02-03 15:39:53
37	5	NTTN	decrease	100	2026-02-04		\N	rejected	pending	\N	\N	\N	2026-02-03 15:25:14
38	4	IIG	increase	20	2026-02-07	Shojib vai k request kora hoice	\N	approved	implemented	\N	Complete	2026-02-07 17:11:08	2026-02-07 11:10:15
39	7	GGC	increase	200	2026-02-09	fna bill implemantation data 7/02/2026	\N	approved	implemented	\N	Completed	2026-02-09 18:15:58	2026-02-09 12:09:41
40	7	FNA	increase	200	2026-02-09	fna bill implemantation data 7/02/2026	\N	approved	implemented	\N	Completed	2026-02-07 18:15:58	2026-02-07 12:09:41
43	10	FNA	decrease	50	2026-02-03	03-02-2026 imple	\N	approved	implemented	\N	03-02-2026 imple	2026-02-03 17:27:26	2026-02-03 11:26:45
44	10	CDN	increase	30	2026-02-03	03-02-2026 imple	\N	approved	implemented	\N	03-02-2026 imple	2026-02-03 17:27:26	2026-02-03 11:26:45
45	3	GGC	increase	50	2026-02-10		\N	approved	implemented	\N	Nimtala | Chuadanga\\r\\n\\r\\n\\r\\nGGC B/W Upgradation : 350m to 400m ( 50m upgraded )\\r\\nCDN B/W Upgradation : 80m to 90m    ( 10m upgraded ) \\r\\n\\r\\nBilling Date : 10-02-2026 	2026-02-10 21:05:29	2026-02-10 14:06:33
46	3	CDN	increase	10	2026-02-10		\N	approved	implemented	\N	Nimtala | Chuadanga\\r\\n\\r\\n\\r\\nGGC B/W Upgradation : 350m to 400m ( 50m upgraded )\\r\\nCDN B/W Upgradation : 80m to 90m    ( 10m upgraded ) \\r\\n\\r\\nBilling Date : 10-02-2026 	2026-02-10 21:05:29	2026-02-10 14:06:33
\.


--
-- Data for Name: billing_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.billing_logs (id, reseller_id, request_id, change_desc, transaction_amount, effective_date, created_at) FROM stdin;
1	1	\N	Initial Payment: 20,000.00 Tk.	20000.00	2026-01-24 02:29:52	2026-01-24 07:29:52
2	1	1	IIG increase by 50 Mbps	0.00	2026-01-24 02:59:39	2026-01-24 07:59:39
3	1	3	GGC increase by 50 Mbps	0.00	2026-01-25 01:23:26	2026-01-25 06:23:26
4	1	4	IIG decrease by 10 Mbps	0.00	2026-01-25 01:23:26	2026-01-25 06:23:26
5	1	5	CDN increase by 60 Mbps	0.00	2026-01-25 01:56:56	2026-01-25 06:56:56
6	1	6	IIG increase by 10 Mbps	0.00	2026-01-25 02:07:53	2026-01-25 07:07:53
7	1	7	IIG increase by 50 Mbps	0.00	2026-01-25 07:55:49	2026-01-25 12:55:49
8	1	9	IIG increase by 10 Mbps	0.00	2026-01-01 16:36:40	2026-01-01 10:36:40
9	4	11	GGC increase by 10 Mbps	0.00	2026-01-26 17:17:34	2026-01-26 11:17:34
10	4	12	IIG increase by 10 Mbps	0.00	2026-01-26 17:17:34	2026-01-26 11:17:34
11	4	13	NTTN increase by 20 Mbps	0.00	2026-01-26 17:17:34	2026-01-26 11:17:34
12	4	14	CDN increase by 10 Mbps	0.00	2026-01-26 17:17:34	2026-01-26 11:17:34
13	4	15	GGC increase by 30 Mbps	0.00	2026-01-26 17:17:34	2026-01-26 11:17:34
14	4	16	FNA increase by 30 Mbps	0.00	2026-01-26 17:17:34	2026-01-26 11:17:34
15	4	17	NTTN increase by 50 Mbps	0.00	2026-01-26 17:17:34	2026-01-26 11:17:34
16	4	\N	Payment Received (Bank): 15,000.00 Tk. Note: bank	15000.00	2026-01-12 19:30:21	2026-01-26 13:30:21
17	4	\N	Payment Received (Bank): 14,000.00 Tk. Note: bank	14000.00	2026-01-22 19:30:47	2026-01-26 13:30:47
18	4	\N	Payment Received (Bank): 3,809.00 Tk. Note: bank	3809.00	2026-01-26 19:31:23	2026-01-26 13:31:23
19	3	18	FNA increase by 50 Mbps	0.00	2026-01-27 14:06:30	2026-01-27 08:06:30
20	3	19	IIG increase by 20 Mbps	0.00	2026-01-27 14:06:30	2026-01-27 08:06:30
21	3	20	NTTN increase by 50 Mbps	0.00	2026-01-27 14:06:30	2026-01-27 08:06:30
22	3	\N	Payment Received (Bank): 37,537.00 Tk. Note: 37,537 tk paid to DBBL	37537.00	2026-01-24 15:21:44	2026-01-27 09:21:44
23	5	\N	Payment Received (Bank): 43,123.00 Tk. Note: transaction id - LID01692850670, DBBL	43123.00	2026-01-26 16:59:00	2026-01-27 10:59:00
24	6	21	CDN increase by 40 Mbps	0.00	2026-01-27 18:41:01	2026-01-27 12:41:01
25	6	\N	Payment Received (Bank): 41,000.00 Tk. Note: DBBL bank payment	41000.00	2026-01-15 19:07:23	2026-01-27 13:07:23
26	6	\N	Payment Received (Bank): 13,960.00 Tk. Note: DBBL Deposit	13960.00	2026-01-25 19:15:41	2026-01-27 13:15:41
27	8	22	GGC increase by 200 Mbps	0.00	2026-01-28 14:56:56	2026-01-28 08:56:56
28	8	23	FNA increase by 100 Mbps	0.00	2026-01-28 14:56:56	2026-01-28 08:56:56
29	10	\N	Payment Received (Cash): 100,000.00 Tk. Note: Cash Paid	100000.00	2026-01-27 16:20:01	2026-01-28 10:20:01
30	9	\N	Payment Received (Cash): 70,000.00 Tk. Note: Cash Paid	70000.00	2026-01-26 16:22:32	2026-01-28 10:22:32
31	8	\N	Payment Received (Bank): 20,000.00 Tk. Note: DBBL Deposit	20000.00	2026-01-01 16:39:01	2026-01-28 10:39:01
32	8	\N	Payment Received (Bank): 50,000.00 Tk. Note: Deposit to DBBL	50000.00	2026-01-15 10:53:41	2026-01-29 04:53:41
33	8	\N	Payment Received (Bank): 40,000.00 Tk. Note: Deposit to DBBL	40000.00	2026-01-18 10:54:07	2026-01-29 04:54:07
34	8	\N	Payment Received (Bank): 20,000.00 Tk. Note: Deposit to DBBL	20000.00	2026-01-20 10:54:33	2026-01-29 04:54:33
35	8	\N	Payment Received (Bank): 70,000.00 Tk. Note: Deposit to DBBL	70000.00	2026-01-22 10:54:59	2026-01-29 04:54:59
37	8	\N	Payment Received (Bank): 75,000.00 Tk. Note: Deposit to DBBL	75000.00	2026-01-26 10:55:51	2026-01-29 04:55:51
38	8	\N	Payment Received (Bank): 60,000.00 Tk. Note: Deposit to DBBL	60000.00	2026-01-28 10:56:16	2026-01-29 04:56:16
39	8	\N	Payment Received (Bank): 76,000.00 Tk. Note: Deposit to DBBL	76000.00	2026-01-25 10:58:05	2026-01-29 04:58:05
40	7	\N	Payment Received (Bank): 200,000.00 Tk. Note: Deposit to DBBL	200000.00	2026-01-15 11:09:19	2026-01-29 05:09:19
41	7	\N	Payment Received (Bank): 119,000.00 Tk. Note: Deposit to DBBL	119000.00	2026-01-20 11:10:18	2026-01-29 05:10:18
42	1	8	GGC increase by 10 Mbps	0.00	2026-01-29 13:29:40	2026-01-29 07:29:40
43	1	10	NTTN increase by 20 Mbps	0.00	2026-01-29 13:29:40	2026-01-29 07:29:40
44	1	24	IIG increase by 10 Mbps	0.00	2026-01-29 13:29:40	2026-01-29 07:29:40
45	1	25	BDIX increase by 12 Mbps	0.00	2026-01-29 13:29:40	2026-01-29 07:29:40
46	1	26	IIG increase by 20 Mbps	0.00	2026-01-29 14:16:32	2026-01-29 08:16:32
47	1	27	BDIX increase by 20 Mbps	0.00	2026-01-29 14:16:32	2026-01-29 08:16:32
48	1	28	GGC increase by 20 Mbps	0.00	2026-01-29 14:16:32	2026-01-29 08:16:32
49	7	\N	Payment Received (Bank): 100,000.00 Tk. Note: Deposit to DBBL	100000.00	2026-01-21 17:16:04	2026-01-29 11:16:04
50	7	\N	Payment Received (Cash): 4,000.00 Tk. Note: Deposit to DBBL	4000.00	2026-01-28 17:17:01	2026-01-29 11:17:01
51	7	29	NTTN increase by 500 Mbps	0.00	2026-01-29 17:25:15	2026-01-29 11:25:15
52	11	\N	Payment Received (Bank): 60,000.00 Tk.	60000.00	2026-01-29 18:27:57	2026-01-29 12:27:57
53	8	\N	Payment Received (Bank): 45,000.00 Tk.	45000.00	2026-01-29 18:29:04	2026-01-29 12:29:04
54	8	\N	Payment Received (Bank): 20,000.00 Tk.	20000.00	2026-01-31 11:05:25	2026-01-31 05:05:25
55	9	\N	Payment Received (Cash): 15,000.00 Tk.	15000.00	2026-01-31 11:06:14	2026-01-31 05:06:14
56	4	30	GGC increase by 20 Mbps	0.00	2026-01-31 17:56:38	2026-01-31 11:56:38
57	4	31	FNA increase by 30 Mbps	0.00	2026-01-31 17:56:38	2026-01-31 11:56:38
58	7	\N	Payment Received (Cash): 2,000.00 Tk.	2000.00	2026-01-31 18:39:17	2026-01-31 12:39:17
59	11	\N	Payment Received (Cash): 3,100.00 Tk.	3100.00	2026-01-31 18:55:39	2026-01-31 12:55:39
60	8	\N	Payment Received (Bank): 5,000.00 Tk.	5000.00	2026-01-31 19:48:47	2026-01-31 13:48:47
61	12	\N	Payment Received (Bank): 5,000.00 Tk. Note: nrb bank	5000.00	2026-01-12 11:26:00	2026-02-01 05:26:00
62	12	\N	Payment Received (Bank): 5,000.00 Tk. Note: nrb bank	5000.00	2026-01-25 11:27:22	2026-02-01 05:27:22
63	12	\N	Payment Received (Bank): 2,000.00 Tk. Note: nrb bank	2000.00	2026-01-25 11:27:42	2026-02-01 05:27:42
64	8	32	IIG increase by 40 Mbps	0.00	2026-02-01 15:05:03	2026-02-01 09:05:03
65	8	33	GGC increase by 100 Mbps	0.00	2026-02-01 15:05:03	2026-02-01 09:05:03
66	8	34	FNA increase by 100 Mbps	0.00	2026-02-01 15:05:03	2026-02-01 09:05:03
67	4	38	IIG increase by 20 Mbps	0.00	2026-02-07 17:11:08	2026-02-07 11:11:08
68	7	39	GGC increase by 200 Mbps	0.00	2026-02-09 18:15:58	2026-02-09 12:15:58
69	7	40	FNA increase by 200 Mbps	0.00	2026-02-09 18:15:58	2026-02-09 12:15:58
70	10	43	FNA decrease by 50 Mbps	0.00	2026-02-10 17:27:26	2026-02-10 11:27:26
71	10	44	CDN increase by 30 Mbps	0.00	2026-02-10 17:27:26	2026-02-10 11:27:26
72	3	45	GGC increase by 50 Mbps	0.00	2026-02-10 21:05:29	2026-02-10 15:05:29
73	3	46	CDN increase by 10 Mbps	0.00	2026-02-10 21:05:29	2026-02-10 15:05:29
74	8	\N	Payment Received (Bank): 50,000.00 Tk. Note: 1st Payment,DBBL	50000.00	2026-02-16 15:36:20	2026-02-16 09:36:20
75	5	\N	Payment Received (Bank): 100,000.00 Tk.	100000.00	2026-02-16 15:52:12	2026-02-16 09:52:12
76	7	\N	Payment Received (Bank): 200,000.00 Tk.	200000.00	2026-02-16 17:45:26	2026-02-16 11:45:26
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.departments (id, dept_name) FROM stdin;
1	Network Operation
2	Technology
3	Business Development
4	Finance
5	Admin
\.


--
-- Data for Name: leave_entitlements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.leave_entitlements (id, user_id, leave_type_id, year, total_days, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: leave_request_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.leave_request_items (id, request_id, leave_type_id, start_date_item, end_date_item, days_count) FROM stdin;
\.


--
-- Data for Name: leave_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.leave_requests (id, user_id, group_id, leave_type_id, start_date, end_date, reason, status, admin_remark, action_by_id, rejection_note, applied_at, approved_by, action_at, half_day_period) FROM stdin;
30	57	\N	1	2026-01-03	2026-01-03	ami amar khalato bhai er biye te attend korbo 3 tarikh, office e abar 4 tarikh theke join korbo	Approved	\N	\N	\N	2025-12-31 14:29:49	58	2026-01-01 08:38:57	\N
34	19	\N	1	2026-01-03	2026-01-03	Family Issue	Approved	\N	\N	\N	2026-01-01 08:36:21	59	2026-01-01 04:11:31	\N
36	19	\N	3	2026-01-01	2026-01-01	Family issue	Approved	\N	\N	\N	2026-01-01 08:58:07	58	2026-01-01 04:06:31	Evening
37	9	\N	1	2026-01-01	2026-01-01	Family Issu	Approved	\N	\N	\N	2026-01-01 13:43:28	58	2026-01-01 08:43:44	\N
38	38	\N	1	2026-01-01	2026-01-01	Family Issue	Approved	\N	\N	\N	2026-01-01 13:47:33	58	2026-01-01 08:47:47	\N
40	11	\N	1	2026-01-03	2026-01-03	Ami bises karone Gopalgonj asi,ami khulnay aste pari nai tai office e jete parchi na,tai amar chuti ti doya kore approve korben	Approved	\N	\N	\N	2026-01-03 04:32:37	59	2026-01-02 23:35:20	\N
46	16	\N	1	2026-01-01	2026-01-01	জ্বর হয়েছিল	Approved	\N	\N	\N	2026-01-03 13:17:54	59	2026-01-03 08:22:24	\N
47	21	\N	1	2026-01-03	2026-01-03	আমার ফ্যামিলিতে একটা গুরুতর সমস্যার কারণে আমি দুই দিন অফিসে আসতে পারবো না যেটা আমি শুক্রবার রাতে রাফাত ভাইকে ফোনে জানিয়েছি	Approved	\N	\N	\N	2026-01-03 15:51:56	59	2026-01-03 11:19:50	\N
48	21	\N	4	2026-01-04	2026-01-04	আমার ফ্যামিলিতে গুরুতর সমস্যার কারণে আমি 03.01.2026.04.01.2026 তারিখে আসতে পারবো না। আমার যে সমস্যা শুক্রবার রাতে আমি রাফাত ভাইকে ফোনে জানিয়েছি	Approved	\N	\N	\N	2026-01-03 16:13:28	59	2026-01-03 11:19:44	\N
49	15	\N	1	2026-01-04	2026-01-04	Sickness	Rejected	\N	\N	\N	2026-01-04 03:05:44	59	2026-01-04 01:51:19	\N
50	63	\N	1	2026-01-04	2026-01-04	অতিরিক্ত অসুস্থতার জন্য	Approved	\N	\N	\N	2026-01-04 04:58:49	58	2026-01-04 03:54:18	\N
51	52	\N	1	2026-01-05	2026-01-05	Family Issue	Approved	\N	\N	\N	2026-01-04 18:19:18	59	2026-01-04 20:20:06	\N
52	63	\N	4	2026-01-05	2026-01-05	অসুস্থতার জন্য	Approved	\N	\N	\N	2026-01-05 03:31:30	58	2026-01-05 00:09:17	\N
53	6	\N	3	2026-01-05	2026-01-05	Family program	Rejected	\N	\N	\N	2026-01-05 03:45:34	59	2026-01-04 22:54:07	Evening
60	69	\N	3	2026-01-06	2026-01-06	কোমোড়ে চোট লাগছে। হাটা চলা নারা চারায় অনেক কষ্ট হচ্ছে।	Approved	\N	\N	\N	2026-01-06 07:20:02	59	2026-01-06 02:22:21	Evening
61	23	\N	1	2026-01-15	2026-01-15	MedicalIssue	Rejected	\N	\N	\N	2026-01-06 09:54:13	59	2026-01-06 04:59:36	\N
62	69	\N	1	2026-01-07	2026-01-07	Majay chot peyechi. hatachola k/uthtey boshtey problem	Approved	\N	\N	\N	2026-01-06 13:22:49	59	2026-01-06 08:24:05	\N
63	28	\N	1	2026-01-07	2026-01-07	Family problem	Approved	\N	\N	\N	2026-01-07 02:59:46	59	2026-01-06 22:03:03	\N
64	41	\N	1	2026-01-10	2026-01-10	ফ্যামিলি  প্রবলেম	Approved	\N	\N	\N	2026-01-07 03:49:55	59	2026-01-07 08:17:29	\N
65	6	\N	3	2026-01-07	2026-01-07	পারিবারিক অনুষ্ঠান।	Approved	\N	\N	\N	2026-01-07 07:07:42	59	2026-01-07 02:08:37	Evening
66	27	\N	3	2026-01-07	2026-01-07	Family Programe	Approved	\N	\N	\N	2026-01-07 09:29:52	59	2026-01-07 04:40:24	Evening
67	69	\N	4	2026-01-08	2026-01-08	Sick .	Approved	\N	\N	\N	2026-01-07 13:07:15	59	2026-01-07 08:13:12	\N
68	13	\N	1	2026-01-08	2026-01-08	আজ ৭ই জানুয়ারি আনুমানিক রাত ১১টার দিকে আমার ছোট বোনের শ্বাশুড়ি মারা গেছেন, তাই আগামীকাল ৮ তারিখ আমার ছুটি প্রয়োজন।	Approved	\N	\N	\N	2026-01-07 17:23:08	58	2026-01-07 22:54:50	\N
70	16	\N	4	2026-01-08	2026-01-08	নানা শশুর মারা গেছে	Approved	\N	\N	\N	2026-01-08 03:56:00	59	2026-01-07 22:56:48	\N
71	34	\N	3	2026-01-08	2026-01-08	Family Issue	Rejected	\N	\N	\N	2026-01-08 05:47:11	58	2026-01-09 22:57:45	Evening
72	27	\N	4	2026-01-11	2026-01-14	পারিবারিক সমস্যার করনে গ্রামে যেতে হবে	Approved	\N	\N	\N	2026-01-09 16:07:42	59	2026-01-10 03:16:23	\N
73	6	\N	4	2026-01-10	2026-01-10	পেট খারাপ	Approved	\N	\N	\N	2026-01-10 03:02:39	59	2026-01-09 22:39:26	\N
74	67	\N	3	2026-01-10	2026-01-10	personal problem	Approved	\N	\N	\N	2026-01-10 03:34:35	58	2026-01-09 22:59:13	Evening
75	49	\N	1	2026-01-10	2026-01-10	অসুস্থতার কারণে	Approved	\N	\N	\N	2026-01-10 04:08:41	59	2026-01-09 23:14:10	\N
76	61	\N	3	2026-01-10	2026-01-10	শারীরিক অসুস্থতার জন্য আধা-বেলা ছুটি দেওয়ার জন্য অনুরোধ করা হল।	Approved	\N	\N	\N	2026-01-10 04:39:01	58	2026-01-10 00:24:30	Evening
77	51	\N	1	2026-01-11	2026-01-11	বা পায়ে ব্যাথা পেয়েছি, হাটতে অনেক কষ্ট হচ্ছে !	Approved	\N	\N	\N	2026-01-10 08:40:19	58	2026-01-10 06:12:14	\N
78	42	\N	1	2026-01-15	2026-01-15	Family programme	Approved	\N	\N	\N	2026-01-10 12:56:59	59	2026-01-10 08:26:16	\N
79	33	\N	4	2026-01-11	2026-01-11	জ্বর।	Approved	\N	\N	\N	2026-01-11 02:42:00	59	2026-01-10 21:46:15	\N
80	17	\N	4	2026-01-11	2026-01-11	পারিবারিক কারনে	Approved	\N	\N	\N	2026-01-11 02:42:35	59	2026-01-10 22:59:17	\N
81	29	\N	3	2026-01-11	2026-01-11	ব্যক্তিগত কারণ	Approved	\N	\N	\N	2026-01-11 02:50:29	58	2026-01-10 23:01:36	Evening
82	15	\N	1	2026-01-11	2026-01-11	Sickness	Approved	\N	\N	\N	2026-01-11 02:57:24	59	2026-01-10 22:32:12	\N
83	10	\N	1	2026-01-11	2026-01-11	শরীর খারাপ থাকার কারণে আজকে আসতে পারবো না , জ্বর হইছে ।	Approved	\N	\N	\N	2026-01-11 03:28:49	59	2026-01-10 22:40:20	\N
84	49	\N	4	2026-01-11	2026-01-11	অসুস্থতার কারণে.	Approved	\N	\N	\N	2026-01-11 03:35:35	59	2026-01-10 22:39:57	\N
86	70	\N	3	2026-01-11	2026-01-11	Family issue	Approved	\N	\N	\N	2026-01-11 04:02:24	59	2026-01-11 01:00:18	Evening
87	6	\N	1	2026-01-11	2026-01-11	পেট খারাপ	Approved	\N	\N	\N	2026-01-11 04:11:41	59	2026-01-10 23:13:30	\N
88	35	\N	1	2026-01-12	2026-01-12	পারিবারিক প্রোগ্রাম	Approved	\N	\N	\N	2026-01-12 03:06:49	59	2026-01-11 22:12:31	\N
89	26	\N	1	2026-01-13	2026-01-13	family issue .	Approved	\N	\N	\N	2026-01-12 03:47:27	59	2026-01-12 07:47:02	\N
90	34	\N	3	2026-01-13	2026-01-13	Personal Issue	Approved	\N	\N	\N	2026-01-12 07:44:00	58	2026-01-12 06:14:58	Evening
91	48	\N	1	2026-01-13	2026-01-13	অনেক জ্বর আসায়, অফিসে আসতে পারছি না।	Approved	\N	\N	\N	2026-01-13 02:18:08	59	2026-01-12 21:21:15	\N
93	16	\N	4	2026-01-13	2026-01-13	অসুস্ত	Approved	\N	\N	\N	2026-01-13 03:23:36	59	2026-01-12 22:24:55	\N
94	18	\N	1	2026-01-15	2026-01-15	পারিবারিক সমস্যা।	Approved	\N	\N	\N	2026-01-13 04:00:11	59	2026-01-13 01:48:55	\N
95	53	\N	3	2026-01-14	2026-01-14	Family Issue	Approved	\N	\N	\N	2026-01-13 06:45:16	59	2026-01-13 01:49:30	Evening
96	53	\N	1	2026-01-15	2026-01-15	Family Issue	Approved	\N	\N	\N	2026-01-13 06:45:16	59	2026-01-13 01:49:30	\N
97	23	\N	1	2026-01-15	2026-01-15	Medical Issue	Approved	\N	\N	\N	2026-01-13 13:23:53	59	2026-01-13 09:07:58	\N
98	16	\N	4	2026-01-14	2026-01-14	অসুস্ত	Approved	\N	\N	\N	2026-01-14 01:46:12	59	2026-01-13 22:53:55	\N
99	29	\N	1	2026-01-14	2026-01-14	ববব	Rejected	\N	\N	\N	2026-01-14 02:07:42	58	2026-01-13 22:26:51	\N
100	46	\N	1	2026-01-14	2026-01-14	ব্যক্তিগত	Approved	\N	\N	\N	2026-01-14 02:07:57	58	2026-01-13 22:26:45	\N
101	11	\N	3	2026-01-14	2026-01-14	Family issue	Approved	\N	\N	\N	2026-01-14 03:27:12	59	2026-01-13 22:37:52	Morning
102	24	\N	3	2026-01-15	2026-01-15	Family Issue	Approved	\N	\N	\N	2026-01-14 06:53:27	59	2026-01-14 04:33:21	Evening
103	24	\N	1	2026-01-17	2026-01-17	Family Issue	Approved	\N	\N	\N	2026-01-14 06:55:09	59	2026-01-14 04:33:17	\N
104	21	\N	3	2026-01-15	2026-01-15	আগামীকাল দুপুরের পরে বাবাকে নিয়ে ডাক্তার দেখাতে যেতে হবে।	Approved	\N	\N	\N	2026-01-14 07:46:58	59	2026-01-14 11:00:02	Evening
105	56	\N	1	2026-01-15	2026-01-15	Khulnar bahire jabo	Rejected	\N	\N	\N	2026-01-14 08:05:04	59	2026-01-14 04:33:29	\N
106	56	\N	4	2026-01-17	2026-01-17	Khulnar bahire jabo	Rejected	\N	\N	\N	2026-01-14 08:05:04	59	2026-01-14 04:33:29	\N
107	56	\N	1	2026-01-17	2026-01-17	Khulnar bahire jabo	Approved	\N	\N	\N	2026-01-14 09:36:01	59	2026-01-14 04:36:59	\N
108	56	\N	4	2026-01-18	2026-01-18	Khulnar bahire jabo	Approved	\N	\N	\N	2026-01-14 09:36:01	59	2026-01-14 04:36:59	\N
109	20	\N	1	2026-01-15	2026-01-15	পারিবারিক সমস্যা	Approved	\N	\N	\N	2026-01-14 13:50:07	59	2026-01-14 08:51:16	\N
110	41	\N	3	2026-01-15	2026-01-15	গেরামের  বাড়িতে জাবো বিয়ে খায়তে	Rejected	\N	\N	\N	2026-01-14 14:10:54	59	2026-01-14 22:42:36	Morning
111	16	\N	4	2026-01-15	2026-01-15	অসুস্ত	Approved	\N	\N	\N	2026-01-15 01:03:38	59	2026-01-14 22:36:24	\N
112	32	\N	1	2026-01-17	2026-01-17	পারিবারিক সমসা	Approved	\N	\N	\N	2026-01-15 03:32:38	59	2026-01-14 22:36:38	\N
113	29	\N	1	2026-01-24	2026-01-24	পারিবারিক	Approved	\N	\N	\N	2026-01-15 03:53:07	58	2026-01-14 22:56:27	\N
114	40	\N	3	2026-01-15	2026-01-15	Personal	Rejected	\N	\N	\N	2026-01-15 04:41:38	58	2026-01-15 00:30:37	Evening
115	47	\N	1	2026-01-17	2026-01-17	পারিবারিক সমস্যা	Approved	\N	\N	\N	2026-01-15 07:37:50	59	2026-01-15 03:23:24	\N
116	39	\N	1	2026-01-17	2026-01-17	ফ্যামেলি প্রোগ্রাম আছে	Rejected	\N	\N	\N	2026-01-15 09:46:36	59	2026-01-15 08:22:03	\N
117	12	\N	1	2026-01-17	2026-01-17	ফ্যামিলি সমস্যা	Approved	\N	\N	\N	2026-01-15 11:03:47	59	2026-01-15 06:06:49	\N
118	62	\N	1	2026-01-17	2026-01-17	খুলনার বাইরে যাওয়া লাগবে।	Rejected	\N	\N	\N	2026-01-16 05:18:15	59	2026-01-16 11:00:27	\N
119	71	\N	1	2026-01-17	2026-01-17	আজ সন্ধ্যা পর থেকে আমার ও ছেলের বাতরুম বমি হচ্ছে ঔষধ খেয়েছি ঠিক হচ্ছে না সকালে ডাক্তারের কাছে যাবো	Approved	\N	\N	\N	2026-01-16 18:24:11	59	2026-01-16 21:12:48	\N
120	16	\N	4	2026-01-17	2026-01-17	অসুস্ত	Approved	\N	\N	\N	2026-01-17 03:03:16	59	2026-01-16 22:40:20	\N
121	7	\N	1	2026-01-17	2026-01-17	Family reunion	Approved	\N	\N	\N	2026-01-17 03:03:17	59	2026-01-17 04:15:21	\N
122	37	\N	3	2026-01-17	2026-01-17	Personal issue.	Approved	\N	\N	\N	2026-01-17 06:07:09	59	2026-01-17 01:08:21	Evening
123	18	\N	3	2026-01-17	2026-01-17	ফ্যামিলি সমস্যা।	Approved	\N	\N	\N	2026-01-17 09:29:23	59	2026-01-17 04:31:13	Evening
125	39	\N	1	2026-01-18	2026-01-18	ফ্যামিলি  প্রোগ্রাম	Approved	\N	\N	\N	2026-01-17 13:12:32	59	2026-01-17 08:21:45	\N
126	24	\N	4	2026-01-18	2026-01-18	Sick	Approved	\N	\N	\N	2026-01-17 13:59:54	59	2026-01-17 09:13:22	\N
127	11	\N	4	2026-01-18	2026-01-18	Family issue	Approved	\N	\N	\N	2026-01-18 02:37:03	59	2026-01-17 22:06:06	\N
128	19	\N	4	2026-01-18	2026-01-18	Sickness	Approved	\N	\N	\N	2026-01-18 03:09:56	59	2026-01-17 22:15:40	\N
129	64	\N	1	2026-01-18	2026-01-18	exam আছে আজকে।	Approved	\N	\N	\N	2026-01-18 03:27:49	37	2026-01-18 03:34:10	\N
130	16	\N	4	2026-01-18	2026-01-18	অসুস্ত	Approved	\N	\N	\N	2026-01-18 03:28:58	59	2026-01-17 22:50:22	\N
131	42	\N	4	2026-01-17	2026-01-17	Family Problem	Approved	\N	\N	\N	2026-01-18 03:43:21	59	2026-01-17 22:45:13	\N
132	71	\N	4	2026-01-18	2026-01-18	আমার পেট খারাপ হয়েছে অফিসে যাওয়ার মতন অবস্থা নাই	Approved	\N	\N	\N	2026-01-18 04:09:30	59	2026-01-17 23:58:46	\N
133	73	\N	4	2026-01-06	2026-01-08	Family issue.	Approved	\N	\N	\N	2026-01-18 05:31:27	59	2026-01-18 00:44:15	\N
134	73	\N	3	2026-01-18	2026-01-18	Family issue.	Approved	\N	\N	\N	2026-01-18 05:32:44	59	2026-01-18 00:44:29	Evening
135	54	\N	3	2026-01-21	2026-01-21	Family Issue	Approved	\N	\N	\N	2026-01-18 05:37:20	59	2026-01-18 00:45:15	Evening
136	54	\N	1	2026-01-22	2026-01-22	Family Issue	Approved	\N	\N	\N	2026-01-18 05:37:20	59	2026-01-18 00:45:15	\N
137	25	\N	3	2026-01-18	2026-01-18	Sick	Approved	\N	\N	\N	2026-01-18 06:05:08	59	2026-01-18 01:17:33	Morning
138	38	\N	3	2026-01-19	2026-01-19	Personal issue.	Approved	\N	\N	\N	2026-01-18 09:34:52	58	2026-01-18 05:44:20	Morning
139	14	\N	1	2026-01-19	2026-01-19	Family problem	Approved	\N	\N	\N	2026-01-18 12:07:16	59	2026-01-18 07:09:48	\N
140	29	\N	4	2026-01-19	2026-01-19	পারিবারিক সমস্যা	Approved	\N	\N	\N	2026-01-19 01:35:14	58	2026-01-18 22:13:09	\N
141	60	\N	1	2026-01-19	2026-01-19	পারিবারিক সমস্যা	Approved	\N	\N	\N	2026-01-19 02:15:51	59	2026-01-18 22:41:58	\N
142	31	\N	1	2026-01-19	2026-01-19	personal kajer jonno	Approved	\N	\N	\N	2026-01-19 02:23:57	59	2026-01-18 22:36:19	\N
143	16	\N	4	2026-01-19	2026-01-19	অসুস্ত	Approved	\N	\N	\N	2026-01-19 02:25:49	59	2026-01-18 22:36:10	\N
144	15	\N	4	2026-01-19	2026-01-19	Sickness	Approved	\N	\N	\N	2026-01-19 02:36:10	59	2026-01-18 21:47:16	\N
145	13	\N	3	2026-01-19	2026-01-19	পারিবারিক কারণে হাফ ডে ছুটি প্রয়োজন।	Approved	\N	\N	\N	2026-01-19 04:40:43	58	2026-01-19 02:05:36	Evening
146	25	\N	1	2026-01-19	2026-01-19	Sick	Approved	\N	\N	\N	2026-01-19 07:17:37	59	2026-01-19 02:18:58	\N
147	62	\N	1	2026-01-24	2026-01-24	Personal Issu	Approved	\N	\N	\N	2026-01-19 07:38:00	59	2026-01-20 23:53:14	\N
148	35	\N	3	2026-01-19	2026-01-19	পারিবারিক প্রোগ্রাম	Approved	\N	\N	\N	2026-01-19 07:39:00	59	2026-01-19 02:44:48	Evening
149	16	\N	4	2026-01-20	2026-01-20	অসুস্থতার জন্য	Approved	\N	\N	\N	2026-01-20 03:09:01	59	2026-01-19 23:20:25	\N
150	49	\N	3	2026-01-20	2026-01-20	অসুস্থ টনসিল দাঁতে ব্যথার কারণে..	Approved	\N	\N	\N	2026-01-20 03:55:28	59	2026-01-19 23:20:16	Evening
151	31	\N	3	2026-01-22	2026-01-22	Family program	Approved	\N	\N	\N	2026-01-20 04:08:32	59	2026-01-20 22:35:57	Evening
152	56	\N	4	2026-01-26	2026-01-27	Family program	Approved	\N	\N	\N	2026-01-20 09:57:28	59	2026-01-20 23:51:56	\N
153	30	\N	1	2026-01-25	2026-01-25	বেক্তিগত কারণে ছুটি প্রয়োজন.	Approved	\N	\N	\N	2026-01-20 11:23:17	58	2026-01-21 03:09:58	\N
154	16	\N	4	2026-01-21	2026-01-21	অসুস্থতার	Approved	\N	\N	\N	2026-01-21 03:12:22	59	2026-01-20 22:36:00	\N
155	41	\N	3	2026-01-22	2026-01-22	পারিবারিক সমস্যা	Approved	\N	\N	\N	2026-01-21 03:27:11	59	2026-01-21 23:24:23	Morning
156	49	\N	4	2026-01-21	2026-01-21	অসুস্থতার কারণে জর	Approved	\N	\N	\N	2026-01-21 03:40:19	59	2026-01-20 22:44:12	\N
157	60	\N	4	2026-01-21	2026-01-27	আমি বিবাহ করিবো	Rejected	\N	\N	\N	2026-01-21 03:56:35	59	2026-01-21 00:52:11	\N
158	9	\N	3	2026-01-21	2026-01-21	Stomach  upset	Approved	\N	\N	\N	2026-01-21 03:59:30	58	2026-01-21 03:08:13	Morning
159	28	\N	3	2026-01-22	2026-01-22	Family problem	Approved	\N	\N	\N	2026-01-21 03:59:42	59	2026-01-20 23:43:07	Evening
160	62	\N	3	2026-01-21	2026-01-21	পেট এ সমস্যা হচ্ছে।	Approved	\N	\N	\N	2026-01-21 04:02:11	59	2026-01-20 23:43:15	Evening
161	60	\N	4	2026-01-20	2026-01-26	বিবাহ করিবো	Approved	\N	\N	\N	2026-01-21 05:53:27	59	2026-01-21 00:54:29	\N
162	49	\N	4	2026-01-22	2026-01-22	অসুস্থতার কারণে..	Approved	\N	\N	\N	2026-01-22 03:34:06	59	2026-01-21 22:37:51	\N
163	63	\N	3	2026-01-22	2026-01-22	পারিবারিক সমস্যার কারণে ছুটির প্রয়োজন	Approved	\N	\N	\N	2026-01-22 03:36:03	58	2026-01-21 23:21:32	Evening
164	15	\N	3	2026-01-22	2026-01-22	Family issu	Approved	\N	\N	\N	2026-01-22 07:03:58	59	2026-01-22 02:07:03	Evening
165	33	\N	3	2026-01-24	2026-01-24	জরুরী প্রয়জনে গ্রামে যেতে হবে।	Approved	\N	\N	\N	2026-01-22 07:20:55	59	2026-01-22 04:01:22	Evening
166	25	\N	3	2026-01-22	2026-01-22	Sick	Approved	\N	\N	\N	2026-01-22 08:59:54	59	2026-01-22 04:01:13	Evening
167	27	\N	1	2026-01-24	2026-01-24	শারীরিক অসুস্থতার জন্য	Approved	\N	\N	\N	2026-01-23 15:11:30	59	2026-01-23 21:36:58	\N
168	37	\N	1	2026-01-24	2026-01-24	Illness	Approved	\N	\N	\N	2026-01-24 01:41:05	59	2026-01-23 21:09:46	\N
169	72	\N	1	2026-01-24	2026-01-24	শারীরিক অসুস্থতার  কারণে	Approved	\N	\N	\N	2026-01-24 02:14:04	59	2026-01-23 21:17:15	\N
170	31	\N	4	2026-01-24	2026-01-24	নিজের ব্যাক্তিগত  কাজের জন্যে	Approved	\N	\N	\N	2026-01-24 02:50:30	59	2026-01-23 22:37:02	\N
171	33	\N	1	2026-01-26	2026-01-26	গ্রামে জমি মাপ হবে। এর জন্য আমাকে থাকতে হবে।	Approved	\N	\N	\N	2026-01-24 03:10:01	59	2026-01-23 22:37:10	\N
172	36	\N	1	2026-01-22	2026-01-22	Family issues	Approved	\N	\N	\N	2026-01-24 03:41:38	58	2026-01-23 22:41:55	\N
173	64	\N	4	2026-01-24	2026-01-24	পারসোনাল সমস্যা।	Approved	\N	\N	\N	2026-01-24 03:53:55	58	2026-01-24 01:45:13	\N
174	40	\N	3	2026-01-24	2026-01-24	পারিবারিক সমাস্য	Rejected	\N	\N	\N	2026-01-24 04:48:36	58	2026-01-24 03:29:22	Evening
175	16	\N	3	2026-01-24	2026-01-24	অসুস্থ	Approved	\N	\N	\N	2026-01-24 07:38:12	59	2026-01-24 04:56:00	Evening
176	10	\N	3	2026-01-25	2026-01-25	বিয়ার দাওয়াত এ জন্য	Approved	\N	\N	\N	2026-01-24 13:10:02	59	2026-01-24 08:14:44	Evening
177	32	\N	3	2026-01-25	2026-01-25	ব্যক্তিগত সমস্যা	Approved	\N	\N	\N	2026-01-24 13:10:21	59	2026-01-24 08:15:07	Evening
178	70	\N	1	2026-01-26	2026-01-26	Family Issu	Approved	\N	\N	\N	2026-01-25 04:14:59	59	2026-01-24 23:21:26	\N
179	11	\N	3	2026-01-25	2026-01-25	Sickness	Approved	\N	\N	\N	2026-01-25 05:18:38	59	2026-01-25 00:23:09	Evening
180	48	\N	3	2026-01-26	2026-01-26	ব্যাক্তিগত কারনে ছুটি লাগবে	Approved	\N	\N	\N	2026-01-26 02:04:05	59	2026-01-25 21:31:58	Morning
181	11	\N	4	2026-01-26	2026-01-26	Sickness	Approved	\N	\N	\N	2026-01-26 02:34:39	59	2026-01-25 21:41:59	\N
182	28	\N	4	2026-01-26	2026-01-26	Fever	Approved	\N	\N	\N	2026-01-26 03:54:23	59	2026-01-25 22:56:46	\N
183	13	\N	4	2026-01-28	2026-01-29	পারিবারিক অনুষ্ঠানের জন্য ছুটি প্রয়োজন।	Approved	\N	\N	\N	2026-01-26 05:40:03	58	2026-01-26 02:17:07	\N
184	15	\N	3	2026-01-26	2026-01-26	Personal issue	Approved	\N	\N	\N	2026-01-26 08:47:24	59	2026-01-26 04:13:41	Evening
185	11	\N	4	2026-01-27	2026-01-27	Sickness	Approved	\N	\N	\N	2026-01-27 02:00:29	59	2026-01-26 21:33:02	\N
186	7	\N	3	2026-01-27	2026-01-27	Family issues	Approved	\N	\N	\N	2026-01-27 03:03:33	58	2026-01-26 22:23:44	Morning
187	28	\N	4	2026-01-27	2026-01-27	Sick	Approved	\N	\N	\N	2026-01-27 03:16:04	59	2026-01-26 23:58:58	\N
188	45	\N	3	2026-01-29	2026-01-29	ব্যক্তিগত প্রয়োজনে।	Approved	\N	\N	\N	2026-01-27 06:04:08	58	2026-01-27 01:36:52	Morning
189	57	\N	3	2026-01-29	2026-01-29	আমি একটু নানা বাড়ি যাবো আম্মুর সাথে	Approved	\N	\N	\N	2026-01-27 06:05:25	58	2026-01-28 23:13:28	Evening
190	73	\N	4	2026-01-28	2026-01-29	গায় জর অনেক মাথা ব্যাথা	Rejected	\N	\N	\N	2026-01-28 03:47:52	59	2026-01-27 23:01:14	\N
191	40	\N	1	2026-01-29	2026-01-29	পারিবারিক	Approved	\N	\N	\N	2026-01-28 03:54:28	58	2026-01-28 23:11:54	\N
192	42	\N	3	2026-01-29	2026-01-29	ফ্যামিলি সমস্যা	Rejected	\N	\N	\N	2026-01-28 03:55:34	59	2026-01-28 23:36:44	Morning
193	73	\N	1	2026-01-28	2026-01-28	গায় জর অনেক মাথা ব্যাথা	Approved	\N	\N	\N	2026-01-28 04:03:36	59	2026-01-27 23:10:23	\N
194	28	\N	4	2026-01-28	2026-01-28	Sick	Approved	\N	\N	\N	2026-01-28 04:08:12	59	2026-01-27 23:10:33	\N
195	22	\N	1	2026-01-29	2026-01-29	Personal	Approved	\N	\N	\N	2026-01-28 11:36:55	37	2026-01-28 06:52:55	\N
196	25	\N	4	2026-01-29	2026-01-29	Medical Issue	Approved	\N	\N	\N	2026-01-28 12:43:01	59	2026-01-28 10:27:29	\N
197	35	\N	4	2026-01-29	2026-01-29	দাদার মৃত্যুর কারণে	Approved	\N	\N	\N	2026-01-29 02:57:42	59	2026-01-28 21:59:18	\N
198	14	\N	3	2026-01-29	2026-01-29	Family problem	Rejected	\N	\N	\N	2026-01-29 03:37:27	59	2026-01-31 00:56:36	Evening
199	28	\N	4	2026-01-29	2026-01-29	Sick	Approved	\N	\N	\N	2026-01-29 04:37:37	59	2026-01-29 00:36:13	\N
200	73	\N	4	2026-01-29	2026-01-29	গায় জর মাথা বেথা	Approved	\N	\N	\N	2026-01-29 05:06:25	59	2026-01-29 00:36:25	\N
201	58	\N	1	2026-01-29	2026-01-30	ki	Rejected	\N	\N	\N	2026-01-29 10:00:12	58	2026-01-29 05:01:12	\N
202	29	\N	4	2026-01-29	2026-01-29	Aaaaa	Rejected	\N	\N	\N	2026-01-29 10:02:05	58	2026-01-29 05:02:55	\N
203	46	\N	3	2026-01-31	2026-01-31	অসুস্থত	Approved	\N	\N	\N	2026-01-31 01:36:06	58	2026-01-31 08:08:55	Morning
204	60	\N	4	2026-01-31	2026-01-31	আমার জ্বর হয়েছে অনেক এই জন্য আসতে পারছি না	Approved	\N	\N	\N	2026-01-31 03:00:29	59	2026-01-30 23:19:16	\N
205	62	\N	4	2026-01-31	2026-01-31	সকাল থেকে শ্বাসকষ্ট হচ্ছে	Approved	\N	\N	\N	2026-01-31 03:08:25	59	2026-01-30 23:19:11	\N
206	41	\N	4	2026-01-31	2026-01-31	অসুস্থ	Approved	\N	\N	\N	2026-01-31 03:19:49	59	2026-01-30 23:16:43	\N
207	47	\N	1	2026-02-01	2026-02-01	বাসা পাল্টাবো	Approved	\N	\N	\N	2026-01-31 09:03:48	59	2026-01-31 08:41:59	\N
208	19	\N	1	2026-02-01	2026-02-01	Ayat er jor 101/102.	Approved	\N	\N	\N	2026-02-01 03:14:51	59	2026-01-31 22:52:34	\N
209	11	\N	1	2026-02-01	2026-02-01	Family issu	Approved	\N	\N	\N	2026-02-01 03:25:18	59	2026-01-31 22:52:36	\N
210	56	\N	3	2026-02-01	2026-02-01	Sickness	Approved	\N	\N	\N	2026-02-01 10:18:42	59	2026-02-01 05:19:08	Evening
211	56	\N	1	2026-02-02	2026-02-02	Sickness	Approved	\N	\N	\N	2026-02-01 10:18:42	59	2026-02-01 05:19:08	\N
212	37	\N	4	2026-01-31	2026-01-31	অসুস্থতা	Approved	\N	\N	\N	2026-02-01 10:54:52	59	2026-02-01 21:26:04	\N
213	62	\N	1	2026-02-05	2026-02-05	বন্ধুর বিয়েতে বগুরা যাব	Rejected	\N	\N	\N	2026-02-01 12:56:10	59	2026-02-01 21:27:04	\N
214	62	\N	4	2026-02-08	2026-02-08	বন্ধুর বিয়েতে বগুরা যাব	Rejected	\N	\N	\N	2026-02-01 12:56:10	59	2026-02-01 21:27:04	\N
215	19	\N	4	2026-02-02	2026-02-02	Amar meyer jor 104.	Approved	\N	\N	\N	2026-02-02 02:23:29	59	2026-02-01 21:26:12	\N
216	11	\N	4	2026-02-02	2026-02-02	Sickness	Rejected	\N	\N	\N	2026-02-02 03:10:44	59	2026-02-01 22:12:58	\N
217	62	\N	1	2026-02-05	2026-02-05	বন্ধুর বিয়েতে বগুরা যাব	Approved	\N	\N	\N	2026-02-02 10:50:41	59	2026-02-02 06:28:02	\N
218	12	\N	1	2026-02-08	2026-02-08	Family Issu	Approved	\N	\N	\N	2026-02-02 11:26:48	59	2026-02-02 06:28:47	\N
219	12	\N	4	2026-02-09	2026-02-09	Family Issu	Approved	\N	\N	\N	2026-02-02 11:26:48	59	2026-02-02 06:28:47	\N
220	71	\N	1	2026-02-03	2026-02-03	পারিবারিক সমস্যা কারণে অফিস যেতে পারবো না	Approved	\N	\N	\N	2026-02-02 12:38:55	59	2026-02-02 22:49:08	\N
221	19	\N	4	2026-02-03	2026-02-03	Daughter&#039;s sickness fever 104°	Approved	\N	\N	\N	2026-02-03 04:05:23	59	2026-02-02 23:19:50	\N
222	11	\N	4	2026-02-03	2026-02-03	Sickness	Approved	\N	\N	\N	2026-02-03 04:07:39	59	2026-02-02 23:19:56	\N
223	7	\N	3	2026-02-03	2026-02-03	family issue	Approved	\N	\N	\N	2026-02-03 12:46:27	58	2026-02-10 17:39:30	Morning
224	27	\N	1	2026-02-04	2026-02-04	Personal issue	Approved	\N	\N	\N	2026-02-03 12:58:22	59	2026-02-03 11:32:44	\N
225	26	\N	3	2026-02-04	2026-02-04	পারিবারিক সমস্যা	Approved	\N	\N	\N	2026-02-03 16:27:51	59	2026-02-03 11:35:27	Evening
226	64	\N	1	2026-02-04	2026-02-04	অসুস্থ	Approved	\N	\N	\N	2026-02-03 17:10:38	37	2026-02-04 01:10:53	\N
227	6	\N	1	2026-02-04	2026-02-04	সরিল বেথা	Approved	\N	\N	\N	2026-02-04 03:27:15	59	2026-02-03 22:55:51	\N
228	41	\N	3	2026-02-04	2026-02-04	পারাবিক সমস্যা	Rejected	\N	\N	\N	2026-02-04 03:37:15	59	2026-02-04 04:28:40	Morning
229	11	\N	4	2026-02-04	2026-02-04	Sickness	Approved	\N	\N	\N	2026-02-04 03:48:05	59	2026-02-03 22:56:07	\N
230	40	\N	3	2026-02-04	2026-02-04	বিশেষ প্রয়োজন	Approved	\N	\N	\N	2026-02-04 05:03:27	58	2026-02-04 00:30:16	Evening
231	47	\N	3	2026-02-04	2026-02-04	পারিবারিক সমস্যা	Approved	\N	\N	\N	2026-02-04 05:16:57	59	2026-02-04 00:19:04	Evening
232	34	\N	3	2026-02-04	2026-02-04	Sick	Approved	\N	\N	\N	2026-02-04 05:56:11	58	2026-02-04 00:58:51	Evening
233	7	\N	1	2026-02-04	2026-02-04	ছেলে অসুস্থ ডাক্তার এর কাছে নিয়ে গেছিলাম। গতকাল রাত থেকে ১০৩-১০৪ জর উঠা নামা করতেছিল।	Approved	\N	\N	\N	2026-02-04 08:29:40	58	2026-02-04 04:11:22	\N
234	32	\N	1	2026-02-05	2026-02-05	অসুস্থ জ্বর	Approved	\N	\N	\N	2026-02-05 02:01:21	59	2026-02-04 21:18:54	\N
235	41	\N	1	2026-02-05	2026-02-05	ফ্যামিলি প্রবলেম	Approved	\N	\N	\N	2026-02-05 03:02:26	59	2026-02-04 22:32:06	\N
236	73	\N	1	2026-02-05	2026-02-05	পারিবারিক ভাবে একটি অনুষ্ঠানে যাবার জন্য	Approved	\N	\N	\N	2026-02-05 03:44:15	59	2026-02-04 22:44:45	\N
237	31	\N	1	2026-02-05	2026-02-05	অসুস্ততা	Approved	\N	\N	\N	2026-02-05 03:57:00	59	2026-02-04 22:57:40	\N
238	24	\N	3	2026-02-07	2026-02-07	Family issue	Approved	\N	\N	\N	2026-02-06 13:47:10	59	2026-02-06 08:50:49	Morning
239	26	\N	1	2026-02-07	2026-02-07	অসুস্থ	Approved	\N	\N	\N	2026-02-06 15:32:22	59	2026-02-06 12:14:14	\N
240	39	\N	1	2026-02-08	2026-02-08	Sick	Rejected	\N	\N	\N	2026-02-07 04:00:01	59	2026-02-07 16:28:43	\N
241	37	\N	1	2026-02-08	2026-02-08	Personal	Approved	\N	\N	\N	2026-02-07 04:57:28	59	2026-02-06 23:58:38	\N
242	34	\N	1	2026-02-07	2026-02-07	Shorir Khubee osusto feel hosse	Approved	\N	\N	\N	2026-02-07 05:33:05	58	2026-02-07 11:36:22	\N
243	17	\N	3	2026-02-07	2026-02-07	পারিবারিক কারনে	Approved	\N	\N	\N	2026-02-07 07:53:22	59	2026-02-07 14:24:25	Evening
244	39	\N	1	2026-02-07	2026-02-07	Sick	Approved	\N	\N	\N	2026-02-07 10:29:41	59	2026-02-08 09:28:04	\N
245	62	\N	3	2026-02-07	2026-02-07	Emergency	Approved	\N	\N	\N	2026-02-07 13:08:11	59	2026-02-08 09:28:15	Evening
246	51	\N	1	2026-02-08	2026-02-08	জ্বর	Approved	\N	\N	\N	2026-02-07 17:52:15	58	2026-02-10 17:38:53	\N
247	11	\N	4	2026-02-08	2026-02-08	Family issu	Approved	\N	\N	\N	2026-02-08 03:26:06	59	2026-02-08 09:28:32	\N
248	21	\N	3	2026-02-08	2026-02-08	Family isu	Approved	\N	\N	\N	2026-02-08 04:14:34	59	2026-02-08 14:39:41	Morning
249	32	\N	4	2026-02-09	2026-02-09	অসুস্থ গলাব্যথা কথাবলতে পারছিনা	Approved	\N	\N	\N	2026-02-09 02:50:28	59	2026-02-09 08:54:53	\N
250	35	\N	1	2026-02-09	2026-02-09	অসুস্থতা	Approved	\N	\N	\N	2026-02-09 03:32:58	59	2026-02-09 09:37:07	\N
251	71	\N	3	2026-02-09	2026-02-09	ডাক্তার দেখাবো ডাক্তারের সিরিয়াল আজ বিকাল ৪ টায়	Rejected	\N	\N	\N	2026-02-09 03:39:27	59	2026-02-09 19:21:13	Evening
252	57	\N	3	2026-02-10	2026-02-10	ব্যক্তিগত বিশেষ প্রয়োজনে ছুটির লাগবে	Rejected	\N	\N	\N	2026-02-09 07:16:48	45	2026-02-09 14:08:25	Evening
253	57	\N	1	2026-11-02	2026-11-02	ব্যক্তিগত বিশেষ প্রয়োজনে ছুটির প্রয়োজন	Rejected	\N	\N	\N	2026-02-09 07:18:49	45	2026-02-09 14:08:45	\N
254	23	\N	3	2026-02-09	2026-02-09	হঠাৎত করে অসুস্থ  মনে হচ্ছে গায়ে জর অনুভব করছি।।মাথায় ও অনেক ব্যথা করছে।।	Approved	\N	\N	\N	2026-02-09 07:43:08	59	2026-02-09 13:52:31	Evening
255	57	\N	3	2026-02-10	2026-02-10	ব্যক্তিগত প্রয়োজনে ছুটি নিচ্ছি	Approved	\N	\N	\N	2026-02-09 10:47:55	45	2026-02-09 17:28:32	Evening
256	57	\N	1	2026-02-11	2026-02-11	ব্যক্তিগত প্রয়োজনে ছুটি নিচ্ছি	Approved	\N	\N	\N	2026-02-09 10:47:55	45	2026-02-09 17:28:32	\N
257	12	\N	4	2026-02-10	2026-02-10	Personal problem	Rejected	\N	\N	\N	2026-02-09 13:37:00	59	2026-02-10 10:18:48	\N
258	72	\N	1	2026-02-10	2026-02-10	medical perpas	Approved	\N	\N	\N	2026-02-10 01:44:51	59	2026-02-10 08:21:29	\N
259	6	\N	4	2026-02-10	2026-02-10	আমার এক নানা মারা গেছে	Approved	\N	\N	\N	2026-02-10 03:43:38	59	2026-02-10 10:18:30	\N
260	33	\N	4	2026-02-11	2026-02-11	নির্বাচনের কারণে গ্রামে যেতে হবে।	Approved	\N	\N	\N	2026-02-10 05:42:11	59	2026-02-10 14:32:59	\N
261	24	\N	1	2026-02-11	2026-02-11	Election Issue	Approved	\N	\N	\N	2026-02-10 07:30:10	59	2026-02-10 14:32:27	\N
262	34	\N	4	2026-02-11	2026-02-11	নির্বাচনের কারণে	Rejected	\N	\N	\N	2026-02-10 10:30:49	58	2026-02-10 16:54:09	\N
263	46	\N	4	2026-02-11	2026-02-11	Nirbasoner karone	Approved	\N	\N	\N	2026-02-10 10:31:35	58	2026-02-10 16:50:56	\N
264	29	\N	1	2026-02-11	2026-02-11	ব্যক্তিগত	Approved	\N	\N	\N	2026-02-10 10:50:28	58	2026-02-10 16:50:51	\N
265	63	\N	4	2026-02-11	2026-02-11	নির্বাচনের কারণে	Approved	\N	\N	\N	2026-02-10 10:54:14	58	2026-02-10 16:54:58	\N
266	56	\N	4	2026-02-11	2026-02-11	For my security issues	Approved	\N	\N	\N	2026-02-10 14:44:46	59	2026-02-10 23:50:13	\N
267	62	\N	4	2026-02-10	2026-02-10	Personal issue	Rejected	\N	\N	\N	2026-02-11 03:14:45	59	2026-02-11 13:08:53	\N
268	62	\N	4	2026-02-11	2026-02-11	Personal issue	Rejected	\N	\N	\N	2026-02-11 03:14:45	59	2026-02-11 13:08:53	\N
269	14	\N	3	2026-02-11	2026-02-11	Family problem	Approved	\N	\N	\N	2026-02-11 07:19:36	59	2026-02-11 13:29:15	Evening
270	67	\N	3	2026-02-11	2026-02-11	বাসায় ইমার্জেন্সি প্রয়োজন	Approved	\N	\N	\N	2026-02-11 09:34:54	58	2026-02-11 15:37:39	Evening
271	21	\N	1	2026-02-14	2026-02-14	ভাইয়া আমার নানী মারা যাওয়ায় আমরা পুরো পরিবার সহকারে বরিশাল যাচ্ছি। তাই আগামীকাল আসতে পারবো না।	Approved	\N	\N	\N	2026-02-13 09:42:27	59	2026-02-13 22:43:30	\N
272	63	\N	1	2026-02-14	2026-02-14	পারিবারিক সমস্যার কারণে	Approved	\N	\N	\N	2026-02-13 12:05:35	45	2026-02-13 18:21:24	\N
273	64	\N	4	2026-02-14	2026-02-14	Personal ISSU.	Approved	\N	\N	\N	2026-02-13 13:56:20	37	2026-02-14 14:25:04	\N
274	70	\N	1	2026-02-14	2026-02-14	Sickness	Approved	\N	\N	\N	2026-02-13 16:30:05	59	2026-02-13 22:40:14	\N
275	29	\N	3	2026-02-14	2026-02-14	ব্যক্তিগত	Approved	\N	\N	\N	2026-02-14 02:26:39	58	2026-02-14 14:38:53	Evening
276	31	\N	4	2026-02-14	2026-02-14	অসুস্থতা	Approved	\N	\N	\N	2026-02-14 02:43:00	59	2026-02-14 08:58:46	\N
277	7	\N	4	2026-02-14	2026-02-14	Family issues. Please	Approved	\N	\N	\N	2026-02-14 03:32:22	58	2026-02-14 14:39:06	\N
278	11	\N	3	2026-02-14	2026-02-14	family Program	Approved	\N	\N	\N	2026-02-14 04:36:29	59	2026-02-14 12:07:10	Evening
279	13	\N	1	2026-02-15	2026-02-15	পারিবারিক কারণে ২ দিনের ছুটি প্রয়োজন	Approved	\N	\N	\N	2026-02-14 05:05:40	58	2026-02-14 14:38:39	\N
280	13	\N	4	2026-02-16	2026-02-16	পারিবারিক কারণে ২ দিনের ছুটি প্রয়োজন	Approved	\N	\N	\N	2026-02-14 05:05:40	58	2026-02-14 14:38:39	\N
281	6	\N	3	2026-02-14	2026-02-14	Famaly esu	Rejected	\N	\N	\N	2026-02-14 06:09:25	59	2026-02-14 12:12:18	Evening
282	61	\N	1	2026-02-14	2026-02-14	জরুরি ব্যক্তিগত প্রয়োজন	Approved	\N	\N	\N	2026-02-14 06:12:13	45	2026-02-15 09:52:07	\N
283	6	\N	3	2026-02-14	2026-02-14	আমার ছেলে অসুস্থ হসপিটালে ভর্তি	Approved	\N	\N	\N	2026-02-14 06:15:14	59	2026-02-14 12:19:55	Evening
284	35	\N	3	2026-02-14	2026-02-14	Family program	Approved	\N	\N	\N	2026-02-14 06:48:24	59	2026-02-14 12:51:59	Evening
285	57	\N	4	2026-02-14	2026-02-14	.	Rejected	\N	\N	\N	2026-02-14 07:04:58	45	2026-02-15 09:57:07	\N
286	73	\N	4	2026-02-14	2026-02-14	গায়ে অনেক জ্বর	Approved	\N	\N	\N	2026-02-14 07:32:47	59	2026-02-14 14:08:08	\N
287	49	\N	1	2026-02-14	2026-02-14	জরুরি কাজে গ্রামে জেতে হবে	Rejected	\N	\N	\N	2026-02-14 08:11:29	59	2026-02-14 14:12:08	\N
288	49	\N	3	2026-02-14	2026-02-14	জরুরি কাজে গ্রামে জেতে হবে	Approved	\N	\N	\N	2026-02-14 08:12:38	59	2026-02-14 14:13:03	Morning
289	21	\N	4	2026-02-15	2026-02-15	ভাইয়া আমার নানি মারা যাওয়ায় আমরা পুরো পরিবার সহকারে বরিশাল আসছি। তাই আগামীকাল আসতে পারবো না।	Approved	\N	\N	\N	2026-02-14 13:20:29	59	2026-02-14 23:15:54	\N
290	26	\N	4	2026-02-15	2026-02-15	পারিবারিক সমস্যা	Approved	\N	\N	\N	2026-02-14 16:12:35	59	2026-02-14 23:15:04	\N
291	9	\N	1	2026-02-15	2026-02-15	অসুস্থতা।	Approved	\N	\N	\N	2026-02-14 18:14:01	58	2026-02-15 12:11:35	\N
292	48	\N	1	2026-02-16	2026-02-16	মেঝ বোনের বিয়ে এবং হলুদ থাকায় , ছুটি প্রয়োজন।	Approved	\N	\N	\N	2026-02-15 01:33:10	59	2026-02-15 09:43:31	\N
293	48	\N	4	2026-02-17	2026-02-17	মেঝ বোনের বিয়ে এবং হলুদ থাকায় , ছুটি প্রয়োজন।	Approved	\N	\N	\N	2026-02-15 01:33:10	59	2026-02-15 09:43:31	\N
294	42	\N	1	2026-02-15	2026-02-15	অসুস্থ	Approved	\N	\N	\N	2026-02-15 03:36:24	59	2026-02-15 09:42:58	\N
295	54	\N	1	2026-02-16	2026-02-16	Family issue	Approved	\N	\N	\N	2026-02-15 03:39:54	59	2026-02-15 09:43:09	\N
296	28	\N	3	2026-02-15	2026-02-15	পারিবারিক সমস্যা	Approved	\N	\N	\N	2026-02-15 03:41:46	59	2026-02-15 09:42:43	Evening
297	28	\N	1	2026-02-16	2026-02-16	পারিবারিক সমস্যা	Approved	\N	\N	\N	2026-02-15 03:41:46	59	2026-02-15 09:42:43	\N
298	27	\N	3	2026-02-15	2026-02-15	Festival	Approved	\N	\N	\N	2026-02-15 03:48:29	59	2026-02-15 11:25:28	Evening
299	27	\N	2	2026-02-16	2026-02-16	Festival	Approved	\N	\N	\N	2026-02-15 03:48:29	59	2026-02-15 11:25:28	\N
300	57	\N	3	2026-02-14	2026-02-14	আমি রাজশাহী থেকে ফিরেছি ১৪ তারিখ সকালে এজন্য অফিসে এসেছি ২য় ভাগে	Approved	\N	\N	\N	2026-02-15 03:57:56	45	2026-02-17 15:19:27	Morning
301	37	\N	2	2026-02-16	2026-02-16	Festival	Approved	\N	\N	\N	2026-02-15 05:15:08	59	2026-02-15 11:25:49	\N
302	38	\N	1	2026-02-17	2026-02-17	Personal.	Approved	\N	\N	\N	2026-02-15 05:17:14	58	2026-02-15 12:11:18	\N
303	37	\N	3	2026-02-15	2026-02-15	Festival.	Approved	\N	\N	\N	2026-02-15 05:38:16	59	2026-02-15 12:11:52	Morning
304	23	\N	1	2026-02-16	2026-02-16	শশুর অসুস্থ থাকার কারণে সহপরিবারে তাকে দেখতে যাবো।।	Approved	\N	\N	\N	2026-02-15 11:13:49	59	2026-02-15 17:14:53	\N
305	42	\N	4	2026-02-16	2026-02-16	অসুস্থ	Approved	\N	\N	\N	2026-02-16 03:43:20	59	2026-02-16 09:49:34	\N
306	49	\N	3	2026-02-16	2026-02-16	জরুরি প্রয়োজনে  গ্রামে যাওয়া লাগবে	Approved	\N	\N	\N	2026-02-16 07:25:57	59	2026-02-16 13:29:36	Morning
307	47	\N	3	2026-02-16	2026-02-16	অসুস্থ  পায়ে ব্যথা	Approved	\N	\N	\N	2026-02-16 09:03:29	59	2026-02-16 15:04:36	Evening
308	20	\N	1	2026-02-16	2026-02-16	পারিবারিক সমস্যা	Rejected	\N	\N	\N	2026-02-16 13:00:47	59	2026-02-16 19:03:44	\N
309	20	\N	1	2026-02-17	2026-02-17	ফ্যামিলি প্রবলেম	Approved	\N	\N	\N	2026-02-16 13:04:31	59	2026-02-16 19:16:22	\N
310	30	\N	3	2026-02-17	2026-02-17	পার্সোনাল ইস্যু	Approved	\N	\N	\N	2026-02-16 13:57:59	58	2026-02-16 19:58:29	Morning
311	47	\N	4	2026-02-17	2026-02-17	পায়ে ব্যাথা	Approved	\N	\N	\N	2026-02-17 02:49:33	59	2026-02-17 08:59:36	\N
312	35	\N	4	2026-02-17	2026-02-17	শারীরিক অসুস্থতা। (জ্বর)	Approved	\N	\N	\N	2026-02-17 03:00:52	59	2026-02-17 09:10:09	\N
313	42	\N	4	2026-02-17	2026-02-17	অসুস্থ	Approved	\N	\N	\N	2026-02-17 03:32:30	59	2026-02-17 09:38:10	\N
314	49	\N	1	2026-02-17	2026-02-17	ফ্যামিলি ইশু	Approved	\N	\N	\N	2026-02-17 03:45:15	59	2026-02-17 10:05:58	\N
315	41	\N	3	2026-02-18	2026-02-18	পারিবারিক সমস্যা	Pending	\N	\N	\N	2026-02-17 03:56:18	\N	\N	Morning
316	73	\N	4	2026-02-17	2026-02-17	অসুস্থ জ্বর মাথা বেথা শরীর ব্যথা সর্দি কাশি	Pending	\N	\N	\N	2026-02-17 04:06:11	\N	\N	\N
317	64	\N	4	2026-02-17	2026-02-17	কালকে রাত থেকে জ্বর।	Approved	\N	\N	\N	2026-02-17 11:12:57	37	2026-02-17 17:14:23	\N
318	13	\N	3	2026-02-18	2026-02-18	ব্যাক্তিগত কিছু কাজের জন্য অর্ধ বেলা ছুটি প্রয়োজন	Pending	\N	\N	\N	2026-02-17 12:33:31	\N	\N	Morning
\.


--
-- Data for Name: leave_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.leave_types (id, name) FROM stdin;
1	Holiday
2	Festival
3	Half Day
4	Unpaid
\.


--
-- Data for Name: monthly_bills; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.monthly_bills (id, reseller_id, bill_month, amount, adjustment, adjustment_note, bill_details, previous_due, created_at) FROM stdin;
2	3	2026-01-01	37537.10	-0.10	adjust descimal figure from admin	[{\\"desc\\":\\"BDIX\\",\\"bw\\":30,\\"rate\\":20,\\"days\\":17,\\"total\\":329.03225806451616,\\"date_range\\":\\"15 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":80,\\"rate\\":80,\\"days\\":17,\\"total\\":3509.6774193548385,\\"date_range\\":\\"15 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":250,\\"rate\\":28,\\"days\\":17,\\"total\\":3838.709677419355,\\"date_range\\":\\"15 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":350,\\"rate\\":27,\\"days\\":17,\\"total\\":5182.258064516129,\\"date_range\\":\\"15 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":140,\\"rate\\":195,\\"days\\":12,\\"total\\":10567.741935483871,\\"date_range\\":\\"20 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":120,\\"rate\\":195,\\"days\\":5,\\"total\\":3774.1935483870966,\\"date_range\\":\\"15 Jan - 19 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":800,\\"rate\\":24,\\"days\\":12,\\"total\\":7432.258064516129,\\"date_range\\":\\"20 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":750,\\"rate\\":24,\\"days\\":5,\\"total\\":2903.2258064516127,\\"date_range\\":\\"15 Jan - 19 Jan\\",\\"change_type\\":\\"standard\\"}]	0.00	2026-01-27 09:24:33
3	5	2026-01-01	44109.68	0.00		[{\\"desc\\":\\"BDIX\\",\\"bw\\":100,\\"rate\\":20,\\"days\\":6,\\"total\\":387.0967741935484,\\"date_range\\":\\"26 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":280,\\"rate\\":80,\\"days\\":6,\\"total\\":4335.4838709677415,\\"date_range\\":\\"26 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":1000,\\"rate\\":27,\\"days\\":6,\\"total\\":5225.806451612903,\\"date_range\\":\\"26 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":1100,\\"rate\\":25,\\"days\\":6,\\"total\\":5322.58064516129,\\"date_range\\":\\"26 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":500,\\"rate\\":190,\\"days\\":6,\\"total\\":18387.09677419355,\\"date_range\\":\\"26 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":2700,\\"rate\\":20,\\"days\\":6,\\"total\\":10451.612903225807,\\"date_range\\":\\"26 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"}]	0.00	2026-01-31 17:10:26
4	4	2026-01-01	33428.39	0.00		[{\\"desc\\":\\"BDIX\\",\\"bw\\":30,\\"rate\\":20,\\"days\\":31,\\"total\\":600,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":40,\\"rate\\":85,\\"days\\":8,\\"total\\":877.4193548387096,\\"date_range\\":\\"24 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":30,\\"rate\\":85,\\"days\\":23,\\"total\\":1891.9354838709676,\\"date_range\\":\\"01 Jan - 23 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":180,\\"rate\\":29,\\"days\\":1,\\"total\\":168.38709677419354,\\"date_range\\":\\"31 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":150,\\"rate\\":29,\\"days\\":5,\\"total\\":701.6129032258063,\\"date_range\\":\\"26 Jan - 30 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":120,\\"rate\\":29,\\"days\\":25,\\"total\\":2806.4516129032254,\\"date_range\\":\\"01 Jan - 25 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":210,\\"rate\\":28,\\"days\\":1,\\"total\\":189.6774193548387,\\"date_range\\":\\"31 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":190,\\"rate\\":28,\\"days\\":5,\\"total\\":858.0645161290322,\\"date_range\\":\\"26 Jan - 30 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":160,\\"rate\\":28,\\"days\\":21,\\"total\\":3034.838709677419,\\"date_range\\":\\"05 Jan - 25 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":150,\\"rate\\":28,\\"days\\":4,\\"total\\":541.9354838709677,\\"date_range\\":\\"01 Jan - 04 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":60,\\"rate\\":200,\\"days\\":25,\\"total\\":9677.419354838708,\\"date_range\\":\\"07 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":50,\\"rate\\":200,\\"days\\":6,\\"total\\":1935.483870967742,\\"date_range\\":\\"01 Jan - 06 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":450,\\"rate\\":25,\\"days\\":6,\\"total\\":2177.4193548387093,\\"date_range\\":\\"26 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":400,\\"rate\\":25,\\"days\\":19,\\"total\\":6129.032258064516,\\"date_range\\":\\"07 Jan - 25 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":380,\\"rate\\":25,\\"days\\":6,\\"total\\":1838.7096774193546,\\"date_range\\":\\"01 Jan - 06 Jan\\",\\"change_type\\":\\"standard\\"}]	0.00	2026-02-01 04:34:02
6	12	2026-01-01	15050.00	-1857.00	discount	[{\\"desc\\":\\"FNA\\",\\"bw\\":100,\\"rate\\":38,\\"days\\":31,\\"total\\":3800,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":75,\\"rate\\":30,\\"days\\":31,\\"total\\":2250,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":30,\\"rate\\":300,\\"days\\":31,\\"total\\":9000,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"}]	265886.00	2026-02-01 05:28:21
7	1	2026-01-01	37322.59	-322.00		[{\\"desc\\":\\"BCDN\\",\\"bw\\":100,\\"rate\\":60,\\"days\\":31,\\"total\\":6000,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"BDIX\\",\\"bw\\":132,\\"rate\\":50,\\"days\\":3,\\"total\\":638.71,\\"date_range\\":\\"29 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"BDIX\\",\\"bw\\":100,\\"rate\\":50,\\"days\\":28,\\"total\\":4516.13,\\"date_range\\":\\"01 Jan - 28 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":160,\\"rate\\":50,\\"days\\":7,\\"total\\":1806.45,\\"date_range\\":\\"25 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":100,\\"rate\\":50,\\"days\\":24,\\"total\\":3870.97,\\"date_range\\":\\"01 Jan - 24 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":100,\\"rate\\":80,\\"days\\":31,\\"total\\":8000,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":180,\\"rate\\":30,\\"days\\":3,\\"total\\":522.58,\\"date_range\\":\\"29 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":150,\\"rate\\":30,\\"days\\":4,\\"total\\":580.65,\\"date_range\\":\\"25 Jan - 28 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":100,\\"rate\\":30,\\"days\\":24,\\"total\\":2322.58,\\"date_range\\":\\"01 Jan - 24 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":240,\\"rate\\":30,\\"days\\":3,\\"total\\":696.77,\\"date_range\\":\\"29 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":210,\\"rate\\":30,\\"days\\":4,\\"total\\":812.9,\\"date_range\\":\\"25 Jan - 28 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":160,\\"rate\\":30,\\"days\\":1,\\"total\\":154.84,\\"date_range\\":\\"24 Jan - 24 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":110,\\"rate\\":30,\\"days\\":17,\\"total\\":1809.68,\\"date_range\\":\\"07 Jan - 23 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":100,\\"rate\\":30,\\"days\\":6,\\"total\\":580.65,\\"date_range\\":\\"01 Jan - 06 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":1020,\\"rate\\":5,\\"days\\":3,\\"total\\":493.55,\\"date_range\\":\\"29 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":1000,\\"rate\\":5,\\"days\\":28,\\"total\\":4516.13,\\"date_range\\":\\"01 Jan - 28 Jan\\",\\"change_type\\":\\"standard\\"}]	0.00	2026-02-01 06:53:40
8	11	2026-01-01	60200.00	0.00		[{\\"desc\\":\\"BDIX\\",\\"bw\\":30,\\"rate\\":30,\\"days\\":31,\\"total\\":900,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":70,\\"rate\\":80,\\"days\\":31,\\"total\\":5600,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":300,\\"rate\\":28,\\"days\\":31,\\"total\\":8400,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":450,\\"rate\\":27,\\"days\\":31,\\"total\\":12150,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":170,\\"rate\\":195,\\"days\\":31,\\"total\\":33150,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"}]	2900.00	2026-02-01 07:12:03
9	10	2026-01-01	102800.00	-1900.00		[{\\"desc\\":\\"BDIX\\",\\"bw\\":10,\\"rate\\":0,\\"days\\":31,\\"total\\":0,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":70,\\"rate\\":80,\\"days\\":31,\\"total\\":5600,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":750,\\"rate\\":28,\\"days\\":31,\\"total\\":21000,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":800,\\"rate\\":27,\\"days\\":31,\\"total\\":21600,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":280,\\"rate\\":195,\\"days\\":31,\\"total\\":54600,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"}]	12043.00	2026-02-01 07:15:05
10	9	2026-01-01	85015.00	-15.00		[{\\"desc\\":\\"BDIX\\",\\"bw\\":50,\\"rate\\":55,\\"days\\":31,\\"total\\":2750,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":530,\\"rate\\":30,\\"days\\":31,\\"total\\":15900,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":430,\\"rate\\":28,\\"days\\":31,\\"total\\":12040,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":265,\\"rate\\":205,\\"days\\":31,\\"total\\":54325,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"}]	10000.00	2026-02-01 07:16:48
11	8	2026-01-01	482035.49	0.00		[{\\"desc\\":\\"BDIX\\",\\"bw\\":200,\\"rate\\":30,\\"days\\":31,\\"total\\":6000,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":600,\\"rate\\":80,\\"days\\":31,\\"total\\":48000,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":3250,\\"rate\\":28,\\"days\\":30,\\"total\\":88064.52,\\"date_range\\":\\"02 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":3150,\\"rate\\":28,\\"days\\":1,\\"total\\":2845.16,\\"date_range\\":\\"01 Jan - 01 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":3300,\\"rate\\":27,\\"days\\":30,\\"total\\":86225.81,\\"date_range\\":\\"02 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":3100,\\"rate\\":27,\\"days\\":1,\\"total\\":2700,\\"date_range\\":\\"01 Jan - 01 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":1260,\\"rate\\":195,\\"days\\":31,\\"total\\":245700,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":50,\\"rate\\":50,\\"days\\":31,\\"total\\":2500,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"}]	314742.00	2026-02-01 07:30:09
12	7	2026-01-01	399829.03	0.00		[{\\"desc\\":\\"BDIX\\",\\"bw\\":50,\\"rate\\":30,\\"days\\":31,\\"total\\":1500,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":400,\\"rate\\":85,\\"days\\":31,\\"total\\":34000,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":1500,\\"rate\\":28,\\"days\\":31,\\"total\\":42000,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":2100,\\"rate\\":27,\\"days\\":31,\\"total\\":56700,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":1000,\\"rate\\":200,\\"days\\":31,\\"total\\":200000,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":5500,\\"rate\\":13,\\"days\\":3,\\"total\\":6919.35,\\"date_range\\":\\"29 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":5000,\\"rate\\":13,\\"days\\":28,\\"total\\":58709.68,\\"date_range\\":\\"01 Jan - 28 Jan\\",\\"change_type\\":\\"standard\\"}]	26500.00	2026-02-01 07:33:28
13	6	2026-01-01	53990.97	-30.00		[{\\"desc\\":\\"BDIX\\",\\"bw\\":30,\\"rate\\":20,\\"days\\":31,\\"total\\":600,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":100,\\"rate\\":80,\\"days\\":22,\\"total\\":5677.42,\\"date_range\\":\\"10 Jan - 31 Jan\\",\\"change_type\\":\\"increase\\"},{\\"desc\\":\\"CDN\\",\\"bw\\":60,\\"rate\\":80,\\"days\\":9,\\"total\\":1393.55,\\"date_range\\":\\"01 Jan - 09 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"FNA\\",\\"bw\\":220,\\"rate\\":28,\\"days\\":31,\\"total\\":6160,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"GGC\\",\\"bw\\":330,\\"rate\\":27,\\"days\\":31,\\"total\\":8910,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"IIG\\",\\"bw\\":110,\\"rate\\":195,\\"days\\":31,\\"total\\":21450,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"},{\\"desc\\":\\"NTTN\\",\\"bw\\":700,\\"rate\\":14,\\"days\\":31,\\"total\\":9800,\\"date_range\\":\\"01 Jan - 31 Jan\\",\\"change_type\\":\\"standard\\"}]	1000.00	2026-02-01 07:54:56
\.


--
-- Data for Name: office_phones; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.office_phones (id, desk_name, assign_to, extension, phone_number, device_model, ip_address, created_at) FROM stdin;
1		76		101			2026-02-07 13:38:30
2		68		102			2026-02-07 13:43:55
3		53		104			2026-02-07 13:45:55
4		59		105			2026-02-07 13:46:24
5		33		106			2026-02-07 13:46:49
6		37		107			2026-02-07 13:47:07
7		48		108			2026-02-07 13:49:53
8		19	109	109			2026-02-16 09:54:39
\.


--
-- Data for Name: po_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.po_items (id, po_id, item_description, quantity, unit_price, total) FROM stdin;
1	1	Tofaye Ramadan	4000	1.83	7320.00
\.


--
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.purchase_orders (id, po_number, vendor_name, vendor_address, po_date, total_amount, status, created_by, created_at) FROM stdin;
1	PO-2026-001	Omio Dada	Arafat Goli, 2nd Floor, Khulna.	2026-02-16	7320.00	Pending	58	2026-02-17 08:23:11
\.


--
-- Data for Name: rate_change_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rate_change_requests (id, reseller_id, proposed_by, bw_type, old_rate, new_rate, effective_date, status, approved_by, approved_at, created_at) FROM stdin;
\.


--
-- Data for Name: reseller_rate_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reseller_rate_history (id, reseller_id, bw_type, rate, effective_date, created_at) FROM stdin;
1	8	IIG	190.00	2026-02-09	2026-02-09 12:29:05
2	8	FNA	27.00	2026-02-09	2026-02-09 12:29:23
3	9	IIG	195.00	2026-02-10	2026-02-10 11:00:57
4	9	BDIX	50.00	2026-02-10	2026-02-10 11:00:57
5	9	GGC	27.00	2026-02-10	2026-02-10 11:00:57
6	9	FNA	25.00	2026-02-10	2026-02-10 11:00:57
\.


--
-- Data for Name: resellers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resellers (id, user_id, reseller_name, company_name, pop_location, latitude, longitude, contact_no, password, credit_limit, security_deposit, previous_month_due, status, created_at, iig_bw, bdix_bw, ggc_bw, fna_bw, cdn_bw, bcdn_bw, nttn_capacity, nttn_type, nttn_link, connection_type, accumulated_bill, last_activity_date, next_pay_date, rate_iig, rate_bdix, rate_ggc, rate_fna, rate_cdn, rate_bcdn, rate_nttn, current_projected_bill, total_paid_this_month, profile_image) FROM stdin;
1	test	Test Reseller	Speed Net Partner	Demo POP 4, Khulna	321320.35436	354654.365464	01711223344	1234	0.00	200000.00	17000.59	active	2026-01-01 07:29:52	240	132	180	100	160	100	1020	Longhaul	\N	L3	0.00	2026-01-29 14:16:32	\N	30.00	50.00	30.00	80.00	50.00	60.00	5.00	46300.00	0.00	\N
3	SN-CHU-LH-B9-Nim	Abu Shamah	Speed Net	Nimtola Chuadanga	23.648700	88.920200	01787438193	01787438193	0.00	0.00	0.00	active	2026-01-15 10:34:11	140	30	400	250	90	0	800	Longhaul	spnt_120126_080_nb	Speed Net	0.00	2026-02-10 21:05:29	2026-02-17	195.00	20.00	27.00	28.00	80.00	0.00	24.00	71408.92	0.00	reseller_3_1770104132.jpg
4	SN-CHU-LH-B8-Ding	Monirul Islam		Hazrahati, Taltola, Chuadanga.	23.648547	88.920280	01909460315	01909460315	0.00	20000.00	619.39	active	2026-01-01 08:20:21	80	30	210	180	40	0	450	Longhaul		Speed Net	0.00	2026-02-07 17:11:08	2026-02-17	200.00	20.00	28.00	29.00	85.00	0.00	25.00	41492.86	0.00	\N
5	SN-MEH-LH-B10-Muj	Md Hasibur Rahman	mujib nagar it & solution	Mujib Nagar,Meherpur	23.667673 	88.604533	01765874150	01765874150	0.00	25000.00	986.68	active	2026-01-26 10:43:36	500	100	1100	1000	280	0	2700	Longhaul	144846	Speed Net	0.00	2026-01-26 16:43:36	2026-02-17	190.00	20.00	25.00	27.00	80.00	0.00	20.00	227900.00	0.00	\N
6	SN-JSR-D2D-B6-Rup	Md. Abu Huraya		Sakhari Gati, Rupdia, Jessore.	23.12746	89.29125	01995576892	$2y$10$tCj54eBttY5Zmh1yrxlpHeKRduK8mhoINJE/dvYSAnW0p6KWIdema	0.00	0.00	0.97	active	2025-12-09 12:27:12	110	30	330	220	100	0	700	D2D	spnt_160925_034_nb	Speed Net	0.00	2026-01-27 18:41:01	2026-02-18	195.00	20.00	27.00	28.00	80.00	0.00	14.00	54920.00	0.00	\N
7	SN-NAR-D2D-B2-Kal	Md Arif Chowdhury		Kalia Bazar,Norile	23.0383077	89.3618836	01616767521	$2y$10$R5bNlrslMggOqd0i2URxBOmsRsqOE5sKNxbp3pmU07kiJ/wPK256O	0.00	0.00	1329.03	active	2024-10-10 08:17:44	1000	50	2300	1700	400	0	5500	D2D	spnt_081024_087_nb	Speed Net	0.00	2026-02-09 18:15:58	2026-02-16	200.00	30.00	27.00	28.00	85.00	0.00	13.00	413957.14	0.00	\N
8	SN-BAG-OHF-B1-Fok	Sheikh Rezaul Islam		Fokirhat,Bagerhat	22.771447	89.712795	01711928429	$2y$10$sdNKzPLpXCgTssPE1rpx5Oo0V45SaMJ5aQEGkYq5HzmLfj0rhEyiq	0.00	0.00	315777.49	active	2023-09-01 08:43:18	1300	200	3400	3350	600	0	50	D2D		Speed Net	0.00	2026-02-01 15:05:03	2026-02-16	190.00	30.00	27.00	27.00	80.00	0.00	50.00	485750.00	0.00	\N
9	SN-KHL-OHF-B4-Kris	Sheikh Moinul Hasan		Krishi Collage,doulotpur	22.87293976	89.51689542	01714932314	$2y$10$scB1vMHLKV1e.CC4ce4qTO6blc9NMIpzMCF7vG2ojhSh08QKT1mH6	0.00	0.00	10000.00	active	2022-08-01 09:39:08	278	55	446	636	0	0	0	D2D		Speed Net	0.00	2022-08-01 15:39:08	2026-02-22	195.00	50.00	27.00	25.00	0.00	0.00	0.00	84902.00	0.00	\N
10	SN-KHL-OHF-B3-Lab	Mostafizur Rahman  Masum		south tuthpara.Labonchora	22.793662	89.570466	01934779938	$2y$10$HtIhC5M0mrgRVA1kET2lKOfgxNuDGyUP090H1oTDCkjPrYOBAZGRy	0.00	0.00	12943.00	active	2021-12-01 09:58:16	280	10	800	700	100	0	0			Speed Net	0.00	2026-02-10 17:27:26	2026-02-25	195.00	0.00	27.00	28.00	80.00	0.00	0.00	103728.57	0.00	reseller_10_1770100480.jpg
11	SN-KHL-OHF-B7-Kaz	Md. Shumon		Kazdia, Khulna.	22.774487522871986 	89.61751985240852	01711347639	$2y$10$amy3Kqut1L9VokuCZwE9Oeyqz6Sc0B95WSa/OQWZki858XaX1fQZ.	0.00	0.00	0.00	active	2025-12-04 04:49:56	170	30	450	300	70	0	0			Speed Net	0.00	2025-12-04 10:49:56	2026-02-21	195.00	30.00	27.00	28.00	80.00	0.00	0.00	60200.00	0.00	\N
12	SN-KHL-OHF-B11-Kha	Mr. Rayhan	Entrain BD	Pouroshovar More, Khalishpur, Khulna	22.850392296518773	89.54154927418675	01750196315	$2y$10$s/rw85r4BBv8nYsHDEVhPOTAoPCgYDtawTNBCwI6Vrlz1cYb.LHtG	0.00	0.00	267079.00	active	2021-09-15 07:20:27	30	0	75	100	0	0	0			Speed Net	0.00	2021-09-15 13:20:27	2026-02-18	300.00	0.00	30.00	38.00	0.00	0.00	0.00	15050.00	0.00	\N
13	SN-THA-L3-B11-Kal	Jahirul Islam		Thakurgoan	26.07286	88.48405	01758038670	$2y$10$hD246eFzauJLIOAyNAFXXOS4YxLzI2Zw5CDaAS0L4G8zwDv.1RLVi	0.00	20000.00	0.00	active	2026-02-02 07:00:56	30	10	80	60	20	0	175	Longhaul		L3	0.00	2026-02-02 13:00:56	2026-02-17	205.00	20.00	30.00	32.00	90.00	0.00	30.00	17087.15	0.00	\N
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.roles (id, name, permissions, created_at, updated_at) FROM stdin;
2	Admin	{"p_manage_users": true, "p_manage_permissions": true}	2026-02-17 21:47:24.160189+06	2026-02-17 21:47:24.160189+06
3	Staff	{}	2026-02-17 21:47:24.160189+06	2026-02-17 21:47:24.160189+06
1	Super Admin	{"all_access": true}	2026-02-17 21:47:24.160189+06	2026-02-17 21:47:24.208618+06
\.


--
-- Data for Name: sidebar_menus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sidebar_menus (id, parent_id, menu_name, link, icon, permission_column, category, sort_order, is_visible) FROM stdin;
1	\N	রিসেলার তালিকা	reseller_mgnt/reseller_list.php	fa-house-signal	p_reseller_list	Reseller Management	5	1
3	\N	ইঞ্জিনিয়ার টাস্ক	reseller_mgnt/tasks_engineer.php	fa-microchip	p_tech_task	Reseller Management	6	1
4	\N	কর্মচারী তালিকা	employees.php	fa-users-gear	p_manage_users	Admin Area	1	1
5	\N	ছুটি অনুমোদন	manage_leaves.php	fa-calendar-check	p_manage_leaves	Admin Area	2	1
6	\N	রিপোর্ট ও এনালাইটিক্স	reports.php	fa-chart-line	p_reports	Admin Area	3	1
7	\N	রিসেলার বিলিং ও লগ	reseller_mgnt/billing_logs.php	fa-receipt	p_billing_logs	Finance	7	1
8	\N	ছুটির আবেদন	apply_leave.php	fa-paper-plane	p_apply_leave	Staff Services	8	1
9	\N	আমার ছুটি তালিকা	my_leaves.php	fa-list-check	p_my_leaves	Staff Services	9	1
10	\N	নতুন অর্ডার (PO)	procurement/create_po.php	fa-plus-circle	p_manage_procurement	Procurement	11	1
11	\N	অর্ডার তালিকা	procurement/view_pos.php	fa-file-invoice	p_manage_procurement	Procurement	13	1
12	\N	পারচেজ অর্ডার	procurement/view_pos.php	fa-cart-shopping	p_manage_procurement	Procurement	12	1
13	\N	ছুটির ক্যালেন্ডার	leave_calendar.php	fa-calendar-days	p_apply_leave	Staff Services	10	1
15	\N	মেন্যু ম্যানেজমেন্ট	manage_menus.php	fa-sitemap	p_manage_menus	System Settings	14	1
16	\N	পারমিশন কন্ট্রোল	manage_permissions.php	fa-shield-halved	p_manage_permissions	System Settings	15	1
18	\N	NOC রিসেলার স্ট্যাটাস	reseller_mgnt/reseller_status_noc.php	fa-wifi	p_noc_view	Reseller Management	4	1
\.


--
-- Data for Name: user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_permissions (user_id, permission_key) FROM stdin;
1	p_apply_leave
1	p_approve_request
1	p_billing_logs
1	p_manage_leaves
1	p_manage_procurement
1	p_manage_users
1	p_my_leaves
1	p_reports
1	p_reseller_list
1	p_tech_task
2	p_apply_leave
2	p_approve_request
2	p_manage_leaves
2	p_manage_users
2	p_my_leaves
2	p_reports
3	p_add_reseller
3	p_apply_leave
3	p_manage_leaves
3	p_manage_procurement
3	p_manage_users
3	p_my_leaves
3	p_noc_view
3	p_reports
4	p_apply_leave
4	p_my_leaves
5	p_apply_leave
5	p_my_leaves
6	p_apply_leave
6	p_my_leaves
7	p_apply_leave
7	p_my_leaves
8	p_apply_leave
8	p_my_leaves
9	p_apply_leave
9	p_my_leaves
10	p_apply_leave
10	p_my_leaves
11	p_apply_leave
11	p_my_leaves
12	p_apply_leave
12	p_my_leaves
13	p_apply_leave
13	p_my_leaves
14	p_apply_leave
14	p_my_leaves
15	p_apply_leave
15	p_my_leaves
16	p_apply_leave
16	p_my_leaves
17	p_apply_leave
17	p_my_leaves
18	p_apply_leave
18	p_my_leaves
19	p_apply_leave
19	p_my_leaves
20	p_apply_leave
20	p_my_leaves
21	p_apply_leave
21	p_my_leaves
22	p_apply_leave
22	p_my_leaves
22	p_noc_view
23	p_apply_leave
23	p_my_leaves
24	p_apply_leave
24	p_my_leaves
25	p_apply_leave
25	p_my_leaves
26	p_apply_leave
26	p_my_leaves
27	p_apply_leave
27	p_my_leaves
28	p_apply_leave
28	p_my_leaves
29	p_apply_leave
29	p_my_leaves
30	p_apply_leave
30	p_my_leaves
31	p_apply_leave
31	p_my_leaves
32	p_apply_leave
32	p_my_leaves
33	p_apply_leave
33	p_my_leaves
33	p_noc_view
34	p_apply_leave
34	p_billing_logs
34	p_my_leaves
34	p_reseller_list
35	p_apply_leave
35	p_my_leaves
36	p_apply_leave
36	p_my_leaves
37	p_apply_leave
37	p_manage_leaves
37	p_my_leaves
37	p_noc_view
37	p_reports
38	p_apply_leave
38	p_my_leaves
38	p_tech_task
39	p_apply_leave
39	p_my_leaves
40	p_apply_leave
40	p_my_leaves
41	p_apply_leave
41	p_my_leaves
42	p_apply_leave
42	p_my_leaves
43	p_apply_leave
43	p_my_leaves
44	p_apply_leave
44	p_my_leaves
45	p_apply_leave
45	p_billing_logs
45	p_manage_leaves
45	p_manage_users
45	p_my_leaves
45	p_reports
45	p_reseller_list
46	p_apply_leave
46	p_my_leaves
47	p_apply_leave
47	p_my_leaves
48	p_apply_leave
48	p_my_leaves
49	p_apply_leave
49	p_my_leaves
50	p_apply_leave
50	p_my_leaves
51	p_apply_leave
51	p_my_leaves
51	p_tech_task
52	p_apply_leave
52	p_my_leaves
53	p_apply_leave
53	p_my_leaves
53	p_noc_view
54	p_apply_leave
54	p_my_leaves
55	p_apply_leave
55	p_my_leaves
56	p_apply_leave
56	p_my_leaves
57	p_apply_leave
57	p_manage_users
57	p_my_leaves
58	p_apply_leave
58	p_approve_request
58	p_billing_logs
58	p_manage_leaves
58	p_manage_menus
58	p_manage_permissions
58	p_manage_procurement
58	p_manage_users
58	p_my_leaves
58	p_noc_view
58	p_reports
58	p_reseller_list
58	p_tech_task
59	p_apply_leave
59	p_manage_leaves
59	p_manage_users
59	p_my_leaves
59	p_noc_view
59	p_reports
60	p_apply_leave
60	p_my_leaves
61	p_apply_leave
61	p_my_leaves
62	p_apply_leave
62	p_my_leaves
63	p_apply_leave
63	p_manage_users
63	p_my_leaves
63	p_reports
64	p_apply_leave
64	p_my_leaves
64	p_noc_view
65	p_apply_leave
65	p_my_leaves
67	p_apply_leave
67	p_my_leaves
68	p_apply_leave
68	p_billing_logs
68	p_manage_leaves
68	p_manage_menus
68	p_manage_permissions
68	p_manage_procurement
68	p_manage_users
68	p_my_leaves
68	p_noc_view
68	p_reports
68	p_reseller_list
68	p_tech_task
69	p_apply_leave
69	p_my_leaves
70	p_apply_leave
70	p_my_leaves
71	p_apply_leave
71	p_my_leaves
72	p_apply_leave
72	p_my_leaves
73	p_apply_leave
73	p_my_leaves
74	p_apply_leave
74	p_billing_logs
74	p_manage_menus
74	p_reports
74	p_reseller_list
75	p_apply_leave
75	p_billing_logs
75	p_manage_leaves
75	p_manage_menus
75	p_manage_permissions
75	p_manage_procurement
75	p_manage_users
75	p_my_leaves
75	p_noc_view
75	p_reports
75	p_reseller_list
75	p_tech_task
76	p_apply_leave
76	p_billing_logs
76	p_manage_leaves
76	p_manage_menus
76	p_manage_permissions
76	p_manage_procurement
76	p_manage_users
76	p_my_leaves
76	p_noc_view
76	p_reports
76	p_reseller_list
76	p_tech_task
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, employee_id, full_name, designation, email, password, role, can_take_action, department, status, created_at, phone, emergency_phone, nid_number, nid_pic, blood_group, present_address, permanent_address, joining_date, profile_pic, weekly_off, allowed_leave_types, digital_seal, can_approve_bw, can_tech_task, can_view_billing, can_manage_users, p_reseller_list, p_approve_request, p_tech_task, p_billing_logs, p_manage_users, p_manage_leaves, p_reports, p_apply_leave, p_my_leaves, p_manage_procurement, role_id) FROM stdin;
2	SN-02	Thamma	Admin	admin@speednet.com	0000	Admin	1	HR	Active	2025-12-30 07:56:08		\N	\N	\N	\N	\N	\N	2025-12-30	SN-02_1767081368.webp	Friday	1,2,3,4	SNKHL-F2D4-Seal.png	1	1	1	1	1	1	1	1	1	1	1	1	1	1	2
1	SN-01	Speed Net Admin	\N	admin@speednetkhulna.com	1234	Super Admin	1	General	Active	2025-12-30 06:47:24	\N	\N	\N	\N	\N	\N	\N	\N	default.png	Friday	1,2,3,4	SNKHL-F2D4-Seal.png	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
76	SNKHL-4W2D	Fardous Tusher	Owner	\N	123456	Admin	1	Admin	Active	2026-01-24 10:17:04	01910365588			\N		Holding-13, Notun Bazar Approach Road, Khulna-9100	Holding-13, Notun Bazar Approach Road, Khulna-9100	2015-03-07	profile_SNKHL-4W2D_1769250031.JPG	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	0	\N	0	2
75	SNKHL-3RJ8	Foysal Alam	Owner	\N	123456	Admin	1	Finance	Active	2026-01-24 10:09:59	01910365566			\N		Boro Mirzapur, Khulna	Boro Mirzapur, Khulna	2015-07-03	profile_SNKHL-3RJ8_1769249584.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	0	\N	0	2
74	SNKHL-G6CZ	Md. Sabbir Hossain	Manager	\N	123456	Admin	1	Business Development	Active	2026-01-24 08:25:18	01970365525	01711668612	7751178167	\N	O+	115, Sheikh Para Main Road, Khulna-9100	115, Sheikh Para Main Road, Khulna-9100	2026-01-01	profile_SNKHL-G6CZ_1769249208.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	0	\N	0	2
68	SNKHL-B4KZ	Tanjil Fardous Tarin	CEO	\N	123456	Admin	1	Admin	Active	2026-01-05 05:07:41	01750557757	01913661188		\N	O+	Notun Bazar Approch Road, Khulna-9100.	Notun Bazar Approch Road, Khulna-9100.	2015-07-02	SNKHL-B4KZ_profile_1767589661.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	2
58	SNKHL-F2D4	Shaikh Azmal Hossain	Chief Operating Officer	dipu@speednetkhulna.com	Speed2123	Admin	1	Admin	Active	2026-01-01 05:54:23	01400003080	01910221155	1492615313	\N	B+	Holding-84, Hazi Foyez Uddin Road, Sonadanga, Khulna.	Holding-142, Anjuman Road North, Daulatpur, Khulna. 	2019-09-22	SNKHL-F2D4_profile_1767246863.jpg	Friday	1,2,3,4	SNKHL-F2D4-Seal.png	0	0	0	0	1	1	1	1	1	1	1	1	1	1	2
73	SNKHL-NC22	M.M. Hasibul Islam	Technician	\N	123456	Staff	0	Network Operation	Active	2026-01-17 10:16:06	01943936744	01990709812	1507183877	\N	B+	Jinnah Para, Shipyard,Khulna Sadar 9201	Jinnah Para, Shipyard,Khulna Sadar 9201	2021-09-07	SNKHL-NC22_profile_1768644966.jpeg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
72	SNKHL-64D3	MD. Abul Kalam Azad	Assistant Technician	noc@speednetkhulna.com	123456	Staff	0	Network Operation	Active	2026-01-15 07:43:05	01322313887	01911176982	7817494078	\N	B+	11/1, Bridge Road Darogar lij, Labanchora Shipyard, Khulna. 	11/1, Bridge Road Darogar lij, Labanchora Shipyard, Khulna. 	2025-11-30	SNKHL-64D3_profile_1768462985.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
71	SNKHL-2J7T	Md. Miraz Shana	Technician	\N	123456	Staff	0	Network Operation	Active	2026-01-14 07:27:37	01309371900	01764119359	8267285164	\N	A+	H/29, Belayet Hossain Sharak. Tutpara, Khulna.	H/29, Belayet Hossain Sharak. Tutpara, Khulna	2025-11-08	profile_SNKHL-2J7T_1768481141.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
70	SNKHL-WHG7	Hasib Howlader 	Senior Technician 	\N	123456	Staff	0	Network Operation	Active	2026-01-06 11:33:52	01751583592	01923939110	7362386638	\N	O+	Tatultola Jolma Botiaghata,Khulna.	Tatultola Jolma Botiaghata,Khulna.	2021-06-01	profile_SNKHL-WHG7_1768644984.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
69	SNKHL-V52B	MD.Sohel Khalifa.	Supervisor 	\N	123456	Staff	0	Network Operation	Active	2026-01-06 06:59:35	01930584726	01754363503	4623561307	\N	AB+	Tetultola Chokrakhali,Bateghata ,Khulna.	Tetultola Chokrakhali,Bateghata ,Khulna.	2018-10-04	profile_SNKHL-V52B_1768645014.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
67	SNKHL-44N5	Md. Abdullah	Supervisor	\N	130591	Staff	0	Technology	Active	2026-01-04 04:44:32	01781811717	01911176982	19915414082000034	\N		Word No-31, Darogar Lease, Labonchora, Shipyard, Khulna.	Word No-31, Darogar Lease, Labonchora, Shipyard, Khulna.	2023-12-06	SNKHL-44N5_profile_1767501872.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
65	SNKHL-F6Z2	Md. Mofazzal Hossain	Supervisor	\N	123456	Staff	0	Network Operation	Active	2026-01-03 12:06:35	01861025871	01883540536		\N	A+	83/3, Gagan Babu Road, Khulna	Jamaldi, Gojaria, Munshiganje	2015-08-15	SNKHL-F6Z2_profile_1767441995.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
64	SNKHL-KYR6	Jayanto Chowdhury Shimul	Executive	\N	123456	Staff	0	Network Operation	Active	2026-01-03 11:25:54	01975211266	01950633495	2412152064	\N		Amdabad Tilok, Rupsha, Khulna	Amdabad Tilok, Rupsha, Khulna	2024-06-20	SNKHL-KYR6_profile_1767439554.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
63	SNKHL-627G	Md. Ali Azam Sheikh	Asst.Manager	\N	123456	Staff	0	Finance	Active	2026-01-01 06:58:05	01914759020	01581320123	5558733480	\N	A+	Hafiz Nagor, Sonadanga, Khulna	Dakra, Rampal, Bagerhat	2022-06-12	SNKHL-627G_profile_1767250685.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
62	SNKHL-2P64	Nipun Chakrabarty	Executive	\N	neonxnipun	Staff	0	Network Operation	Active	2026-01-01 06:54:43	01610473584	01718466155	4662242710	\N		Munshipara 3rd lane, Khulna.	Munshipara 3rd lane, Khulna.	2025-11-25	profile_SNKHL-2P64_1769517958.jpeg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
61	SNKHL-7TBZ	Md.Sadman Sakib	Executive	\N	123456	Staff	0	Finance	Active	2026-01-01 06:51:07	01957605576	01674818180	2859919785	\N		Islamia College Road, Boyra, Khulna	Islamia College Road, Boyra, Khulna	2025-12-27	profile_SNKHL-7TBZ_1768481498.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
60	SNKHL-8D7A	Nahid Hasan Nirob	Asstant Technician	\N	123456	Staff	0	Network Operation	Active	2026-01-01 06:29:02	01967734985	01953340490		\N		Notun Bazar Approach road, Khulna-9100	Notun Bazar Approach road, Khulna-9100	2026-01-13	profile_SNKHL-8D7A_1768481353.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
59	SNKHL-8N6K	SK. Rafath Uddin	Chief Networking Officer 	\N	123456	Staff	0	Network Operation	Active	2026-01-01 05:59:42	01910365533	01686876102	4179353661	\N	B-	142/88, BK rai road, Bismilla moholla, Banyakhamar, Khulna	142/88, BK rai road, Bismilla moholla, Banyakhamar, Khulna	2022-05-21	profile_SNKHL-8N6K_1770277099.png	Friday	1,2,3,4	SNKHL-8N6K-Seal.png	0	0	0	0	0	0	0	0	1	1	1	1	1	0	3
57	SNKHL-49WU	Abu Bakkar  Siddik	Asst.Manager	info.iamabubakkar@gmail.com	123456	Staff	0	Finance	Active	2025-12-31 14:11:09	01914106656	01911579457	1032789818	\N	B+	4 No. Gagan Babu Road, Khulna	4 No. Gagan Babu Road, Khulna	2025-10-04	profile_SNKHL-49WU_1768481747.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	1	0	0	1	1	0	3
56	SNKHL-4EMJ	Abdullah Al Wasi 	Executive	\N	123456	Staff	0	Network Operation	Active	2025-12-31 12:57:50	01911281924	01410281924	2865180539	\N		16, KDA Avenue, Iqbal Nagar, Khulna.	16, KDA Avenue, Iqbal Nagar, Khulna.	2025-12-15	profile_SNKHL-4EMJ_1769602426.jpeg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
55	SNKHL-V9FE	Ishak Das	Executive	\N	123456	Staff	0	Network Operation	Active	2025-12-31 12:54:14	01635005322	01770534896	1951832367	\N		Word No-30, Holding No-30-687-084-01, South Tuth Para, Khulna.	Vill: Narkeltola, PS+PO: Faruque School-9350.Mongla, Bagerhat.	2025-12-28	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
54	SNKHL-E8N9	Kaniz Fatema	Executive	\N	123456	Staff	0	Technology	Active	2025-12-31 12:04:30	01923592223	01711139413	1467335582	\N	AB+	House No 1.Old Rayer Mohol Road,Khulna	Jhalokti Sadar,Jhalokti	2025-03-22	profile_SNKHL-E8N9_1768645039.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
53	SNKHL-536G	Bonnaya Khatun	Executive	\N	123456	Staff	0	Technology	Active	2025-12-31 12:01:49	01849629355	01734687060	4664557628	\N	O+	33,Gagan Babu Road.	33,Gagan Babu Road.	2023-07-15	profile_SNKHL-536G_1767182608.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
52	SNKHL-3K8N	Aminur Rahman	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 11:59:07	01734687060	01928553624	4681266856	\N	B+	33,Gagan Babu Road,Khulna	33,Gagan Babu Road,Khulna	2023-05-09	profile_SNKHL-3K8N_1767182812.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
51	SNKHL-3WYX	Md. Saiful Islam	System Engineer	saifullucky7@gmail.com	@@Saiful6@	Staff	0	Technology	Active	2025-12-31 11:58:59	01710484240	01724218351	1992471127100146	\N	O+	1448, Khulna University Lane, Khulna-9208	1448, Khulna University Lane, Khulna-9208	2025-10-16	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
50	SNKHL-9ZBX	MD Robiul ISlam Shine	Supervisor	\N	123456	Staff	0	Network Operation	Active	2025-12-31 11:57:14	01911194823	01929486814	3706032038	\N		61,West Bania Khamar Cross Road Khulna.	61,West Bania Khamar Cross Road Khulna.	2021-11-13	profile_SNKHL-9ZBX_1767182971.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
49	SNKHL-KF8T	Raju Gharami	SR. Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 11:54:10	01938336963	01796542864		\N	A+	83/3,Gagan Babu Road,Khulna-9000	Rampal Panikhali Bagerhat	2018-05-22	profile_SNKHL-KF8T_1767183172.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
48	SNKHL-69T3	Mst.Sanzida Akther	Executive	\N	123456	Staff	0	Technology	Active	2025-12-31 11:51:29	01330525997	01307023288	3761118037	\N	B+	Tank Road Khulna.	Tank Road Khulna.	2025-02-26	profile_SNKHL-69T3_1768645066.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
47	SNKHL-RFQ7	Md Aminul Islam Shikdar	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 11:48:43	01630112939	01949868895	4658501483	\N	B+	Musalman Para Bania Khamar Khulna-9100	Musalman Para Bania Khamar Khulna-9100	2025-07-01	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
46	SNKHL-E45X	SK MD Mostafa	Asst.Manager	\N	123456	Staff	0	Business Development	Active	2025-12-31 11:45:56	01970365530	01960071898	3260265396	\N	O+	Kajdia Shamontosena Rupsha Khulna.	Kumlai Rampal Bagherhat.	2023-02-16	profile_SNKHL-E45X_1767183222.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
45	SNKHL-693D	Purnima Mistry	Manager	\N	1103	Staff	0	Finance	Active	2025-12-31 11:43:18	01703605093	01724468152	8690649226	\N	O+	46,south Central RD.	46,south Central RD.	2023-08-01	profile_SNKHL-693D_1767183253.png	Friday	1,2,3,4	prnima_seal.png	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
44	SNKHL-4U3B	Md. Rafiqul Islam	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 11:42:16	01916007020	01910325508	5972075005	\N	O+	Natun Bazar, City Head Office-9100, Khulna	Natun Bazar, City Head Office-9100, Khulna	2025-11-01	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
43	SNKHL-D7SE	Md Sazzad Khan	Manager	\N	24aug	Staff	0	Finance	Active	2025-12-31 11:41:18	01334072850	01739132816	1012030209	\N	O+	H-960,Muhammadnogor,Gollamari.	H-960,Muhammadnogor,Gollamari.	2025-11-01	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
42	SNKHL-Y84H	Md. Musa Hossain	Asstant Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 11:39:11	01956753268	01308835403	2881265884	\N	B+	Banda Bazar, Labon Chora, Shipyard-9201, Khulna,	Banda Bazar, Labon Chora, Shipyard-9201, Khulna,	2025-05-25	profile_SNKHL-Y84H_1768645194.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
41	SNKHL-8594	MD Hannan Sardar	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 11:38:56	01314003517	01328094772	4681258531	\N		Labanchora Bandha Bazar,Rahomania Moholla.	Jabusha,Baintola.	2023-10-12	profile_SNKHL-8594_1767183444.jpeg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
40	SNKHL-79XC	Rafi Ahmed	Office Asistant	\N	123456	Staff	0	Admin	Active	2025-12-31 11:36:12	01400451542		201265266040864	\N	A+	Rohim Nagar, Customghat, Rupsha, Khulna.	Durgapur, 4 no Word, Narail	2025-02-15	profile_SNKHL-79XC_1768646956.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
39	SNKHL-LCQ8	MD Ratul Gazi	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 11:36:05	01920210563	01909780247	7367347478	\N	AB+	86,Natun Bazar Khulna-9100	86,Natun Bazar Khulna-9100	2020-09-03	profile_SNKHL-LCQ8_1768481406.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
38	SNKHL-B79M	Ruman Howlader	Asst.System Admin	\N	2026@office	Staff	0	Technology	Active	2025-12-31 11:34:14	01910365599	01726810203	1011877055	\N	B+	1 No Boyra Cross Road,Sonadanga.	1 No Boyra Cross Road,Sonadanga.	2016-10-30	profile_SNKHL-B79M_1767183527.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
37	SNKHL-V4SA	Badhon Das.	Executive	badhondas888@gmail.com	sb0219	Staff	1	Technology	Active	2025-12-31 11:31:53	01970365575	01819767151	6002659248	\N	B+	Munshipara 3rd Lane Khulna.	Munshipara 3rd Lane Khulna.	2023-08-01	profile_SNKHL-V4SA_1767423795.jpeg	Friday	1,2,3,4	badhon_sign.png	0	0	0	0	0	0	0	0	0	1	1	1	1	0	3
36	SNKHL-U44X	Md. Rezwan Hossain	Supervisor	\N	123456	Staff	0	Finance	Active	2025-12-31 11:30:42	01920287318	01819166440	2373697081	\N	O+	34, Gagan Babu Road, Khulna-9100	34, Gagan Babu Road, Khulna-9100	2015-07-09	SNKHL-U44X_profile_1767180642.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
35	SNKHL-VR62	MD Jaber Hossen	Executive	\N	123456	Staff	0	Technology	Active	2025-12-31 11:30:18	01893207877	01911703743	5574831490	\N	O+	House no 2026,Uttor horintana,post office jalma,Thana:Botiaghata District:Khulna post code:9260.	House no 2026,Uttor horintana,post office jalma,Thana:Botiaghata District:Khulna post code:9260.	2025-09-01	profile_SNKHL-VR62_1768645284.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
34	SNKHL-AZ3M	MD Naimul Islam	Manager	\N	249432	Staff	0	Finance	Active	2025-12-31 11:27:39	01863668877	01950642494	7352481258	\N	O+	Mathavanga Botiaghata Khulna.	Mathavanga Botiaghata Khulna.	2020-01-15	profile_SNKHL-AZ3M_1767180691.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
33	SNKHL-2LPN	Razib Kumar Sarder	Executive	\N	razib815418	Staff	0	Technology	Active	2025-12-31 11:26:42	01913216063	01970216063	1467703482	\N	O+	47, Tutpara Sarkar Para, Khulna-9100	Kalabogi, -9273, Dacope, Khulna.	2023-03-25	SNKHL-2LPN_profile_1767180402.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
32	SNKHL-J52W	Saiful Islam	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 11:25:01	01749472812	01937076970	19934711271000262	\N	B+	Horintana Alir more.	Horintana Alir more.	2025-07-15	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
31	SNKHL-REY6	Mahedi Hasan Nahid	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 11:22:33	01625353786	01797192822	7367207581	\N	O+	2 No Cross Road South Tutpara Khulna-9100,Khulna.	2 No Cross Road South Tutpara Khulna-9100,Khulna.	2023-05-09	profile_SNKHL-REY6_1767183821.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
30	SNKHL-L7FA	Md. Ashik Gazi	Executive 	\N	123456	Staff	0	Business Development	Active	2025-12-31 11:21:44	0170365577	01920175746	1956049504	\N		Pabla Daulatpur Khulna.	Pabla Daulatpur, Khulna.	2025-09-07	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
29	SNKHL-849K	Robiul Islam Titu	Executive	smhridoy3939722@gmail.com	123456	Staff	0	Business Development	Active	2025-12-31 11:17:04	01917422630	01717393972	1952761482	\N	A+	Azizur Rahman Road,Daroga para,Khulna.	Azizur Rahman Road,Daroga para,Khulna.	2024-12-10	profile_SNKHL-849K_1768277780.jpeg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
28	SNKHL-9MCV	MD Siam Haolader	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 11:13:45	01928750366	01993688568	9167499366	\N	A+	Labonchora Banda Bazer.	Labonchora Banda Bazer.	2023-09-20	profile_SNKHL-9MCV_1767184069.jpeg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
27	SNKHL-6V2W	Raj Kumar Roy	Executive	\N	2580	Staff	0	Technology	Active	2025-12-31 11:00:41	01934037634	01917962256	4666997392	\N	AB+	Gagan Babu Road.	Gagan Babu Road.	2025-06-14	profile_SNKHL-6V2W_1767866086.jpeg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
26	SNKHL-8Y85	MD Maruf Howlader	Assistant Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 10:58:16	01939574972	01937085239	8279427143	\N	B+	Mathvanga,jolma-9260,Botiaghata Khulna.	Mathvanga,jolma-9260,Botiaghata Khulna.	2025-09-23	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
25	SNKHL-3DM2	MD.Rafiqul Islam	Supervisor	\N	123456	Staff	0	Network Operation	Active	2025-12-31 10:55:19	01947295581	01641630331	6902616421	\N	B+	Sonadanga Moylapota Khulna.	Rajapur BagriBazar,Jhalokati.	2019-11-20	profile_SNKHL-3DM2_1767184042.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
24	SNKHL-9W9U	MD.Tanjim Hossain	SR. Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 10:52:09	01754606012	01772450756	0405841350	\N	B+	Pipramari Dumuria Khulna.	Betmor Notun Hat Mothbaria Pirojpur.	2023-05-02	profile_SNKHL-9W9U_1767179240.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
23	SNKHL-H5R2	MD. Mujahid Shuvo	SN Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 10:37:08	01920297272	01995616612	4658506052	\N	AB+	Purbo,Bania Khamar Lohar Ghat BK Road.	Purbo,Bania Khamar Lohar Ghat BK Road.	2025-07-01	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
22	SNKHL-86YF	Harun Or Rashid	Executive Customer Care	\N	Harun199811@	Staff	0	Network Operation	Active	2025-12-31 10:36:56	01537323319, 0166138	01537323319	8258504201	\N	A+	09, Approach Road, Natun Bazar, Khulna	09, Approach Road, Natun Bazar, Khulna	2023-09-20	SNKHL-86YF_profile_1767177416.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
21	SNKHL-5A6S	Nasir Hossain	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 10:34:13	01776584023	01575669827	5552649161	\N	O+	2 No Custom Ghat,Khulna.	2 No Custom Ghat,Khulna.	2023-05-01	profile_SNKHL-5A6S_1767184112.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
20	SNKHL-8XT7	Akash	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 10:31:34	01861378887	01781513199	2003479512206494	\N		Gagan babu Road Oposite of Pani Vobon.	Gagan babu Road Oposite of Pani Vobon.	2025-12-01	profile_SNKHL-8XT7_1768458331.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
19	SNKHL-W5H5	Sharmin Akter Rima	Executive	\N	123456	Staff	0	Technology	Active	2025-12-31 10:30:55	01840836384	01753507540, 0192576	8252631349	SNKHL-W5H5_nid_1767177055.jpg	A+	7 No, Miapara Central Jame Mosjid Road, Khulna	7 No, Miapara Central Jame Mosjid Road, Khulna	2020-10-01	profile_SNKHL-W5H5_1767177172.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
18	SNKHL-ZHN9	Md.Shahdat Islam	Ass technitian	\N	123456	Staff	0	Network Operation	Active	2025-12-31 10:28:46	01828647851	01312131091	20070116041009603	\N	O+	Kagoiji Bari Moszid Goli,Khulna.	Kagoiji Bari Moszid Goli,Khulna.	2022-08-01	profile_SNKHL-ZHN9_1767184144.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
17	SNKHL-2EPV	Ripon Sardar	Supervisor	\N	Ripon@1234	Staff	0	Network Operation	Active	2025-12-31 10:27:43	01609598384	01648297159	7404104367	\N	A+	Shardar Para, Damudar, Fultala, Khulna.	Shardar Para, Damudar, Fultala, Khulna.	2019-09-05	SNKHL-2EPV_profile_1767176863.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
16	SNKHL-SXT9	SK. Mizanur Rahman	Assistant Tecchnician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 10:24:35	01950610051	01725661999	2858504406	\N	AB+	South Tutpara,2 no Cross road,Khulna.	South Tutpara,2 no Cross road,Khulna.	2025-09-16	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
15	SNKHL-HT65	Md. Tanzir Hossain Rifat	assistant Technician	\N	RT9900@@	Staff	0	Network Operation	Active	2025-12-31 10:23:46	01982307708	01952682148	20084793322023460	\N	B+	Ajoad Villa, Gaganbabu Road, Khulna-9100.	Bagali, Koyra, Khulna.	2024-07-01	SNKHL-HT65_profile_1767176626.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
14	SNKHL-QX9P	Md.Mahedi Hasan	Assistant Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 10:21:26	01959097025	01708646153	8707066545	\N	O+	2 NO Custom Ghat Dadaji Colony,Khulna.	2 NO Custom Ghat Dadaji Colony,Khulna.	2022-09-05	profile_SNKHL-QX9P_1767184185.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
13	SNKHL-2FVT	Shaikh Tazim Islam	Manager	\N	123944	Staff	0	Finance	Active	2025-12-31 10:15:46	01960018697	01918287334	9576323100	\N	A+	131/6, Taltola Hospital Cross Road, Khulna	131/6, Taltola Hospital Cross Road, Khulna	2025-06-01	profile_SNKHL-2FVT_1768645325.jpeg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
12	SNKHL-S3GD	MD. Imran Morol	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 10:12:55	01400300450	01627646965	9159495051	\N		444/1 Nobo Jamal Chokra Khali Jalma 9260 word-08 Jalma Botiaghata Khulna.	444/1 Nobo Jamal Chokra Khali Jalma 9260 word-08 Jalma Botiaghata Khulna.	2021-10-02	profile_SNKHL-S3GD_1767176198.jpeg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
11	SNKHL-5ZL4	Masum Parvez	Senior Technician	\N	max1998	Staff	0	Network Operation	Active	2025-12-31 10:12:16	01939557181	01616626211	2409322654	\N	A+	2 No, Cross Road, Tootpara, Khulna.	Mollabari, Manikhar, Gopalgonj.	2024-05-01	SNKHL-5ZL4_profile_1767175936.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
10	SNKHL-G6QU	Md. Mehadi Hasan Nishat	Network Operation	\N	123456	Staff	0	Network Operation	Active	2025-12-31 10:04:10	01978870463	01927895715	8730575647	\N	B+	7/8, 2 No-Custom Ghat, Khulna-9100	7/8, 2 No-Custom Ghat, Khulna-9100	2022-10-01	SNKHL-G6QU_profile_1767175450.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
9	SNKHL-JZ6Y	MD. AL-AMIN KHAN	Manager	\N	123456	Staff	0	Finance	Active	2025-12-31 10:04:02	01724537431	01712990377	325155534	\N	A-	186/8,Weast Bania Khamar Main Road,Haji  Torob Ali Lane Khulna.	186/8,Weast Bania Khamar Main Road,Haji  Torob Ali Lane Khulna.	2022-09-01	profile_SNKHL-JZ6Y_1767175516.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
8	SNKHL-JD65	Md. Alim Sheikh	Supervisor	\N	123456	Staff	0	Network Operation	Active	2025-12-31 09:56:11	01797192822	01767891542	5973811150	\N	O+	Darogapara	Darogapara	2017-04-01	SNKHL-JD65_profile_1767174971.jpg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
7	SNKHL-C94L	SK. Mahadi Hasan Jony	IT Officer	\N	123456	Staff	0	Technology	Active	2025-12-31 09:50:09	01964431371	01947440674	2848433922	\N	B+	Senpara, Fulbarigate, Khulna.	Goshguti, Barakpur, Digholia, Khulna.	2025-10-18	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
6	SNKHL-6XF8	Atik Hasan	Technician	\N	123456	Staff	0	Network Operation	Active	2025-12-31 09:39:39	01975780887	01905617419	1517015440	\N	B+	2 no Custom Ghat, Khulna-9100	2 no Custom Ghat, Khulna-9100	2023-09-20	profile_SNKHL-6XF8_1767174061.jpeg	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
5	SNKHL-8KPD	test	No Title	\N	123456	Staff	0	Accounts	Active	2025-12-31 06:32:05	1019974			\N				2025-12-31	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
4	SNKHL-LBSQ	Test-jony	No Title	\N	1234	Staff	0	Accounts	Active	2025-12-31 04:56:55	\N			nid_SNKHL-LBSQ_1767162025.png				2025-12-31	profile_SNKHL-LBSQ_1767162025.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	0	0	1	1	0	3
3	SN-04	Unnamed User			1234	Staff	0		Active	2025-12-30 08:07:25		\N	\N	\N	\N	\N	\N	2025-12-30	default.png	Friday	1,2,3,4	\N	0	0	0	0	0	0	0	0	0	1	1	1	1	0	3
\.


--
-- Name: bandwidth_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bandwidth_requests_id_seq', 46, true);


--
-- Name: billing_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.billing_logs_id_seq', 76, true);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.departments_id_seq', 5, true);


--
-- Name: leave_entitlements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.leave_entitlements_id_seq', 1, false);


--
-- Name: leave_request_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.leave_request_items_id_seq', 1, true);


--
-- Name: leave_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.leave_requests_id_seq', 318, true);


--
-- Name: leave_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.leave_types_id_seq', 4, true);


--
-- Name: monthly_bills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.monthly_bills_id_seq', 13, true);


--
-- Name: office_phones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.office_phones_id_seq', 8, true);


--
-- Name: po_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.po_items_id_seq', 1, true);


--
-- Name: purchase_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.purchase_orders_id_seq', 1, true);


--
-- Name: rate_change_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rate_change_requests_id_seq', 1, true);


--
-- Name: reseller_rate_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reseller_rate_history_id_seq', 6, true);


--
-- Name: resellers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.resellers_id_seq', 13, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.roles_id_seq', 4, true);


--
-- Name: sidebar_menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sidebar_menus_id_seq', 18, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 76, true);


--
-- Name: bandwidth_requests bandwidth_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bandwidth_requests
    ADD CONSTRAINT bandwidth_requests_pkey PRIMARY KEY (id);


--
-- Name: billing_logs billing_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_logs
    ADD CONSTRAINT billing_logs_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: users email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT email UNIQUE (email);


--
-- Name: users employee_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT employee_id UNIQUE (employee_id);


--
-- Name: leave_entitlements leave_entitlements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_entitlements
    ADD CONSTRAINT leave_entitlements_pkey PRIMARY KEY (id);


--
-- Name: leave_request_items leave_request_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_request_items
    ADD CONSTRAINT leave_request_items_pkey PRIMARY KEY (id);


--
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (id);


--
-- Name: leave_types leave_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_pkey PRIMARY KEY (id);


--
-- Name: monthly_bills monthly_bills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monthly_bills
    ADD CONSTRAINT monthly_bills_pkey PRIMARY KEY (id);


--
-- Name: office_phones office_phones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.office_phones
    ADD CONSTRAINT office_phones_pkey PRIMARY KEY (id);


--
-- Name: po_items po_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.po_items
    ADD CONSTRAINT po_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: rate_change_requests rate_change_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rate_change_requests
    ADD CONSTRAINT rate_change_requests_pkey PRIMARY KEY (id);


--
-- Name: reseller_rate_history reseller_rate_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reseller_rate_history
    ADD CONSTRAINT reseller_rate_history_pkey PRIMARY KEY (id);


--
-- Name: resellers resellers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resellers
    ADD CONSTRAINT resellers_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: sidebar_menus sidebar_menus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sidebar_menus
    ADD CONSTRAINT sidebar_menus_pkey PRIMARY KEY (id);


--
-- Name: monthly_bills uk_reseller_month; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monthly_bills
    ADD CONSTRAINT uk_reseller_month UNIQUE (reseller_id, bill_month);


--
-- Name: leave_entitlements uq_leave_entitlements; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_entitlements
    ADD CONSTRAINT uq_leave_entitlements UNIQUE (user_id, leave_type_id, year);


--
-- Name: user_permissions user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_pkey PRIMARY KEY (user_id, permission_key);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: effective_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX effective_date ON public.reseller_rate_history USING btree (effective_date);


--
-- Name: fk_billing_reseller; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_billing_reseller ON public.billing_logs USING btree (reseller_id);


--
-- Name: fk_bw_request_reseller; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_bw_request_reseller ON public.bandwidth_requests USING btree (reseller_id);


--
-- Name: fk_leave_request_rel; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_leave_request_rel ON public.leave_request_items USING btree (request_id);


--
-- Name: idx_leave_entitlements_user_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leave_entitlements_user_year ON public.leave_entitlements USING btree (user_id, year);


--
-- Name: idx_leave_requests_leave_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leave_requests_leave_type_id ON public.leave_requests USING btree (leave_type_id);


--
-- Name: po_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX po_id ON public.po_items USING btree (po_id);


--
-- Name: proposed_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX proposed_by ON public.rate_change_requests USING btree (proposed_by);


--
-- Name: reseller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reseller_id ON public.rate_change_requests USING btree (reseller_id);


--
-- Name: user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_id ON public.leave_requests USING btree (user_id);


--
-- Name: leave_entitlements trg_leave_entitlements_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_leave_entitlements_updated_at BEFORE UPDATE ON public.leave_entitlements FOR EACH ROW EXECUTE FUNCTION public.set_timestamp_leave_entitlements();


--
-- Name: roles update_roles_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_roles_updated_at BEFORE UPDATE ON public.roles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: leave_entitlements leave_entitlements_leave_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_entitlements
    ADD CONSTRAINT leave_entitlements_leave_type_id_fkey FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id) ON DELETE CASCADE;


--
-- Name: leave_entitlements leave_entitlements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_entitlements
    ADD CONSTRAINT leave_entitlements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 3EtYaUoyFBUGZXSRdP6FCjEWyxIwkVYbvMb8epvDcaM8OVQOXrLI503rzzG4M8L

