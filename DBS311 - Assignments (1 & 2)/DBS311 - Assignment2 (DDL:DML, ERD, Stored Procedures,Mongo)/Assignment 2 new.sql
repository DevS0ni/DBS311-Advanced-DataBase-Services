-- Author: James Giroux - jgiroux1@myseneca.ca
-- Date:   November 28, 2022
-- DBS 311 - Advanced Database Services


--         Drop all tables

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
--SET TRIMSPOOL ON
--SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF

DROP TABLE categories CASCADE CONSTRAINTS;
DROP TABLE customers CASCADE CONSTRAINTS;
DROP TABLE order_line CASCADE CONSTRAINTS;
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE payment CASCADE CONSTRAINTS;
DROP TABLE record_hist CASCADE CONSTRAINTS;
DROP TABLE recording CASCADE CONSTRAINTS;
DROP TABLE region CASCADE CONSTRAINTS;
DROP TABLE label_company CASCADE CONSTRAINTS;
DROP TABLE sales_rep CASCADE CONSTRAINTS;


-- create tables and add data and constraints

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
--SET TRIMSPOOL ON
--SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF

CREATE TABLE customers
    ( customer_id      NUMBER(5,0) PRIMARY KEY,
    first_name     VARCHAR2(20),
    last_name      VARCHAR2(25) NOT NULL,
    email          VARCHAR2(25) UNIQUE,
    dob            DATE,
    street         VARCHAR2(50),
    city           VARCHAR2(30),
    province       VARCHAR2(5),
    postal_code    VARCHAR2(10),
    phone_num      VARCHAR2(14)) ;

CREATE TABLE orders
    (order_id       NUMBER PRIMARY KEY,
    customer_id     NUMBER(5,0) NOT NULL,
    order_date      DATE NOT NULL,
    order_total     NUMBER(8,2) NOT NULL,
    CONSTRAINT order_total_chk CHECK (order_total > 0),
    CONSTRAINT customer_id_fk
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id));

CREATE TABLE payment 
    (card_number    VARCHAR2(20) PRIMARY KEY,
    order_id        NUMBER(5,0) NOT NULL,  
    card_holder     VARCHAR2(50),
    exp_date        VARCHAR2(5),
    card_type       VARCHAR(20),
    CONSTRAINT pay_order_fk 
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT card_type_chk 
        CHECK (card_type IN ('VISA', 'MAST', 'AMEX')));

CREATE TABLE categories
    (category_id    NUMBER(5,0) PRIMARY KEY,
    cat_desc        VARCHAR(50),
    CONSTRAINT cat_desc_in CHECK (cat_desc IN 
        ('RANDB', 'Jazz', 'Metal Rock', 'Alt Rock','Easy Rock','Classic Rock','Hip-Hop')));

CREATE TABLE label_company
    (label_id       NUMBER(5,0) PRIMARY KEY,
    label_name      VARCHAR2(100),
    website         VARCHAR2(200));

CREATE TABLE region
    (region_id      NUMBER(5,0) PRIMARY KEY,
    region_name     VARCHAR2(50));

CREATE TABLE sales_rep
    (rep_id         NUMBER(5,0) PRIMARY KEY,
    label_id        NUMBER(5,2) NOT NULL,
    region_id       NUMBER(5,2) NOT NULL,
    first_name      VARCHAR2(20),
    last_name       VARCHAR2(30),
    phone_num       VARCHAR2(20),
    email           VARCHAR2(50) UNIQUE,
    CONSTRAINT rep_label_id_fk FOREIGN KEY (label_id) REFERENCES label_company(label_id),
    CONSTRAINT region_id_fk FOREIGN KEY (region_id) REFERENCES region(region_id));
    
CREATE TABLE recording
    (recording_id   NUMBER(5,0) PRIMARY KEY,
    title       VARCHAR2(30),
    artist      VARCHAR2(30),
    sell_price  NUMBER,
    qty_stock   NUMBER(8,2),
    category_id NUMBER(5,0) NOT NULL,
    label_id    NUMBER(5,0) NOT NULL,
    CONSTRAINT cat_id_fk FOREIGN KEY(category_id) REFERENCES categories(category_id),
    CONSTRAINT rec_label_id_fk FOREIGN KEY (label_id) REFERENCES label_company(label_id)) ;
       
CREATE TABLE order_line 
    (Line_num       NUMBER PRIMARY KEY,
    order_id        NUMBER(5,0) NOT NULL,
    recording_id    NUMBER(5,0) NOT NULL,
    qty             NUMBER,
    act_price       NUMBER(8,2),
    CONSTRAINT order_line_id_fk 
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT order_line_fk
        FOREIGN KEY (recording_id) REFERENCES recording(recording_id),
    CONSTRAINT qty_pos CHECK(qty >= 0),
    CONSTRAINT price_pos CHECK(act_price > 0)) ;

