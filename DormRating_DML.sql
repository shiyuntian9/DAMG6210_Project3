--Login as DormRating user account and run below script

BEGIN EXECUTE IMMEDIATE 'DROP TABLE owner CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE property CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE dormitory CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE university CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE review CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE user_table CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE admin_user CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE sublet CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE lease CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE user_lease CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE order_table CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE coupon CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE comment CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;

ALTER SESSION SET NLS_LANGUAGE=American;
ALTER SESSION SET NLS_TERRITORY=America;

-- Owner Table
CREATE TABLE owner (
    owner_id NUMBER CONSTRAINT owner_pk PRIMARY KEY,
    owner_type VARCHAR2(255),
    contact_email VARCHAR2(255) CONSTRAINT own_email_nn NOT NULL,
    contact_phone VARCHAR2(255) CONSTRAINT own_phone_nn NOT NULL,
    owner_info CLOB,
    status NUMBER(3) CONSTRAINT own_stat_nn NOT NULL
);



-- University Table
CREATE TABLE university (
    university_id NUMBER CONSTRAINT univ_pk PRIMARY KEY,
    university_name VARCHAR2(255) CONSTRAINT univ_name_nn NOT NULL,
    location_state VARCHAR2(255) CONSTRAINT univ_state_nn NOT NULL,
    location_city VARCHAR2(255) CONSTRAINT univ_city_nn NOT NULL,
    univ_photo BLOB,
    univ_description CLOB,
    official_website_link VARCHAR2(255),
    status NUMBER(3) CONSTRAINT univ_stat_nn NOT NULL
);

-- Dormitory Table
CREATE TABLE dormitory (
    dorm_id NUMBER CONSTRAINT dorm_pk PRIMARY KEY,
    university_id NUMBER NOT NULL,
    dorm_name VARCHAR2(255) CONSTRAINT dorm_name_nn NOT NULL,
    room_score NUMBER CONSTRAINT dorm_rscore_nn NOT NULL,
    environment_score FLOAT CONSTRAINT dorm_escore_nn NOT NULL,
    location_score FLOAT CONSTRAINT dorm_lscore_nn NOT NULL,
    facility_score FLOAT CONSTRAINT dorm_fscore_nn NOT NULL,
    dorm_photo BLOB,
    number_of_rating NUMBER,
    status NUMBER(3) CONSTRAINT dorm_stat_nn NOT NULL
    CONSTRAINT fk_dormitory_univ FOREIGN KEY (university_id) REFERENCES university(university_id)
);

-- Foreign Key for dormitory referencing university
ALTER TABLE dormitory
ADD CONSTRAINT dorm_univ_fk
FOREIGN KEY (university_id) REFERENCES university(university_id);


-- Property Table
CREATE TABLE property (
    property_id NUMBER CONSTRAINT prop_pk PRIMARY KEY,
    owner_id NUMBER,
    dorm_id NUMBER,
    room_type VARCHAR2(255) CONSTRAINT prop_rtype_nn NOT NULL,
    monthly_rent NUMBER CONSTRAINT prop_mrent_nn NOT NULL,
    deposit NUMBER CONSTRAINT prop_deposit_nn NOT NULL,
    min_lease_period NUMBER(3),
    max_lease_period NUMBER(3),
    available_from DATE CONSTRAINT prop_afrom_nn NOT NULL,
    property_photo BLOB,
    description CLOB,
    status NUMBER(3) CONSTRAINT property_stauts_nn NOT NULL,
    CONSTRAINT fk_property_owner FOREIGN KEY (owner_id) REFERENCES owner(owner_id),
    CONSTRAINT fk_property_dorm FOREIGN KEY (dorm_id) REFERENCES dormitory(dorm_id)
);

--Two foreign keys; one referencing the Owner table, and the other referencing the Dormitory table
ALTER TABLE property
ADD CONSTRAINT prop_own_fk
FOREIGN KEY (owner_id) REFERENCES owner(owner_id);

ALTER TABLE property
ADD CONSTRAINT prop_dorm_fk
FOREIGN KEY (dorm_id) REFERENCES dormitory(dorm_id);


