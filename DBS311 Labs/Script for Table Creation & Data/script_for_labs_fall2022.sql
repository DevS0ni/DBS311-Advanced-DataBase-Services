

Rem
Rem    This PART of script will drop all SEQUENCES and TABLES related to DEMO schema
Rem

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
--SET TRIMSPOOL ON
--SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF

DROP SEQUENCE locations_seq;
DROP SEQUENCE departments_seq;
DROP SEQUENCE employees_seq;

DROP TABLE countries CASCADE CONSTRAINTS;
DROP TABLE locations CASCADE CONSTRAINTS;
DROP TABLE departments CASCADE CONSTRAINTS;
DROP TABLE employees   CASCADE CONSTRAINTS;
DROP TABLE job_grades;
DROP TABLE job_history;
DROP TABLE jobs CASCADE CONSTRAINTS;
DROP TABLE product_categories CASCADE CONSTRAINTS;
DROP TABLE products CASCADE CONSTRAINTS;
DROP TABLE warehouses CASCADE CONSTRAINTS;




Rem
Rem      This PART of the script creates SIX tables, polulates data, adds associated constraints
Rem      and indexes for the DEMO user.
Rem

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
--SET TRIMSPOOL ON
--SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF 

REM ********************************************************************
REM Create the COUNTRIES table to hold country information for customers
REM and company locations. 
REM LOCATIONS have a foreign key to this table.

Prompt ******  Creating COUNTRIES table ....

CREATE TABLE countries 
    ( country_id      CHAR(2) 
       CONSTRAINT  country_id_nn NOT NULL 
    , country_name    VARCHAR2(40) 
    , region_id       NUMBER 
    , CONSTRAINT     country_c_id_pk 
        	     PRIMARY KEY (country_id) 
    ) 
    ORGANIZATION INDEX; 


REM ********************************************************************
REM Create the LOCATIONS table to hold address information for company departments.
REM DEPARTMENTS has a foreign key to this table.

Prompt ******  Creating LOCATIONS table ....

CREATE TABLE locations
    ( location_id    NUMBER(4)
    , street_address VARCHAR2(40)
    , postal_code    VARCHAR2(12)
    , city       VARCHAR2(30)
	CONSTRAINT     loc_city_nn  NOT NULL
    , state_province VARCHAR2(25)
    , country_id     CHAR(2)
    ) ;

CREATE UNIQUE INDEX loc_id_pk
ON locations (location_id) ;

ALTER TABLE locations
ADD ( CONSTRAINT loc_id_pk
       		 PRIMARY KEY (location_id)
        ) ;

Rem 	Useful for any subsequent addition of rows to locations table
Rem 	Starts with 3300

CREATE SEQUENCE locations_seq
 START WITH     3300
 INCREMENT BY   100
 MAXVALUE       9900
 NOCACHE
 NOCYCLE;


REM ********************************************************************
REM Create the DEPARTMENTS table to hold company department information.
REM EMPLOYEES  has a foreign key to this table.

Prompt ******  Creating DEPARTMENTS table ....

CREATE TABLE departments
    ( department_id    NUMBER(4)
    , department_name  VARCHAR2(30)
	CONSTRAINT  dept_name_nn  NOT NULL
    , manager_id       NUMBER(6)
    , location_id      NUMBER(4)
    ) ;

CREATE UNIQUE INDEX dept_id_pk
ON departments (department_id) ;

ALTER TABLE departments
ADD ( CONSTRAINT dept_id_pk
       		 PRIMARY KEY (department_id)
         ) ;

Rem 	Useful for any subsequent addition of rows to departments table
Rem 	Starts with 280 

CREATE SEQUENCE departments_seq
 START WITH     280
 INCREMENT BY   10
 MAXVALUE       9990
 NOCACHE
 NOCYCLE;


REM ********************************************************************
REM Create the EMPLOYEES table to hold the employee personnel 
REM information for the company.
REM EMPLOYEES has a self referencing foreign key to this table.

Prompt ******  Creating EMPLOYEES table ....

CREATE TABLE employees
    ( employee_id    NUMBER(6)
    , first_name     VARCHAR2(20)
    , last_name      VARCHAR2(25)
	 CONSTRAINT     emp_last_name_nn  NOT NULL
    , email          VARCHAR2(25)
	CONSTRAINT     emp_email_nn  NOT NULL
    , phone_number   VARCHAR2(20)
    , hire_date      DATE
	CONSTRAINT     emp_hire_date_nn  NOT NULL
    , job_id         VARCHAR2(10)
	CONSTRAINT     emp_job_nn  NOT NULL
    , salary         NUMBER(8,2)
    , commission_pct NUMBER(2,2)
    , manager_id     NUMBER(6)
    , department_id  NUMBER(4)
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0) 
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    ) ;

CREATE UNIQUE INDEX emp_emp_id_pk
ON employees (employee_id) ;


ALTER TABLE employees
ADD ( CONSTRAINT     emp_emp_id_pk
                     PRIMARY KEY (employee_id)
    , CONSTRAINT     emp_dept_fk
                     FOREIGN KEY (department_id)
                      REFERENCES departments
    , CONSTRAINT     emp_manager_fk
                     FOREIGN KEY (manager_id)
                      REFERENCES employees
    ) ;

ALTER TABLE departments
ADD ( CONSTRAINT dept_mgr_fk
      		 FOREIGN KEY (manager_id)
      		  REFERENCES employees (employee_id)
    ) ;


Rem 	Useful for any subsequent addition of rows to employees table
Rem 	Starts with 207 


CREATE SEQUENCE employees_seq
 START WITH     207
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;


REM ********************************************************************
REM Create the JOB_GRADES table that will show different SALARY GRADES 
REM depending on employee's SALARY RANGE

Prompt ******  Creating JOB_GRADES table ....

CREATE TABLE job_grades (
grade 		CHAR(1),
lowest_sal 	NUMBER(8,2) NOT NULL,
highest_sal	NUMBER(8,2) NOT NULL
);

ALTER TABLE job_grades
ADD CONSTRAINT jobgrades_grade_pk PRIMARY KEY (grade);



-- product category
CREATE TABLE product_categories
  (
    category_id NUMBER PRIMARY KEY,
    category_name VARCHAR2( 255 ) NOT NULL
  );

-- products table
CREATE TABLE products
  (
    product_id NUMBER PRIMARY KEY,
    product_name  VARCHAR2( 255 ) NOT NULL,
    description   VARCHAR2( 2000 )        ,
    standard_cost NUMBER( 9, 2 )          ,
    list_price    NUMBER( 9, 2 )          ,
    category_id   NUMBER NOT NULL         ,
    CONSTRAINT fk_products_categories 
      FOREIGN KEY( category_id )
      REFERENCES product_categories( category_id ) 
      ON DELETE CASCADE
  );

-- warehouses
CREATE TABLE warehouses
  (
    warehouse_id NUMBER PRIMARY KEY,
    warehouse_name VARCHAR( 255 ) ,
    location_id    NUMBER(4), -- fk
    CONSTRAINT fk_warehouses_locations 
      FOREIGN KEY( location_id )
      REFERENCES locations( location_id ) 
      ON DELETE CASCADE
  );


rem This PART of script will populate script for the DEMO account
rem
rem NOTES There is a circular foreign key reference between 
rem       EMPLOYEES and DEPARTMENTS. That's why we disable
rem       the FK constraints here
rem

SET VERIFY OFF

REM ***************************insert data into the COUNTRIES table

Prompt ******  Populating COUNTIRES table ....

INSERT INTO countries VALUES 
        ( 'IT'
        , 'Italy'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'JP'
        , 'Japan'
	, 3 
        );

INSERT INTO countries VALUES 
        ( 'US'
        , 'United States of America'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'CA'
        , 'Canada'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'CN'
        , 'China'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'IN'
        , 'India'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'AU'
        , 'Australia'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'ZW'
        , 'Zimbabwe'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'SG'
        , 'Singapore'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'UK'
        , 'United Kingdom'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'FR'
        , 'France'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'DE'
        , 'Germany'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'ZM'
        , 'Zambia'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'EG'
        , 'Egypt'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'BR'
        , 'Brazil'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'CH'
        , 'Switzerland'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'NL'
        , 'Netherlands'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'MX'
        , 'Mexico'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'KW'
        , 'Kuwait'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'IL'
        , 'Israel'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'DK'
        , 'Denmark'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'HK'
        , 'HongKong'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'NG'
        , 'Nigeria'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'AR'
        , 'Argentina'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'BE'
        , 'Belgium'
        , 1 
        );


REM ***************************insert data into the LOCATIONS table

Prompt ******  Populating LOCATIONS table ....

INSERT INTO locations VALUES 
        ( 1000 
        , '1297 Via Cola di Rie'
        , '00989'
        , 'Roma'
        , NULL
        , 'IT'
        );

INSERT INTO locations VALUES 
        ( 1100 
        , '93091 Calle della Testa'
        , '10934'
        , 'Venice'
        , NULL
        , 'IT'
        );