CREATE TABLE record_hist
    (price_num      NUMBER(5,0) NOT NULL,
    recording_id    NUMBER(5,0) NOT NULL,
     PRIMARY KEY (price_num,recording_id),
    price           NUMBER(8,2) CONSTRAINT price_chk CHECK (price BETWEEN 0 AND 1000),
    st_date         DATE,
    CONSTRAINT recording_id_fk FOREIGN KEY (recording_id)
        REFERENCES recording(recording_id));
    
-- LOAD ALL THE DATA

INSERT INTO customers VALUES
    (1,
    'James',
    'Giroux',
    'jgiroux1@myseneca.ca',    
    TO_DATE('02-OCT-1979', 'dd-MON-yyyy'),
    '25 Smith pkwy',
    'Toronto',
    'ON',
    'M2M1X6',
    '(647)-924-5369') ;

INSERT INTO customers VALUES
    (2,
    'Robert',
    'Smith',
    'rsmith2@myseneca.ca',    
    TO_DATE('20-JAN-1999', 'dd-MON-yyyy'),
    '12 Fuzzy Ln.',
    'Toronto',
    'ON',
    'M4J1L8',
    '(647)-435-1342') ;

INSERT INTO customers VALUES
    (3,
    'Mike',
    'Rand',
    'mrand23@myseneca.ca',    
    TO_DATE('15-AUG-2001', 'dd-MON-yyyy'),
    '2342 Baview Ave',
    'North York',
    'ON',
    'M6J1S4',
    '(416)-723-1755') ;

INSERT INTO customers VALUES
    (4,
    'Tiffany',
    'LeMieu',
    'tlemieu@myseneca.ca',    
    TO_DATE('06-JUL-1985', 'dd-MON-yyyy'),
    '108 Broadview Ave.',
    'Toronto',
    'ON',
    'M1E6F2',
    '(416)-547-1298') ;

INSERT INTO customers VALUES
    (5,
    'Jennifer',
    'Laurence',
    'jlaurence@myseneca.ca',    
    TO_DATE('26-Dec-1989', 'dd-MON-yyyy'),
    '5 Young St.',
    'Toronto',
    'ON',
    'M1R2D4',
    '(647)-519-5656') ;

INSERT INTO customers VALUES
    (6,
    'Donald',
    'Dolphin',
    'ddolphin@myseneca.ca',    
    TO_DATE('12-FEB-1981', 'dd-MON-yyyy'),
    '35 Wooten Way',
    'Markham',
    'ON',
    'L3R4J5',
    '(905)-672-1783') ;

INSERT INTO customers VALUES
    (7,
    'Mike',
    'Tonelli',
    'mtonelli@myseneca.ca',    
    TO_DATE('14-MAR-1987', 'dd-MON-yyyy'),
    '562 Steeles Ave E',
    'Thornhill',
    'ON',
    'L8Z1H5',
    '(905)-719-6429') ;

INSERT INTO customers VALUES
    (8,
    'Carl',
    'Schafer',
    'cshafer@myseneca.ca',    
    TO_DATE('06-SEP-1967', 'dd-MON-yyyy'),
    '1234 Keele St.',
    'Etobicoke',
    'ON',
    'M7G3D8',
    '(647)-846-5369') ;

INSERT INTO customers VALUES
    (9,
    'Aida',
    'Mulder',
    'amulder@myseneca.ca',    
    TO_DATE('22-JUL-1960', 'dd-MON-yyyy'),
    '123 Moore Park Ave.',
    'North York',
    'ON',
    'M2M2R4',
    '(416)-656-6656') ;

INSERT INTO customers VALUES
    (10,
    'Amanda',
    'Strathdee',
    'astrathdee2@myseneca.ca',    
    TO_DATE('02-OCT-1979', 'dd-MON-yyyy'),
    '54 Hounslow Ave.',
    'North York',
    'ON',
    'M52J1X',
    '(647)-882-8282') ;

INSERT INTO orders VALUES
    (1,
    3,
    TO_DATE('12-NOV-2021', 'dd-MON-yyyy'),
    34.56) ;

INSERT INTO orders VALUES
    (2,
    1,
    TO_DATE('11-OCT-2022', 'dd-MON-yyyy'),
    99.95) ;

INSERT INTO orders VALUES
    (3,
    4,
    TO_DATE('28-JAN-2022', 'dd-MON-yyyy'),
    9.99) ;

INSERT INTO orders VALUES
    (4,
    8,
    TO_DATE('08-AUG-2021', 'dd-MON-yyyy'),
    359.80) ;

INSERT INTO orders VALUES
    (5,
    6,
    TO_DATE('25-NOV-2022', 'dd-MON-yyyy'),
    155.88) ;

INSERT INTO payment VALUES
    ('4520432156788765',
    1,
    'James Giroux',
    '02/26',
    'VISA') ;

INSERT INTO payment VALUES
    ('4520474592348723',
    2,
    'Robert Smith',
    '08/25',
    'VISA') ;