-- Review Table
CREATE TABLE review (
    review_id NUMBER CONSTRAINT rev_pk PRIMARY KEY,
    user_id NUMBER,
    dorm_id NUMBER,
    comment_text CLOB,
    room_type VARCHAR2(255),
    room_overall_score NUMBER(3) CONSTRAINT rev_roscore_nn NOT NULL,
    environment_score NUMBER(3),
    location_overall_score NUMBER(3),
    facility_overall_score NUMBER(3),
    review_time TIMESTAMP CONSTRAINT rev_rtime_nn NOT NULL,
    status NUMBER(3),
    FOREIGN KEY (user_id) REFERENCES user_table(user_id),
    FOREIGN KEY (dorm_id) REFERENCES dormitory(dorm_id)
);

--Two foreign keys; one referencing the User Table, and the other referencing the Dormitory table
ALTER TABLE review
ADD CONSTRAINT rev_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);

ALTER TABLE review
ADD CONSTRAINT rev_dorm_fk
FOREIGN KEY (dorm_id) REFERENCES dormitory(dorm_id);


-- User Table
CREATE TABLE user_table (
    user_id NUMBER CONSTRAINT user_pk PRIMARY KEY,
    nickname VARCHAR2(255),
    user_email VARCHAR2(255) CONSTRAINT usr_email_nn NOT NULL,
    password VARCHAR2(255) CONSTRAINT usr_pwd_nn NOT NULL,
    payment_method VARCHAR2(255),
    balance FLOAT,
    grade VARCHAR2(255),
    avatar BLOB,
    register_time DATE CONSTRAINT usr_rtime_nn NOT NULL,
    status NUMBER(3)
);

-- Admin_user Table
CREATE TABLE admin_user (
    admin_user_id NUMBER CONSTRAINT admin_user_pk PRIMARY KEY,
    admin_username VARCHAR2(255) CONSTRAINT adm_usr_nn NOT NULL,
    admin_password VARCHAR2(255) CONSTRAINT adm_pwd_nn NOT NULL,
    permission_level NUMBER(3) CONSTRAINT adm_perm_lvl_nn NOT NULL,
    status NUMBER(3)
);

-- Lease Table
CREATE TABLE lease (
    lease_id NUMBER CONSTRAINT lease_pk PRIMARY KEY,
    property_id NUMBER,
    lease_start_time DATE CONSTRAINT lease_stime_nn NOT NULL,
    deposit_status NUMBER(3) CONSTRAINT lease_dstat_nn NOT NULL,
    contract_file BLOB CONSTRAINT lease_cfile_nn NOT NULL,
    status NUMBER(3) CONSTRAINT lease_stat_nn NOT NULL,
    FOREIGN KEY (property_id) REFERENCES property(property_id)
);


--Foreign key referencing the Property table
ALTER TABLE lease
ADD CONSTRAINT lease_prop_fk
FOREIGN KEY (property_id) REFERENCES property(property_id);


-- Sublet Table
CREATE TABLE sublet (
    sublease_id NUMBER CONSTRAINT sublet_pk PRIMARY KEY,
    lease_id NUMBER,
    lessee_user_id NUMBER,
    lessor_user_id NUMBER,
    sublease_rent NUMBER CONSTRAINT sublet_rent_nn NOT NULL,
    available_from DATE CONSTRAINT sublet_afrom_nn NOT NULL,
    available_end DATE CONSTRAINT sublet_aend_nn NOT NULL,
    status NUMBER(3) CONSTRAINT sublet_stat_nn NOT NULL,
    FOREIGN KEY (lease_id) REFERENCES lease(lease_id),
    FOREIGN KEY (lessee_user_id) REFERENCES user_table(user_id),
    FOREIGN KEY (lessor_user_id) REFERENCES user_table(user_id)
);


--Three foreign keys; referencing the Lease table, and two referencing the User Table (for lessee and lessor)
ALTER TABLE sublet
ADD CONSTRAINT sub_lease_fk
FOREIGN KEY (lease_id) REFERENCES lease(lease_id);