INSERT INTO locations VALUES 
        ( 1200 
        , '2017 Shinjuku-ku'
        , '1689'
        , 'Tokyo'
        , 'Tokyo Prefecture'
        , 'JP'
        );

INSERT INTO locations VALUES 
        ( 1300 
        , '9450 Kamiya-cho'
        , '6823'
        , 'Hiroshima'
        , NULL
        , 'JP'
        );

INSERT INTO locations VALUES 
        ( 1400 
        , '2014 Jabberwocky Rd'
        , '26192'
        , 'Southlake'
        , 'Texas'
        , 'US'
        );

INSERT INTO locations VALUES 
        ( 1500 
        , '2011 Interiors Blvd'
        , '99236'
        , 'South San Francisco'
        , 'California'
        , 'US'
        );

INSERT INTO locations VALUES 
        ( 1600 
        , '2007 Zagora St'
        , '50090'
        , 'South Brunswick'
        , 'New Jersey'
        , 'US'
        );

INSERT INTO locations VALUES 
        ( 1700 
        , '2004 Charade Rd'
        , '98199'
        , 'Seattle'
        , 'Washington'
        , 'US'
        );

INSERT INTO locations VALUES 
        ( 1800 
        , '147 Spadina Ave'
        , 'M5V 2L7'
        , 'Toronto'
        , 'Ontario'
        , 'CA'
        );

INSERT INTO locations VALUES 
        ( 1900 
        , '6092 Boxwood St'
        , 'YSW 9T2'
        , 'Whitehorse'
        , 'Yukon'
        , 'CA'
        );

INSERT INTO locations VALUES 
        ( 2000 
        , '40-5-12 Laogianggen'
        , '190518'
        , 'Beijing'
        , NULL
        , 'CN'
        );

INSERT INTO locations VALUES 
        ( 2100 
        , '1298 Vileparle (E)'
        , '490231'
        , 'Bombay'
        , 'Maharashtra'
        , 'IN'
        );

INSERT INTO locations VALUES 
        ( 2200 
        , '12-98 Victoria Street'
        , '2901'
        , 'Sydney'
        , 'New South Wales'
        , 'AU'
        );

INSERT INTO locations VALUES 
        ( 2300 
        , '198 Clementi North'
        , '540198'
        , 'Singapore'
        , NULL
        , 'SG'
        );

INSERT INTO locations VALUES 
        ( 2400 
        , '8204 Arthur St'
        , NULL
        , 'London'
        , NULL
        , 'UK'
        );

INSERT INTO locations VALUES 
        ( 2500 
        , 'Magdalen Centre, The Oxford Science Park'
        , 'OX9 9ZB'
        , 'Oxford'
        , 'Oxford'
        , 'UK'
        );

INSERT INTO locations VALUES 
        ( 2600 
        , '9702 Chester Road'
        , '09629850293'
        , 'Stretford'
        , 'Manchester'
        , 'UK'
        );

INSERT INTO locations VALUES 
        ( 2700 
        , 'Schwanthalerstr. 7031'
        , '80925'
        , 'Munich'
        , 'Bavaria'
        , 'DE'
        );

INSERT INTO locations VALUES 
        ( 2800 
        , 'Rua Frei Caneca 1360 '
        , '01307-002'
        , 'Sao Paulo'
        , 'Sao Paulo'
        , 'BR'
        );

INSERT INTO locations VALUES 
        ( 2900 
        , '20 Rue des Corps-Saints'
        , '1730'
        , 'Geneva'
        , 'Geneve'
        , 'CH'
        );

INSERT INTO locations VALUES 
        ( 3000 
        , 'Murtenstrasse 921'
        , '3095'
        , 'Bern'
        , 'BE'
        , 'CH'
        );

INSERT INTO locations VALUES 
        ( 3100 
        , 'Pieter Breughelstraat 837'
        , '3029SK'
        , 'Utrecht'
        , 'Utrecht'
        , 'NL'
        );

INSERT INTO locations VALUES 
        ( 3200 
        , 'Mariano Escobedo 9991'
        , '11932'
        , 'Mexico City'
        , 'Distrito Federal,'
        , 'MX'
        );


REM ****************************insert data into the DEPARTMENTS table

Prompt ******  Populating DEPARTMENTS table ....

REM disable integrity constraint to EMPLOYEES to load data

ALTER TABLE departments 
  DISABLE CONSTRAINT dept_mgr_fk;

INSERT INTO departments VALUES 
        ( 10
        , 'Administration'
        , 200
        , 1700
        );

INSERT INTO departments VALUES 
        ( 20
        , 'Marketing'
        , 201
        , 1800
        );
                                
INSERT INTO departments VALUES 
        ( 50
        , 'Shipping'
        , 124
        , 1500
        );
                
INSERT INTO departments VALUES 
        ( 60 
        , 'IT'
        , 103
        , 1400
        );
                              
INSERT INTO departments VALUES 
        ( 80 
        , 'Sales'
        , 149
        , 2500
        );
                
INSERT INTO departments VALUES 
        ( 90 
        , 'Executive'
        , 100
        , 1700
        );
               
INSERT INTO departments VALUES 
        ( 110 
        , 'Accounting'
        , 205
        , 1700
        );

INSERT INTO departments VALUES 
        ( 190 
        , 'Contracting'
        , NULL
        , 1700
        );

REM ***************************insert data into the EMPLOYEES table

Prompt ******  Populating EMPLOYEES table ....

INSERT INTO employees VALUES 
        ( 100
        , 'Steven'
        , 'King'
        , 'SKING'
        , '515.123.4567'
        , TO_DATE('17-JUN-1987', 'dd-MON-yyyy')
        , 'AD_PRES'
        , 24000
        , NULL
        , NULL
        , 90
        );

INSERT INTO employees VALUES 
        ( 101
        , 'Neena'
        , 'Kochhar'
        , 'NKOCHHAR'
        , '515.123.4568'
        , TO_DATE('21-SEP-1989', 'dd-MON-yyyy')
        , 'AD_VP'
        , 17000
        , NULL
        , 100
        , 90
        );

INSERT INTO employees VALUES 
        ( 102
        , 'Lex'
        , 'De Haan'
        , 'LDEHAAN'
        , '515.123.4569'
        , TO_DATE('13-JAN-1993', 'dd-MON-yyyy')
        , 'AD_VP'
        , 17000
        , NULL
        , 100
        , 90
        );