INSERT INTO payment VALUES
    ('4520659123877634',
    3,
    'Mike Rand',
    '04/24',
    'VISA') ;

INSERT INTO payment VALUES
    ('4520675488912546',
    4,
    'Donald Dolphin',
    '09/25',
    'VISA') ;

INSERT INTO payment VALUES
    ('4520657299237610',
    5,
    'Carl Schafer',
    '06/23',
    'VISA') ;

INSERT INTO categories VALUES
    (1,
    'RANDB');
INSERT INTO categories VALUES
    (2,
    'Jazz');
INSERT INTO categories VALUES
    (3,
    'Metal Rock');
INSERT INTO categories VALUES
    (4,
    'Alt Rock');
INSERT INTO categories VALUES
    (5,
    'Easy Rock');
INSERT INTO categories VALUES
    (6,
    'Classic Rock');
INSERT INTO categories VALUES
    (7,
    'Hip-Hop');

INSERT INTO label_company VALUES
    (100,
    'Smooth Records',
    'www.smoothrecords.com') ;
INSERT INTO label_company VALUES
    (200,
    'Rockin Records',
    'www.rockinrecords.com') ;

INSERT INTO region VALUES   
    (1,
    'Americas') ;
INSERT INTO region VALUES   
    (2,
    'Europe') ;

INSERT INTO sales_rep VALUES
    (10,
    100,
    1,
    'Harry',
    'Styles',
    '(416)321-4567',
    'hstyles@smoothrecords.com') ;
INSERT INTO sales_rep VALUES
    (20,
    200,
    2,
    'Joseph',
    'Smith',
    '(416)454-2556',
    'jsmith23@rockinrecords.com') ;
INSERT INTO sales_rep VALUES
    (30,
    100,
    1,
    'Jen',
    'Holmes',
    '(647)884-9100',
    'jholmes12@smoothrecords.com') ;
INSERT INTO sales_rep VALUES
    (40,
    200,
    2,
    'Amanda',
    'Jones',
    '(416)444-6523',
    'ajones10@rockinrecords.com') ;
INSERT INTO sales_rep VALUES
    (50,
    100,
    1,
    'Barb',
    'Lawrence',
    '(647)222-6565',
    'blaurence@smoothrecords.com') ;
INSERT INTO sales_rep VALUES
    (60,
    200,
    2,
    'Richard',
    'Wessel',
    '(416)434-1212',
    'rwessel@rockinrecords.com') ;

INSERT INTO recording VALUES
    (10,
    'Whats Going On',
    'Marvin Gaye',
    15.25,
    34,
    1,
    200) ;
INSERT INTO recording VALUES
    (20,
    'Kind of Blue',
    'Miles Davis',
    19.99,
    22,
    2,
    200) ;
INSERT INTO recording VALUES
    (30,
    'Ride the Lightning',
    'Metalica',
    9.99,
    12,
    3,
    100) ;
INSERT INTO recording VALUES
    (40,
    'Nevermind',
    'Nirvana',
    9.99,
    12,
    4,
    100) ;
INSERT INTO recording VALUES
    (50,
    'Rhumers',
    'Fleetwood Mac',
    17.99,
    18,
    5,
    100) ;
INSERT INTO recording VALUES
    (60,
    'Dark Side of the Moon',
    'Pink Floyd',
    25.98,
    2,
    6,
    100) ;
INSERT INTO recording VALUES
    (70,
    'Ready to Die',
    'The Notorius BIG',
    25.98,
    35,
    7,
    200) ;

INSERT INTO order_line VALUES
    (1,
    1,
    10,
    2,
    15.25) ;

INSERT INTO order_line VALUES
    (2,
    2,
    20,
    5,
    19.99) ;
INSERT INTO order_line VALUES
    (3,
    3,
    30,
    1,
    9.99) ;
INSERT INTO order_line VALUES
    (4,
    4,
    40,
    20,
    17.99) ;
INSERT INTO order_line VALUES
    (5,
    5,
    50,
    6,
    25.98) ;

INSERT INTO record_hist VALUES
    (1,
    10,
    15.25,
    TO_DATE('01-JAN-2020', 'dd-MON-yyyy')) ;
INSERT INTO record_hist VALUES
    (2,
    20,
    19.99,
    TO_DATE('01-JAN-2020', 'dd-MON-yyyy')) ;
INSERT INTO record_hist VALUES
    (3,
    30,
    9.99,
    TO_DATE('01-JAN-2020', 'dd-MON-yyyy')) ;
INSERT INTO record_hist VALUES
    (4,
    40,
    17.99,
    TO_DATE('01-JAN-2020', 'dd-MON-yyyy')) ;
INSERT INTO record_hist VALUES
    (5,
    50,
    25.98,
    TO_DATE('01-JAN-2020', 'dd-MON-yyyy')) ;
    
COMMIT;