ALTER TABLE sublet
ADD CONSTRAINT sub_lessee_fk
FOREIGN KEY (lessee_user_id) REFERENCES user_table(user_id);

ALTER TABLE sublet
ADD CONSTRAINT sub_lessor_fk
FOREIGN KEY (lessor_user_id) REFERENCES user_table(user_id);


-- User_lease Table
CREATE TABLE user_lease (
    user_lease_id NUMBER CONSTRAINT user_lease_pk PRIMARY KEY,
    user_id NUMBER,
    lease_id NUMBER,
    lease_status NUMBER(3) CONSTRAINT lease_stat_nn NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user_table(user_id)
    FOREIGN KEY (lease_id) REFERENCES lease(lease_id),
);

--Two foreign keys; one referencing the User Table, and the other referencing the Lease table
ALTER TABLE user_lease
ADD CONSTRAINT ul_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);

ALTER TABLE user_lease
ADD CONSTRAINT ul_lease_fk
FOREIGN KEY (lease_id) REFERENCES lease(lease_id);


-- Coupon Table
CREATE TABLE coupon (
    coupon_id NUMBER CONSTRAINT coupon_pk PRIMARY KEY,
    description CLOB,
    user_id NUMBER,
    effective_time TIMESTAMP CONSTRAINT effct_time_nn NOT NULL,
    expire_time TIMESTAMP CONSTRAINT expr_time_nn NOT NULL,
    status NUMBER(3) CONSTRAINT coupon_stat_nn NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user_table(user_id)
);

--Foreign key referencing the User Table
ALTER TABLE coupon
ADD CONSTRAINT coup_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);


-- Order Table (renamed to avoid reserved keyword)
CREATE TABLE order_table (
    order_id NUMBER CONSTRAINT order_pk PRIMARY KEY,
    user_id NUMBER,
    lease_id NUMBER,
    coupon_id NUMBER,
    amount_payable FLOAT CONSTRAINT ord_apay_nn NOT NULL,
    amount_paid FLOAT CONSTRAINT ord_apd_nn NOT NULL,
    amount_discount FLOAT CONSTRAINT ord_adisc_nn NOT NULL,
    late_payment_fee FLOAT CONSTRAINT ord_lpf_nn NOT NULL,
    due TIMESTAMP CONSTRAINT ord_due_nn NOT NULL,
    generate_time DATE CONSTRAINT ord_gtime_nn NOT NULL,
    payment_time DATE CONSTRAINT ord_ptime_nn NOT NULL,
    status NUMBER(3) CONSTRAINT ord_stat_nn NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user_table(user_id),
    FOREIGN KEY (lease_id) REFERENCES lease(lease_id),
    FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id)
);


--Three foreign keys; one referencing the User Table, one referencing the Lease table, and one referencing the Coupon table
ALTER TABLE order_table
ADD CONSTRAINT ord_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);

ALTER TABLE order_table
ADD CONSTRAINT ord_lease_fk
FOREIGN KEY (lease_id) REFERENCES lease(lease_id);

ALTER TABLE order_table
ADD CONSTRAINT ord_coupon_fk
FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id);


-- Comment Table
CREATE TABLE comment (
    comment_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    university_id NUMBER,
    comment_content CLOB CONSTRAINT comm_cont_nn NOT NULL,
    number_of_upvote NUMBER CONSTRAINT comm_upvote_nn NOT NULL,
    comment_time TIMESTAMP CONSTRAINT comm_time_nn NOT NULL,
    status NUMBER(3) CONSTRAINT comm_stat_nn NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user_table(user_id),
    CONSTRAINT fk_comment_univ FOREIGN KEY (university_id) REFERENCES university(university_id)
);


--two foreign keys; one referencing the User Table, and the other referencing the University table
ALTER TABLE comment
ADD CONSTRAINT comm_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);

ALTER TABLE comment
ADD CONSTRAINT comm_univ_fk
FOREIGN KEY (university_id) REFERENCES university(university_id);