INSERT INTO employees VALUES 
        ( 103
        , 'Alexander'
        , 'Hunold'
        , 'AHUNOLD'
        , '590.423.4567'
        , TO_DATE('03-JAN-1990', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 9000
        , NULL
        , 102
        , 60
        );

INSERT INTO employees VALUES 
        ( 104
        , 'Bruce'
        , 'Ernst'
        , 'BERNST'
        , '590.423.4568'
        , TO_DATE('21-MAY-1991', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 6000
        , NULL
        , 103
        , 60
        );

INSERT INTO employees VALUES 
        ( 107
        , 'Diana'
        , 'Lorentz'
        , 'DLORENTZ'
        , '590.423.5567'
        , TO_DATE('07-FEB-1999', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 4200
        , NULL
        , 103
        , 60
        );

INSERT INTO employees VALUES 
        ( 124
        , 'Kevin'
        , 'Mourgos'
        , 'KMOURGOS'
        , '650.123.5234'
        , TO_DATE('16-NOV-1999', 'dd-MON-yyyy')
        , 'ST_MAN'
        , 5800
        , NULL
        , 100
        , 50
        );

INSERT INTO employees VALUES 
        ( 141
        , 'Trenna'
        , 'Rajs'
        , 'TRAJS'
        , '650.121.8009'
        , TO_DATE('17-OCT-1995', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 3500
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 142
        , 'Curtis'
        , 'Davies'
        , 'CDAVIES'
        , '650.121.2994'
        , TO_DATE('29-JAN-1997', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 3100
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 143
        , 'Randall'
        , 'Matos'
        , 'RMATOS'
        , '650.121.2874'
        , TO_DATE('15-MAR-1998', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 2600
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 144
        , 'Peter'
        , 'Vargas'
        , 'PVARGAS'
        , '650.121.2004'
        , TO_DATE('09-JUL-1998', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 2500
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 149
        , 'Eleni'
        , 'Zlotkey'
        , 'EZLOTKEY'
        , '011.44.1344.429018'
        , TO_DATE('29-JAN-2000', 'dd-MON-yyyy')
        , 'SA_MAN'
        , 10500
        , .2
        , 100
        , 80
        );

INSERT INTO employees VALUES 
        ( 174
        , 'Ellen'
        , 'Abel'
        , 'EABEL'
        , '011.44.1644.429267'
        , TO_DATE('11-MAY-1996', 'dd-MON-yyyy')
        , 'SA_REP'
        , 11000
        , .30
        , 149
        , 80
        );

INSERT INTO employees VALUES 
        ( 176
        , 'Jonathon'
        , 'Taylor'
        , 'JTAYLOR'
        , '011.44.1644.429265'
        , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
        , 'SA_REP'
        , 8600
        , .20
        , 149
        , 80
        );

INSERT INTO employees VALUES 
        ( 178
        , 'Kimberely'
        , 'Grant'
        , 'KGRANT'
        , '011.44.1644.429263'
        , TO_DATE('24-MAY-1999', 'dd-MON-yyyy')
        , 'SA_REP'
        , 7000
        , .15
        , 149
        , NULL
        );

INSERT INTO employees VALUES 
        ( 200
        , 'Jennifer'
        , 'Whalen'
        , 'JWHALEN'
        , '515.123.4444'
        , TO_DATE('17-SEP-1987', 'dd-MON-yyyy')
        , 'AD_ASST'
        , 4400
        , NULL
        , 101
        , 10
        );

INSERT INTO employees VALUES 
        ( 201
        , 'Michael'
        , 'Hartstein'
        , 'MHARTSTE'
        , '515.123.5555'
        , TO_DATE('17-FEB-1996', 'dd-MON-yyyy')
        , 'MK_MAN'
        , 13000
        , NULL
        , 100
        , 20
        );

INSERT INTO employees VALUES 
        ( 202
        , 'Pat'
        , 'Fay'
        , 'PFAY'
        , '603.123.6666'
        , TO_DATE('17-AUG-1997', 'dd-MON-yyyy')
        , 'MK_REP'
        , 6000
        , NULL
        , 201
        , 20
        );

INSERT INTO employees VALUES 
        ( 205
        , 'Shelley'
        , 'Higgins'
        , 'SHIGGINS'
        , '515.123.8080'
        , TO_DATE('07-JUN-1994', 'dd-MON-yyyy')
        , 'AC_MGR'
        , 12000
        , NULL
        , 101
        , 110
        );

INSERT INTO employees VALUES 
        ( 206
        , 'William'
        , 'Gietz'
        , 'WGIETZ'
        , '515.123.8181'
        , TO_DATE('07-JUN-1994', 'dd-MON-yyyy')
        , 'AC_ACCOUNT'
        , 8300
        , NULL
        , 205
        , 110
        );

REM ***************************insert data into the JOB_GRADES table

Prompt ******  Populating JOB_GRADES table ....

INSERT INTO job_grades VALUES 
	('A'
	,1000
	,2999
	);

INSERT INTO job_grades VALUES 
	('B'
	,3000
	,5999
	);

INSERT INTO job_grades VALUES 
	('C'
	,6000
	,9999
	);

INSERT INTO job_grades VALUES 
	('D'
	,10000
	,14999
	);

INSERT INTO job_grades VALUES 
	('E'
	,15000
	,24999
	);

INSERT INTO job_grades VALUES 
	('F'
	,25000
	,40000
	);

COMMIT;

REM enable integrity constraint to DEPARTMENTS

ALTER TABLE departments 
  ENABLE CONSTRAINT dept_mgr_fk;


REM  Creating table JOB_HISTORY and populating data

Prompt ******  Creating JOB_HISTORY table ....

CREATE TABLE job_history
    ( employee_id   NUMBER(6)
	 CONSTRAINT    jhist_employee_nn  NOT NULL
    , start_date    DATE
	CONSTRAINT    jhist_start_date_nn  NOT NULL
    , end_date      DATE
	CONSTRAINT    jhist_end_date_nn  NOT NULL
    , job_id        VARCHAR2(10)
	CONSTRAINT    jhist_job_nn  NOT NULL
    , department_id NUMBER(4)
    , CONSTRAINT    jhist_date_interval
                    CHECK (end_date > start_date)
    ) ;

CREATE UNIQUE INDEX jhist_emp_id_st_date_pk 
ON job_history (employee_id, start_date) ;

ALTER TABLE job_history
ADD ( CONSTRAINT jhist_emp_id_st_date_pk
      PRIMARY KEY (employee_id, start_date)
      , CONSTRAINT     jhist_dept_fk
                     FOREIGN KEY (department_id)
                     REFERENCES departments
    ) ;

Prompt ******  Populating JOB_HISTORY table ....


INSERT INTO job_history
VALUES (102
       , TO_DATE('13-JAN-1993', 'dd-MON-yyyy')
       , TO_DATE('24-JUL-1998', 'dd-MON-yyyy')
       , 'IT_PROG'
       , 60);

INSERT INTO job_history
VALUES (101
       , TO_DATE('21-SEP-1989', 'dd-MON-yyyy')
       , TO_DATE('27-OCT-1993', 'dd-MON-yyyy')
       , 'AC_ACCOUNT'
       , 110);

INSERT INTO job_history
VALUES (101
       , TO_DATE('28-OCT-1993', 'dd-MON-yyyy')
       , TO_DATE('15-MAR-1997', 'dd-MON-yyyy')
       , 'AC_MGR'
       , 110);

INSERT INTO job_history
VALUES (201
       , TO_DATE('17-FEB-1996', 'dd-MON-yyyy')
       , TO_DATE('19-DEC-1999', 'dd-MON-yyyy')
       , 'MK_REP'
       , 20);

INSERT INTO job_history
VALUES  (114
        , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1999', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 50
        );

INSERT INTO job_history
VALUES  (122
        , TO_DATE('01-JAN-1999', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1999', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 50
        );

INSERT INTO job_history
VALUES  (200
        , TO_DATE('17-SEP-1987', 'dd-MON-yyyy')
        , TO_DATE('17-JUN-1993', 'dd-MON-yyyy')
        , 'AD_ASST'
        , 90
        );

INSERT INTO job_history
VALUES  (176
        , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1998', 'dd-MON-yyyy')
        , 'SA_REP'
        , 80
        );

INSERT INTO job_history
VALUES  (176
        , TO_DATE('01-JAN-1999', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1999', 'dd-MON-yyyy')
        , 'SA_MAN'
        , 80
        );

INSERT INTO job_history
VALUES  (200
        , TO_DATE('01-JUL-1994', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1998', 'dd-MON-yyyy')
        , 'AC_ACCOUNT'
        , 90
        );

COMMIT;









Rem
Rem    This PART will create indexes for DEMO schema
Rem

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
--SET TRIMSPOOL ON
--SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF 

CREATE INDEX emp_department_ix
       ON employees (department_id);

CREATE INDEX emp_job_ix
       ON employees (job_id);

CREATE INDEX emp_manager_ix
       ON employees (manager_id);

CREATE INDEX emp_name_ix
       ON employees (last_name, first_name);

CREATE INDEX dept_location_ix
       ON departments (location_id);

CREATE INDEX loc_city_ix
       ON locations (city);

CREATE INDEX loc_state_province_ix	
       ON locations (state_province);

CREATE INDEX loc_country_ix
       ON locations (country_id);

Rem
Rem    This PART will create comments for DEMO schema
Rem

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
--SET TRIMSPOOL ON
--SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF 

REM *********************************************

COMMENT ON TABLE countries
IS 'country table. Contains 25 rows. References with locations table.';

COMMENT ON COLUMN countries.country_id
IS 'Primary key of countries table.';

COMMENT ON COLUMN countries.country_name
IS 'Country name';

COMMENT ON COLUMN countries.region_id
IS 'Region ID for the country'; 

REM *********************************************

COMMENT ON TABLE locations
IS 'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. Contains 23 rows; references with the
departments and countries tables. ';

COMMENT ON COLUMN locations.location_id
IS 'Primary key of locations table';

COMMENT ON COLUMN locations.street_address
IS 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';

COMMENT ON COLUMN locations.postal_code
IS 'Postal code of the location of an office, warehouse, or production site 
of a company. ';

COMMENT ON COLUMN locations.city
IS 'A not null column that shows city where an office, warehouse, or 
production site of a company is located. ';

COMMENT ON COLUMN locations.state_province
IS 'State or Province where an office, warehouse, or production site of a 
company is located.';

COMMENT ON COLUMN locations.country_id
IS 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';


REM *********************************************

COMMENT ON TABLE departments
IS 'Departments table that shows details of departments where employees 
work. Contains 27 rows; references with locations, employees, and job_history tables.';

COMMENT ON COLUMN departments.department_id
IS 'Primary key column of departments table.';

COMMENT ON COLUMN departments.department_name
IS 'A not null column that shows name of a department. Administration, 
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public 
Relations, Sales, Finance, and Accounting. ';

COMMENT ON COLUMN departments.manager_id
IS 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.';

COMMENT ON COLUMN departments.location_id
IS 'Location id where a department is located. Foreign key to location_id column of locations table.';


REM *********************************************

COMMENT ON TABLE employees
IS 'employees table. Contains 107 rows. References with departments, 
jobs, job_history tables. Contains a self reference.';

COMMENT ON COLUMN employees.employee_id
IS 'Primary key of employees table.';

COMMENT ON COLUMN employees.first_name
IS 'First name of the employee. A not null column.';

COMMENT ON COLUMN employees.last_name
IS 'Last name of the employee. A not null column.';

COMMENT ON COLUMN employees.email
IS 'Email id of the employee';

COMMENT ON COLUMN employees.phone_number
IS 'Phone number of the employee; includes country code and area code';

COMMENT ON COLUMN employees.hire_date
IS 'Date when the employee started on this job. A not null column.';

COMMENT ON COLUMN employees.job_id
IS 'Current job of the employee; foreign key to job_id column of the 
jobs table. A not null column.';

COMMENT ON COLUMN employees.salary
IS 'Monthly salary of the employee. Must be greater 
than zero (enforced by constraint emp_salary_min)';

COMMENT ON COLUMN employees.commission_pct
IS 'Commission percentage of the employee; Only employees in sales 
department elgible for commission percentage';

COMMENT ON COLUMN employees.manager_id
IS 'Manager id of the employee; has same domain as manager_id in 
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';

COMMENT ON COLUMN employees.department_id
IS 'Department id where employee works; foreign key to department_id 
column of the departments table';

COMMIT;


create table jobs(job_id varchar2(10) constraint jobs_job_id_nn NOT NULL, job_title varchar2(35) constraint jobs_job_title_nn NOT NULL,min_salary number(6), max_salary number(6));
alter table jobs add (constraint jobs_j_id_pk primary key (job_id));


insert into jobs values('AD_PRES','President',20000,40000);
insert into jobs values('AD_VP','Administration Vice President',15000,30000);
insert into jobs values('AD_ASST','Administration Assistant',3000,6000);
insert into jobs values('AC_MGR','Accounting Manager',8200,16000);
insert into jobs values('AC_ACCOUNT','Public_Accountant',4200,9000);
insert into jobs values('SA_MAN','Sales_Manager',10000,20000);
insert into jobs values('SA_REP','Sales_Representative',6000,12000);
insert into jobs values('ST_CLERK','Stock Clerk',2000,5000);
insert into jobs values('IT_PROG','Programmer',4000,10000);
insert into jobs values('MK_MAN','Marketing Manager',9000,15000);
insert into jobs values('MK_REP','Marketing Representative',4000,9000);
insert into jobs values('ST_MAN','Stock Manager',5500,8500);

COMMIT;


REM INSERTING into PRODUCT_CATEGORIES
SET DEFINE OFF;
Insert into PRODUCT_CATEGORIES (CATEGORY_ID,CATEGORY_NAME) values (1,'CPU');
Insert into PRODUCT_CATEGORIES (CATEGORY_ID,CATEGORY_NAME) values (2,'Video Card');
Insert into PRODUCT_CATEGORIES (CATEGORY_ID,CATEGORY_NAME) values (3,'RAM');
Insert into PRODUCT_CATEGORIES (CATEGORY_ID,CATEGORY_NAME) values (4,'Mother Board');
Insert into PRODUCT_CATEGORIES (CATEGORY_ID,CATEGORY_NAME) values (5,'Storage');

COMMIT;

REM INSERTING into PRODUCTS
SET DEFINE OFF;
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (228,'Intel Xeon E5-2699 V3 (OEM/Tray)','Speed:2.3GHz,Cores:18,TDP:145W',2867.51,3410.46,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (248,'Intel Xeon E5-2697 V3','Speed:2.6GHz,Cores:14,TDP:145W',2326.27,2774.98,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (249,'Intel Xeon E5-2698 V3 (OEM/Tray)','Speed:2.3GHz,Cores:16,TDP:135W',2035.18,2660.72,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (2,'Intel Xeon E5-2697 V4','Speed:2.3GHz,Cores:18,TDP:145W',2144.4,2554.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (45,'Intel Xeon E5-2685 V3 (OEM/Tray)','Speed:2.6GHz,Cores:12,TDP:120W',2012.11,2501.69,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (46,'Intel Xeon E5-2695 V3 (OEM/Tray)','Speed:2.3GHz,Cores:14,TDP:120W',1925.13,2431.95,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (47,'Intel Xeon E5-2697 V2','Speed:2.7GHz,Cores:12,TDP:130W',2101.59,2377.09,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (51,'Intel Xeon E5-2695 V4','Speed:2.1GHz,Cores:18,TDP:120W',1780.35,2269.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (91,'Intel Xeon E5-2695 V2','Speed:2.4GHz,Cores:12,TDP:115W',1793.53,2259.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (92,'Intel Xeon E5-2643 V2 (OEM/Tray)','Speed:3.5GHz,Cores:6,TDP:130W',1940.18,2200,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (93,'Intel Xeon E5-2690 (OEM/Tray)','Speed:2.9GHz,Cores:8,TDP:135W',1888.33,2116.72,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (98,'Intel Xeon E5-2687W V3','Speed:3.1GHz,Cores:10,TDP:160W',1781.47,2064.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (102,'Intel Xeon E5-2687W V4','Speed:3.0GHz,Cores:12,TDP:160W',1723.83,2042.69,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (158,'Intel Xeon E5-2667 V3 (OEM/Tray)','Speed:3.2GHz,Cores:8,TDP:135W',1504.08,2009.46,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (159,'Intel Xeon E5-2690 V4','Speed:2.6GHz,Cores:14,TDP:135W',1499.26,1994.49,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (160,'Intel Xeon E5-2690 V3','Speed:2.6GHz,Cores:12,TDP:135W',1540.35,1908.73,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (162,'Intel Xeon E5-2470V2','Speed:2.4GHz,Cores:10,TDP:95W',1671.95,1904.7,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (163,'Intel Xeon E5-2683 V4','Speed:2.1GHz,Cores:16,TDP:120W',1706.95,1899.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (164,'Intel Xeon E5-2637 V2 (OEM/Tray)','Speed:3.5GHz,Cores:4,TDP:130W',1323.12,1850,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (169,'Intel Xeon E5-2683 V4 (OEM/Tray)','Speed:2.1GHz,Cores:16,TDP:120W',1369.83,1844.89,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (240,'Intel Core i7-4960X Extreme Edition','Speed:3.6GHz,Cores:6,TDP:130W',1496.43,1805.97,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (241,'Intel Xeon E5-2699 V4 (OEM/Tray)','Speed:2.2GHz,Cores:22,TDP:145W',1535.62,1756,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (242,'Intel Xeon E5-1680 V3 (OEM/Tray)','Speed:3.2GHz,Cores:8,TDP:140W',1519.85,1751.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (243,'Intel Xeon E5-2643 V4 (OEM/Tray)','Speed:3.4GHz,Cores:6,TDP:135W',1225.59,1708.86,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (19,'Intel Core i7-6950X (OEM/Tray)','Speed:3.0GHz,Cores:10,TDP:140W',1479.56,1704.37,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (52,'Intel Xeon E5-2670 V3','Speed:2.3GHz,Cores:12,TDP:120W',1453.94,1676.98,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (165,'Intel Xeon E5-2680','Speed:2.7GHz,Cores:8,TDP:130W',1479.95,1666.61,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (212,'Intel Xeon E5-2680 V4','Speed:2.4GHz,Cores:14,TDP:120W',1365.13,1639.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (166,'Intel Xeon E5-2680 V3 (OEM/Tray)','Speed:2.5GHz,Cores:12,TDP:120W',1166.89,1638.89,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (82,'Intel Core i7-6950X','Speed:3.0GHz,Cores:10,TDP:140W',1052.92,1499.89,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (213,'Intel Xeon E5-2643 V3 (OEM/Tray)','Speed:3.4GHz,Cores:6,TDP:135W',1266.37,1469.96,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (218,'Intel Xeon E5-2660 V4','Speed:2.0GHz,Cores:14,TDP:105W',1194.03,1388.89,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (219,'Intel Xeon E5-2660 V3','Speed:2.6GHz,Cores:10,TDP:105W',1041.99,1299.73,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (85,'Intel Xeon E5-2660 V3 (OEM/Tray)','Speed:2.6GHz,Cores:10,TDP:105W',902.18,1274.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (153,'Intel Xeon E5-2650 V2','Speed:2.6GHz,Cores:8,TDP:95W',961.11,1249,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (154,'Intel Xeon E5-2650 V3','Speed:2.3GHz,Cores:10,TDP:105W',906.63,1204.98,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (209,'Intel Core i7-990X Extreme Edition','Speed:3.47GHz,Cores:6,TDP:130W',1072.79,1199.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (81,'Intel Xeon E5-2650 V4','Speed:2.2GHz,Cores:12,TDP:105W',945.11,1099.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (211,'Intel Xeon E5-2650','Speed:2.0GHz,Cores:8,TDP:95W',869.03,1064.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (210,'Intel Core i9-7900X','Speed:3.3GHz,Cores:10,TDP:140W',855.82,1029.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (54,'Intel Xeon E5-1660 V3 (OEM/Tray)','Speed:3.0GHz,Cores:8,TDP:140W',914.52,1019.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (167,'Intel Xeon E5-2650L V3 (OEM/Tray)','Speed:1.8GHz,Cores:12,TDP:65W',779.17,1010.46,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (214,'Intel Core i7-5960X','Speed:3.0GHz,Cores:8,TDP:140W',865.59,1009.79,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (53,'Intel Core 2 Extreme QX6800','Speed:2.93GHz,Cores:4,TDP:100W',787.72,1003.98,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (59,'Intel Core i7-5960X (OEM/Tray)','Speed:3.0GHz,Cores:8,TDP:140W',879.8,977.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (176,'Intel Xeon E5-2650 V3 (OEM/Tray)','Speed:2.3GHz,Cores:10,TDP:105W',799.98,939.49,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (9,'Intel Xeon E5-2640 V4','Speed:2.4GHz,Cores:10,TDP:90W',738.71,899.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (119,'Intel Xeon E5-2640 V3','Speed:2.6GHz,Cores:8,TDP:90W',668.24,899.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (120,'Intel Core 2 Extreme QX9775','Speed:3.2GHz,Cores:4,TDP:150W',737.68,892,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (16,'Intel Core i7-6900K','Speed:3.2GHz,Cores:8,TDP:140W',792.89,889.89,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (111,'Intel Core i7-6900K (OEM/Tray)','Speed:3.2GHz,Cores:8,TDP:140W',620.28,827.37,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (136,'AMD Opteron 6378','Speed:2.4GHz,Cores:16,TDP:115W',651.92,826.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (27,'Intel Core i7-3960X Extreme Edition','Speed:3.3GHz,Cores:6,TDP:130W',573.41,800.74,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (73,'Intel Core i7-4770K','Speed:3.5GHz,Cores:4,TDP:84W',714.15,799,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (70,'Intel Xeon E5-2687W','Speed:3.1GHz,Cores:8,TDP:150W',581.16,710.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (74,'Intel Xeon E5-2680 V2','Speed:2.8GHz,Cores:10,TDP:115W',567.81,701.95,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (198,'Intel Core i7-980','Speed:3.33GHz,Cores:6,TDP:130W',563.7,699.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (69,'Intel Core i7-7820X','Speed:3.6GHz,Cores:8,TDP:140W',511.1,678.75,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (71,'Intel Core i7-3930K','Speed:3.2GHz,Cores:6,TDP:130W',509.32,660,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (199,'Intel Xeon E5-2630 V4','Speed:2.2GHz,Cores:10,TDP:85W',528.95,647.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (76,'Intel Xeon E5-2630 V3','Speed:2.4GHz,Cores:8,TDP:85W',499.96,629.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (75,'Intel Core i7-4930K','Speed:3.4GHz,Cores:6,TDP:130W',527.69,624.04,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (200,'Intel Core i7-4790K','Speed:4.0GHz,Cores:4,TDP:88W',461.92,620.95,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (106,'Intel Xeon E5-2640 V2','Speed:2.0GHz,Cores:8,TDP:95W',545.19,608.95,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (8,'Intel Xeon E5-1650 V4','Speed:3.6GHz,Cores:6,TDP:140W',535.47,601.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (124,'Intel Xeon E5-1650 V4 (OEM/Tray)','Speed:3.6GHz,Cores:6,TDP:140W',453.14,594.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (72,'Intel Xeon E5-2630 V3 (OEM/Tray)','Speed:2.4GHz,Cores:8,TDP:85W',421.9,589.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (155,'Intel Xeon E5-2630 V2','Speed:2.6GHz,Cores:6,TDP:80W',493.48,588.95,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (80,'Intel Xeon E5-1650 V3','Speed:3.5GHz,Cores:6,TDP:140W',399.77,564.89,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (132,'Intel Core i7-5930K','Speed:3.5GHz,Cores:6,TDP:140W',481.56,554.99,1);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (133,'PNY VCQP6000-PB','Chipset:Quadro P6000,Memory:24GBCore Clock:1.42GHz',4058.99,5499.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (206,'PNY VCQM6000-24GB-PB','Chipset:Quadro M6000,Memory:24GBCore Clock:988MHz',3619.14,4139,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (207,'PNY VCQM6000-PB','Chipset:Quadro M6000,Memory:12GBCore Clock:988MHz',2505.04,3254.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (110,'ATI FirePro W9000','Chipset:FirePro W9000,Memory:6GBCore Clock:975MHz',2785.55,3192.97,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (123,'ATI FirePro S9150','Chipset:FirePro S9150,Memory:16GBCore Clock:900MHz',2628.06,3177.44,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (142,'AMD FirePro W9100','Chipset:FirePro W9100,Memory:16GBCore Clock:930MHz',2483.38,2998.89,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (105,'EVGA 12G-P4-3992-KR','Chipset:GeForce GTX Titan Z,Memory:12GBCore Clock:732MHz',2313.07,2799.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (4,'AMD 100-505989','Chipset:FirePro W9100,Memory:32GBCore Clock:930MHz',2128.67,2699.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (5,'PNY VCQK6000-PB','Chipset:Quadro K6000,Memory:12GBCore Clock:902MHz',1740.31,2290.79,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (11,'PNY VCQP5000-PB','Chipset:Quadro P5000,Memory:16GBCore Clock:1.61GHz',1602.21,2015.11,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (178,'HP C2J95AT','Chipset:Quadro K5000,Memory:4GBCore Clock:706MHz',1715.91,1999.89,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (267,'EVGA 12G-P4-1999-KR','Chipset:GeForce GTX Titan X,Memory:12GBCore Clock:1.15GHz',1328.03,1799.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (177,'PNY VCQM5000-PB','Chipset:Quadro M5000,Memory:8GBCore Clock:861MHz',1268.42,1759.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (245,'ATI FirePro S9050','Chipset:FirePro S9050,Memory:12GBCore Clock:900MHz',1237.04,1699,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (161,'AMD 100-5056062','Chipset:Vega Frontier Edition Liquid,Memory:16GBCore Clock:1.5GHz',1343.84,1499.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (186,'PNY VCQK5200-PB','Chipset:Quadro K5200,Memory:8GBCore Clock:667MHz',1129.39,1449.98,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (48,'AMD FirePro S7000','Chipset:FirePro S7000,Memory:4GBCore Clock:950MHz',936.42,1218.5,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (184,'AMD 100-506061','Chipset:Vega Frontier Edition,Memory:16GBCore Clock:1.44GHz',706.99,999.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (181,'ATI FirePro R5000','Chipset:FirePro R5000,Memory:2GBCore Clock:825MHz',760.59,999.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (182,'PNY VCQK4200-PB','Chipset:Quadro K4200,Memory:4GBCore Clock:771MHz',799.05,949.89,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (183,'Asus GTX780TI-3GD5','Chipset:GeForce GTX 780 Ti,Memory:3GBCore Clock:876MHz',781.91,899.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (185,'MSI GTX 1080 TI LIGHTNING Z','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.61GHz',688.35,873.98,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (281,'Asus ROG-POSEIDON-GTX1080TI-P11G-GAMING','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.62GHz',696.14,864.98,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (216,'MSI GTX 1080 TI LIGHTNING X','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.57GHz',742.94,863.98,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (6,'Zotac ZT-P10810A-10P','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.48GHz',702.35,849.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (108,'MSI GAMING','Chipset:GeForce GTX 780 Ti,Memory:3GBCore Clock:1.02GHz',753.18,849.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (83,'Asus STRIX-GTX1080TI-O11G-GAMING','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.57GHz',691.13,829.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (215,'PNY VCQP4000-PB','Chipset:Quadro P4000,Memory:8GBCore Clock:1.23GHz',724,829.89,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (12,'Gigabyte GV-N108TAORUSX W-11GD','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.63GHz',596.05,824.98,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (114,'Zotac ZT-70203-10P','Chipset:GeForce GTX 780,Memory:3GBCore Clock:1.01GHz',580.42,820.61,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (103,'EVGA 11G-P4-6598-KR','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.56GHz',663.54,809.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (86,'MSI GTX 1080 TI SEA HAWK X','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.57GHz',691.32,804.98,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (3,'Corsair CB-9060011-WW','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.57GHz',573.51,799.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (174,'MSI GTX 1080 TI AERO 11G OC','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.51GHz',715.72,798.26,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (175,'NVIDIA VCQM4000-PB','Chipset:Quadro M4000,Memory:8GBCore Clock:N/A',682.09,790,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (58,'Gigabyte GV-N108TAORUS X-11GD','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.61GHz',688.35,784.98,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (270,'Gigabyte GV-N1070WF2OC-8GD','Chipset:GeForce GTX 1070,Memory:8GBCore Clock:1.56GHz',551.62,769.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (223,'MSI GeForce GTX 1080 TI ARMOR 11G OC','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.48GHz',644.19,764.98,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (90,'EVGA 11G-P4-6696-KR','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.56GHz',594.46,759.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (220,'MSI GeForce GTX 1080 Ti GAMING X 11G','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.57GHz',666.59,759.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (221,'Zotac ZT-P10810C-10P','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.65GHz',535.03,759.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (269,'Zotac ZT-P10810D-10P','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.57GHz',580.1,759.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (87,'PNY VCGGTX1080T11XGPB-OC','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.53GHz',600.92,759.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (222,'Zotac ZT-P10810G-10P','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.51GHz',598.25,754.98,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (88,'Gigabyte GV-N98TWF3OC-6GD','Chipset:GeForce GTX 980 Ti,Memory:6GBCore Clock:1.06GHz',633.29,749.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (89,'PNY VCGGTX780T3XPB-OC','Chipset:GeForce GTX 780 Ti,Memory:3GBCore Clock:980MHz',592.12,749.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (236,'MSI GTX 980 Ti Gaming 6G','Chipset:GeForce GTX 980 Ti,Memory:6GBCore Clock:1.18GHz',539.98,745.32,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (237,'Gigabyte GV-N108TAORUS-11GD','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.59GHz',605.3,744.98,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (238,'EVGA 06G-P4-4998-KR','Chipset:GeForce GTX 980 Ti,Memory:6GBCore Clock:1.19GHz',521.03,741.78,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (239,'MSI GTX 1080 Ti DUKE 11G OC','Chipset:GeForce GTX 1080 Ti,Memory:11GBCore Clock:1.53GHz',555.07,739.99,2);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (244,'Crucial','Speed:DDR4-2133,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',1139.23,1620.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (261,'G.Skill TridentZ RGB','Speed:DDR4-3200,Type:288-pin DIMM,CAS:14Module:8x16GBSize:128GB',1330.26,1504.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (262,'Corsair Dominator Platinum','Speed:DDR4-3200,Type:288-pin DIMM,CAS:16Module:8x16GBSize:128GB',1051.97,1449.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (265,'G.Skill Trident Z','Speed:DDR4-3200,Type:288-pin DIMM,CAS:14Module:8x16GBSize:128GB',1163.49,1431.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (266,'G.Skill Trident Z RGB','Speed:DDR4-3333,Type:288-pin DIMM,CAS:16Module:8x16GBSize:128GB',1174.36,1418.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (279,'G.Skill Ripjaws V Series','Speed:DDR4-3000,Type:288-pin DIMM,CAS:14Module:8x16GBSize:128GB',1139.87,1318.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (35,'Corsair Dominator Platinum','Speed:DDR4-2800,Type:288-pin DIMM,CAS:15Module:8x16GBSize:128GB',1131.68,1314.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (36,'Corsair Vengeance LPX','Speed:DDR4-3000,Type:288-pin DIMM,CAS:15Module:8x16GBSize:128GB',912.98,1299.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (37,'Corsair Dominator Platinum','Speed:DDR4-2666,Type:288-pin DIMM,CAS:15Module:8x16GBSize:128GB',1068.66,1264.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (38,'Corsair Vengeance LPX','Speed:DDR4-2400,Type:288-pin DIMM,CAS:15Module:8x16GBSize:128GB',1019.51,1199.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (65,'Corsair Dominator Platinum','Speed:DDR4-2400,Type:288-pin DIMM,CAS:15Module:8x16GBSize:128GB',1002.47,1199.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (276,'Corsair Vengeance LPX','Speed:DDR4-2666,Type:288-pin DIMM,CAS:15Module:8x16GBSize:128GB',867.52,1163.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (196,'Corsair Vengeance LPX','Speed:DDR4-2133,Type:288-pin DIMM,CAS:15Module:8x16GBSize:128GB',821.91,1099.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (272,'G.Skill Ripjaws 4 Series','Speed:DDR4-2800,Type:288-pin DIMM,CAS:15Module:8x16GBSize:128GB',834.06,1073.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (195,'G.Skill Ripjaws 4 Series','Speed:DDR4-2400,Type:288-pin DIMM,CAS:14Module:8x16GBSize:128GB',836.03,1055.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (67,'Kingston HyperX Beast','Speed:DDR3-1866,Type:240-pin DIMM,CAS:10Module:8x8GBSize:64GB',708.91,863.05,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (10,'Crucial','Speed:DDR4-2133,Type:288-pin DIMM,CAS:15Module:2x16GBSize:32GB',580.33,811.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (112,'Corsair Vengeance Pro','Speed:DDR3-2133,Type:240-pin DIMM,CAS:11Module:8x8GBSize:64GB',596.25,808.92,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (282,'Corsair Dominator Platinum','Speed:DDR4-3200,Type:288-pin DIMM,CAS:15Module:8x8GBSize:64GB',700.5,804.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (197,'G.Skill Trident Z RGB','Speed:DDR4-3600,Type:288-pin DIMM,CAS:17Module:4x16GBSize:64GB',622.47,799.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (18,'Crucial','Speed:DDR4-2400,Type:288-pin DIMM,CAS:17Module:1x64GBSize:64GB',604.04,799,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (125,'G.Skill Trident Z','Speed:DDR4-3600,Type:288-pin DIMM,CAS:17Module:4x16GBSize:64GB',594.04,768.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (68,'Crucial','Speed:DDR4-2133,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',590.13,766.11,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (283,'G.Skill Trident Z','Speed:DDR4-3200,Type:288-pin DIMM,CAS:14Module:8x8GBSize:64GB',647.83,760.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (277,'G.Skill Trident Z','Speed:DDR4-3200,Type:288-pin DIMM,CAS:14Module:8x8GBSize:64GB',556.8,758.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (21,'Corsair Dominator Platinum','Speed:DDR4-3466,Type:288-pin DIMM,CAS:16Module:4x16GBSize:64GB',609.89,749.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (128,'Kingston','Speed:DDR4-2133,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',650.48,741.63,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (129,'Corsair Vengeance LPX','Speed:DDR4-3333,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',609.53,734.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (116,'G.Skill Trident Z','Speed:DDR4-3400,Type:288-pin DIMM,CAS:16Module:4x16GBSize:64GB',565.39,731.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (15,'G.Skill Trident Z','Speed:DDR4-3466,Type:288-pin DIMM,CAS:16Module:4x16GBSize:64GB',601.56,725.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (122,'G.Skill Trident Z','Speed:DDR4-3333,Type:288-pin DIMM,CAS:16Module:4x16GBSize:64GB',532.27,722.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (121,'G.Skill Ripjaws V Series','Speed:DDR4-3200,Type:288-pin DIMM,CAS:14Module:8x8GBSize:64GB',603.22,721.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (20,'Corsair Dominator Platinum','Speed:DDR4-3200,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',616.53,719.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (127,'Corsair Dominator Platinum','Speed:DDR4-3333,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',538.55,719.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (109,'G.Skill Trident Z','Speed:DDR4-3200,Type:288-pin DIMM,CAS:14Module:4x16GBSize:64GB',585.26,713.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (202,'G.Skill Trident Z','Speed:DDR4-3200,Type:288-pin DIMM,CAS:14Module:4x16GBSize:64GB',533.21,713.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (113,'G.Skill Trident Z','Speed:DDR4-3200,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',580.21,704.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (13,'G.Skill Ripjaws V Series','Speed:DDR4-3333,Type:288-pin DIMM,CAS:16Module:4x16GBSize:64GB',618.63,704.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (14,'G.Skill Ripjaws V Series','Speed:DDR4-3333,Type:288-pin DIMM,CAS:16Module:4x16GBSize:64GB',633.65,704.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (115,'Corsair Vengeance LPX','Speed:DDR4-3200,Type:288-pin DIMM,CAS:15Module:8x8GBSize:64GB',565.73,699.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (118,'Corsair Dominator Platinum','Speed:DDR4-2800,Type:288-pin DIMM,CAS:15Module:8x8GBSize:64GB',578.46,699.89,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (17,'Corsair Vengeance LPX','Speed:DDR4-3333,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',595.42,699.01,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (117,'G.Skill Ripjaws V Series','Speed:DDR4-3200,Type:288-pin DIMM,CAS:14Module:4x16GBSize:64GB',617.62,695.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (77,'G.Skill Ripjaws V Series','Speed:DDR4-3200,Type:288-pin DIMM,CAS:14Module:4x16GBSize:64GB',577.25,695.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (78,'G.Skill Ripjaws V Series','Speed:DDR4-3200,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',517.78,686.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (204,'G.Skill Ripjaws V Series','Speed:DDR4-3200,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',546.64,686.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (7,'G.Skill Ripjaws V Series','Speed:DDR4-3200,Type:288-pin DIMM,CAS:15Module:8x8GBSize:64GB',602.4,680.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (278,'G.Skill Ripjaws V Series','Speed:DDR4-3000,Type:288-pin DIMM,CAS:14Module:8x8GBSize:64GB',546.05,677.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (203,'Kingston','Speed:DDR3-1333,Type:240-pin DIMM,CAS:9Module:4x16GBSize:64GB',556.84,671.38,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (79,'Corsair Dominator Platinum','Speed:DDR4-2666,Type:288-pin DIMM,CAS:15Module:8x8GBSize:64GB',537.63,659.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (201,'Kingston','Speed:DDR3-1600,Type:240-pin DIMM,CAS:11Module:4x8GBSize:32GB',566.98,653.5,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (205,'G.Skill Trident X','Speed:DDR3-3100,Type:240-pin DIMM,CAS:12Module:2x4GBSize:8GB',507.32,649.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (29,'Corsair Vengeance LPX','Speed:DDR4-3200,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',571.7,645.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (138,'G.Skill Ripjaws V Series','Speed:DDR4-3000,Type:288-pin DIMM,CAS:14Module:4x16GBSize:64GB',499.09,645.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (30,'G.Skill Ripjaws V Series','Speed:DDR4-2800,Type:288-pin DIMM,CAS:14Module:4x16GBSize:64GB',452.54,645.2,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (107,'Kingston','Speed:DDR3-1600,Type:240-pin DIMM,CAS:11Module:4x16GBSize:64GB',474.18,644,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (126,'G.Skill Ripjaws V Series','Speed:DDR4-3200,Type:288-pin DIMM,CAS:16Module:8x8GBSize:64GB',510.93,640.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (1,'G.Skill Ripjaws V Series','Speed:DDR4-3000,Type:288-pin DIMM,CAS:15Module:8x8GBSize:64GB',450.36,640.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (101,'Kingston HyperX Predator','Speed:DDR4-3000,Type:288-pin DIMM,CAS:15Module:4x16GBSize:64GB',471.78,635.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (190,'Supermicro X10SDV-8C-TLN4F','CPU:Xeon D-1541,Form Factor:Mini ITX,RAM Slots:4,Max RAM:64GB',664.29,948.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (62,'Intel DP35DPM','CPU:LGA775,Form Factor:ATX,RAM Slots:4,Max RAM:8GB',626.22,789.79,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (189,'Asus X99-E-10G WS','CPU:LGA2011-3,Form Factor:SSI CEB,RAM Slots:8,Max RAM:128GB',582.02,649,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (191,'Asus ROG MAXIMUS IX EXTREME','CPU:LGA1151,Form Factor:EATX,RAM Slots:4,Max RAM:64GB',480.89,573.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (63,'Asus RAMPAGE V EXTREME','CPU:LGA2011-3,Form Factor:EATX,RAM Slots:8,Max RAM:64GB',459,572.96,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (193,'Asus Z10PE-D8 WS','CPU:LGA2011-3 x 2,Form Factor:SSI EEB,RAM Slots:8,Max RAM:512GB',504.14,561.59,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (271,'MSI X99A GODLIKE GAMING CARBON','CPU:LGA2011-3,Form Factor:EATX,RAM Slots:8,Max RAM:128GB',415,549.59,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (64,'Supermicro H8DG6-F','CPU:G34 x 2,Form Factor:EATX,RAM Slots:16,Max RAM:512GB',416.64,525.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (192,'Asus Rampage V Edition 10','CPU:LGA2011-3,Form Factor:EATX,RAM Slots:8,Max RAM:128GB',452.5,519.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (225,'Gigabyte GA-Z270X-Gaming 9','CPU:LGA1151,Form Factor:EATX,RAM Slots:4,Max RAM:64GB',380.05,503.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (252,'Gigabyte X299 AORUS Gaming 9','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',395.24,499.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (274,'ASRock E3C224D4M-16RE','CPU:LGA1150,Form Factor:ATX,RAM Slots:4,Max RAM:32GB',364.79,499.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (61,'Asus PRIME X299-DELUXE','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',409.92,487.3,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (188,'Asus X99-E WS/USB 3.1','CPU:LGA2011-3,Form Factor:SSI CEB,RAM Slots:8,Max RAM:128GB',428.89,482.49,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (28,'Supermicro X9SRH-7TF','CPU:LGA2011,Form Factor:ATX,RAM Slots:8,Max RAM:64GB',411.64,479.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (137,'Asus Z10PE-D16 WS','CPU:LGA2011-3 x 2,Form Factor:SSI EEB,RAM Slots:16,Max RAM:1TB',332.52,469.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (32,'ASRock X99 Extreme11','CPU:LGA2011-3,Form Factor:EATX,RAM Slots:8,Max RAM:128GB',380.55,469.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (31,'Supermicro MBD-X10DAX','CPU:LGA2011-3 x 2,Form Factor:EATX,RAM Slots:16,Max RAM:',385.24,443.72,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (84,'Asus X99-DELUXE/U3.1','CPU:LGA2011-3,Form Factor:ATX,RAM Slots:8,Max RAM:64GB',332.38,440.3,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (141,'Supermicro X11SSL-CF','CPU:LGA1151,Form Factor:Micro ATX,RAM Slots:4,Max RAM:64GB',317.81,419.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (34,'Asus KGPE-D16','CPU:G34 x 2,Form Factor:SSI EEB,RAM Slots:16,Max RAM:256GB',360.72,417.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (143,'Asus Z10PE-D16','CPU:LGA2011-3 Narrow x 2,Form Factor:SSI EEB,RAM Slots:16,Max RAM:1TB',293.3,402.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (217,'ASRock C2750D4I','CPU:Atom C2750,Form Factor:Mini ITX,RAM Slots:4,Max RAM:64GB',339.55,401.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (66,'Gigabyte X299 AORUS Gaming 7','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',283.91,399.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (275,'MSI X99A GODLIKE GAMING','CPU:LGA2011-3,Form Factor:EATX,RAM Slots:8,Max RAM:128GB',302.95,399.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (194,'MSI X299 GAMING M7 ACK','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',278.71,397.42,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (156,'Supermicro MBD-X10DRI-O','CPU:LGA2011-3 Narrow x 2,Form Factor:EATX,RAM Slots:16,Max RAM:1TB',291.34,394.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (157,'Asus MAXIMUS IX FORMULA','CPU:LGA1151,Form Factor:ATX,RAM Slots:4,Max RAM:64GB',339.12,388.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (170,'Asus X99-DELUXE II','CPU:LGA2011-3,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',289.33,383.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (171,'ASRock Fatal1ty X299 Professional Gaming i9','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',287.5,382.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (172,'ASRock EP2C612 WS','CPU:LGA2011-3 x 2,Form Factor:SSI EEB,RAM Slots:8,Max RAM:',308.84,358.49,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (173,'ASRock Z270 SuperCarrier','CPU:LGA1151,Form Factor:ATX,RAM Slots:4,Max RAM:64GB',264.35,353.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (187,'Asus MAXIMUS VIII EXTREME/ASSEMBLY','CPU:LGA1151,Form Factor:EATX,RAM Slots:4,Max RAM:64GB',253.41,353.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (224,'Asus STRIX X299-E GAMING','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',306,349.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (246,'Gigabyte X299 AORUS Ultra Gaming','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',287.78,343.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (247,'Asus TUF X299 MARK 1','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',241.15,339.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (250,'Asus Z170-WS','CPU:LGA1151,Form Factor:ATX,RAM Slots:4,Max RAM:64GB',279.4,338.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (251,'MSI X299 GAMING PRO CARBON AC','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',238.8,337.81,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (287,'MSI X99A XPOWER GAMING TITANIUM','CPU:LGA2011-3,Form Factor:EATX,RAM Slots:8,Max RAM:128GB',257.23,329.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (288,'Asus ROG STRIX X99 GAMING','CPU:LGA2011-3,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',255.86,319.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (179,'Asus SABERTOOTH X99','CPU:LGA2011-3,Form Factor:ATX,RAM Slots:8,Max RAM:64GB',252.57,312.67,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (226,'Asus PRIME X299-A','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',274.56,309.85,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (227,'Gigabyte GA-X99-UD5 WIFI','CPU:LGA2011-3,Form Factor:EATX,RAM Slots:8,Max RAM:64GB',217.83,305,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (39,'ASRock EP2C602-4L/D16','CPU:LGA2011 x 2,Form Factor:SSI EEB,RAM Slots:16,Max RAM:512GB',225.47,301.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (40,'MSI Z170A KRAIT GAMING 3X','CPU:LGA1151,Form Factor:ATX,RAM Slots:4,Max RAM:64GB',245.4,299.89,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (41,'MSI Z170 Krait Gaming','CPU:LGA1151,Form Factor:ATX,RAM Slots:4,Max RAM:64GB',231.58,299.89,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (42,'MSI Z170A KRAIT GAMING','CPU:LGA1151,Form Factor:ATX,RAM Slots:4,Max RAM:64GB',262.4,299.89,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (43,'Asus MAXIMUS IX CODE','CPU:LGA1151,Form Factor:ATX,RAM Slots:4,Max RAM:64GB',266.15,298.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (134,'Asus Sabertooth 990FX','CPU:AM3+,Form Factor:ATX,RAM Slots:4,Max RAM:32GB',252.31,295.72,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (140,'MSI X99A WORKSTATION','CPU:LGA2011-3,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',239.95,289.97,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (144,'Intel DG43RK','CPU:LGA775,Form Factor:Micro ATX,RAM Slots:4,Max RAM:8GB',219.69,289.79,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (145,'Asus VANGUARD B85','CPU:LGA1150,Form Factor:Micro ATX,RAM Slots:4,Max RAM:32GB',258.1,287,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (146,'EVGA Z270 Classified K','CPU:LGA1151,Form Factor:EATX,RAM Slots:4,Max RAM:64GB',234.26,283.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (147,'EVGA Classified','CPU:LGA2011-3,Form Factor:EATX,RAM Slots:8,Max RAM:128GB',240.62,283.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (148,'MSI Z270 XPOWER GAMING TITANIUM','CPU:LGA1151,Form Factor:ATX,RAM Slots:4,Max RAM:64GB',212.69,282.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (149,'ASRock X299 Taichi','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',214.36,282.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (150,'MSI X299 TOMAHAWK ARCTIC','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',223.92,281.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (151,'Supermicro X10SAT-O','CPU:LGA1150,Form Factor:ATX,RAM Slots:4,Max RAM:32GB',207.08,281.97,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (152,'Gigabyte X299 AORUS Gaming 3','CPU:LGA2066,Form Factor:ATX,RAM Slots:8,Max RAM:128GB',227.48,280.98,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (180,'Supermicro MBD-X10DAL-I-O','CPU:LGA2011-3 x 2,Form Factor:ATX,RAM Slots:8,Max RAM:512GB',239.28,279.99,4);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (268,'Western Digital WD10EZEX','Series:Caviar Blue,Type:7200RPM,Capacity:1TB,Cache:64MB',35.83,47.88,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (24,'Seagate ST2000DM006','Series:Barracuda,Type:7200RPM,Capacity:2TB,Cache:64MB',47.93,66.89,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (25,'Samsung MZ-75E250B/AM','Series:850 EVO-Series,Type:SSD,Capacity:250GB,Cache:N/A',87.98,104.88,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (26,'Samsung MZ-75E500B/AM','Series:850 EVO-Series,Type:SSD,Capacity:500GB,Cache:N/A',157.81,178.09,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (104,'SanDisk SDSSDA-240G-G26','Series:SSD PLUS,Type:SSD,Capacity:240GB,Cache:N/A',61.1,83.88,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (135,'Samsung MZ-V6E250','Series:960 EVO,Type:SSD,Capacity:250GB,Cache:512MB',92.98,127.88,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (284,'Kingston SA400S37/120G','Series:A400,Type:SSD,Capacity:120GB,Cache:N/A',40.63,54.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (285,'Samsung MZ-75E1T0B/AM','Series:850 EVO-Series,Type:SSD,Capacity:1TB,Cache:N/A',260.23,339.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (286,'Samsung MZ-V6E500','Series:960 EVO,Type:SSD,Capacity:500GB,Cache:512MB',209.62,234,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (22,'Seagate ST3000DM008','Series:Barracuda,Type:7200RPM,Capacity:3TB,Cache:64MB',61.63,83.61,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (23,'Western Digital WDS250G1B0A','Series:Blue,Type:SSD,Capacity:250GB,Cache:N/A',72.54,89.89,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (33,'ADATA ASU800SS-128GT-C','Series:Ultimate SU800,Type:SSD,Capacity:128GB,Cache:N/A',37.78,52.65,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (44,'Seagate ST1000DM010','Series:BarraCuda,Type:7200RPM,Capacity:1TB,Cache:64MB',42.18,49.37,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (49,'Samsung MZ-75E4T0B','Series:850 EVO,Type:SSD,Capacity:4TB,Cache:4GB',1153.64,1499.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (50,'Intel SSDPECME040T401','Series:DC P3608,Type:SSD,Capacity:4TB,Cache:N/A',7123.66,8867.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (130,'Western Digital WD2003FZEX','Series:BLACK SERIES,Type:7200RPM,Capacity:2TB,Cache:64MB',91.76,117.45,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (131,'Samsung MZ-V6P512BW','Series:960 PRO,Type:SSD,Capacity:512GB,Cache:512MB',223.99,279.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (139,'Hitachi HUS724030ALE641','Series:Ultrastar 7K4000,Type:7200RPM,Capacity:3TB,Cache:64MB',54.03,65.92,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (208,'Samsung MZ-V6P2T0BW','Series:960 Pro,Type:SSD,Capacity:2TB,Cache:2GB',840.11,1199.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (229,'Seagate ST10000DM0004','Series:BarraCuda Pro,Type:7200RPM,Capacity:10TB,Cache:256MB',284.23,399.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (230,'ADATA ASU800SS-512GT-C','Series:Ultimate SU800,Type:SSD,Capacity:512GB,Cache:N/A',113.29,136.69,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (231,'Samsung MZ-V6E1T0','Series:960 EVO,Type:SSD,Capacity:1TB,Cache:1000MB',358.06,449.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (232,'Western Digital WD1003FZEX','Series:BLACK SERIES,Type:7200RPM,Capacity:1TB,Cache:64MB',61.76,70.89,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (233,'SanDisk SDSSDA-120G-G26','Series:SSD PLUS,Type:SSD,Capacity:120GB,Cache:N/A',52.7,59.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (234,'Crucial CT525MX300SSD1','Series:MX300,Type:SSD,Capacity:525GB,Cache:N/A',135.59,150.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (235,'Hitachi A7K1000-1000','Series:Ultrastar,Type:7200RPM,Capacity:1TB,Cache:32MB',29.94,41.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (253,'Samsung MZ-V6P1T0BW','Series:960 Pro,Type:SSD,Capacity:1TB,Cache:1GB',466.49,579.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (254,'Samsung MZ-7KE256BW','Series:850 Pro Series,Type:SSD,Capacity:256GB,Cache:N/A',97.19,119.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (255,'Seagate ST2000DX002','Series:FireCuda,Type:Hybrid,Capacity:2TB,Cache:64MB',64.48,90.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (256,'Western Digital WD5000AACS','Series:Caviar Green,Type:5400RPM,Capacity:500GB,Cache:16MB',20.14,26.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (257,'SanDisk SDSSDHII-240G-G25','Series:Ultra II,Type:SSD,Capacity:240GB,Cache:N/A',73.39,84.95,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (258,'PNY SSD7CS1311-120-RB','Series:CS1311,Type:SSD,Capacity:120GB,Cache:N/A',50.59,57.98,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (259,'PNY SSD9SC240GMDA-RB','Series:XLR8,Type:SSD,Capacity:240GB,Cache:N/A',58.4,80.72,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (260,'Crucial CT1050MX300SSD1','Series:MX300,Type:SSD,Capacity:1.1TB,Cache:N/A',192.52,267.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (263,'Western Digital WDS250G1B0B','Series:Blue,Type:SSD,Capacity:250GB,Cache:N/A',70.71,89.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (264,'Samsung MZ-75E120B/AM','Series:850 EVO-Series,Type:SSD,Capacity:120GB,Cache:N/A',74.41,88.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (280,'Western Digital WDS500G1B0B','Series:Blue,Type:SSD,Capacity:500GB,Cache:N/A',106.89,149.88,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (60,'Hitachi HUA723020ALA640','Series:Ultrastar 7K3000,Type:7200RPM,Capacity:2TB,Cache:64MB',45.18,59.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (94,'Western Digital WD2500AVVS','Series:AV-GP,Type:5400RPM,Capacity:250GB,Cache:8MB',12.63,15.55,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (99,'Seagate ST1000DX002','Series:FireCuda,Type:Hybrid,Capacity:1TB,Cache:64MB',55.41,68.06,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (100,'Crucial CT275MX300SSD1','Series:MX300,Type:SSD,Capacity:275GB,Cache:N/A',79.21,97.88,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (168,'Seagate ST31000340NS - FFP','Series:Barracuda ES,Type:7200RPM,Capacity:1TB,Cache:32MB',34.4,43.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (273,'Western Digital WD101KRYZ','Series:Gold,Type:7200RPM,Capacity:10TB,Cache:256MB',313.96,443.64,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (55,'Crucial CT525MX300SSD4','Series:MX300,Type:SSD,Capacity:525GB,Cache:N/A',121.92,150.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (56,'Western Digital WD2500AAJS','Series:Caviar Blue,Type:7200RPM,Capacity:250GB,Cache:8MB',15.23,16.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (57,'Western Digital WD20EZRZ','Series:Blue,Type:5400RPM,Capacity:2TB,Cache:64MB',58.01,67.34,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (95,'Western Digital WDS256G1X0C','Series:Black PCIe,Type:SSD,Capacity:256GB,Cache:N/A',85.87,109.99,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (96,'SanDisk SDSSDHII-480G-G25','Series:Ultra II,Type:SSD,Capacity:480GB,Cache:N/A',102.62,141.56,5);
Insert into PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE,CATEGORY_ID) values (97,'Kingston SV300S37A/120G','Series:SSDNow V300 Series,Type:SSD,Capacity:120GB,Cache:N/A',45.93,59.87,5);

COMMIT;

REM INSERTING into WAREHOUSES
SET DEFINE OFF;
Insert into WAREHOUSES (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) values (1,'W1',1000);
Insert into WAREHOUSES (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) values (2,'W2',1100);
Insert into WAREHOUSES (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) values (3,'W3',1200);
Insert into WAREHOUSES (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) values (4,'W4',1300);
Insert into WAREHOUSES (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) values (5,'W5',1400);
Insert into WAREHOUSES (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) values (6,'W6',1500);
Insert into WAREHOUSES (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) values (7,'W7',1600);
Insert into WAREHOUSES (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) values (8,'W8',1700);
Insert into WAREHOUSES (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) values (9,'W9',1800);
