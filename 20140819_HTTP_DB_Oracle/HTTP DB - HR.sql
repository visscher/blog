-- Create a stored procedure which will return some details from an employee.
CREATE OR REPLACE
PROCEDURE get_name(
    p_id        IN  employees.employee_id%TYPE,
    p_firstname OUT employees.first_name%TYPE,
    p_lastname  OUT employees.last_name%TYPE )
AS
BEGIN
  SELECT first_name,
    last_name
  INTO p_firstname,
    p_lastname
  FROM employees
  WHERE employee_id = p_id;
END;
/
--
-- Grant the correct permission to the webservice user.
grant execute on get_name to webservice;
-- Show WSDL: http://localhost:8080/orawsv/HR/GET_NAME?wsdl
-- Note: StorProc / Package names are always in UpperCase.
--
-- Run in SOAPUI (Don't forget to set username / pass)
--
--
--
-------------------------------------------------------------------------
-- Test case 2: Create a more complex return type                      --
-------------------------------------------------------------------------
--
--
-- Create a stored procedure which will return all employees which are found
-- Please notice the OUT type and check the updated wsdl.
--
--
CREATE OR REPLACE TYPE phone_list_typ AS VARRAY(5) OF VARCHAR2(25);
/
CREATE OR REPLACE TYPE cust_address_typ
AS
  OBJECT
  (
    street_address VARCHAR2(40) ,
    postal_code    VARCHAR2(10) ,
    city           VARCHAR2(30) ,
    state_province VARCHAR2(10) ,
    country_id     CHAR(2) ,
    phone          phone_list_typ );
  /
CREATE OR REPLACE TYPE customer_typ
AS
  OBJECT
  (
    customer_id     NUMBER(6) ,
    cust_first_name VARCHAR2(20) ,
    cust_last_name  VARCHAR2(20) ,
    cust_address    CUST_ADDRESS_TYP ,
    phone_numbers   PHONE_LIST_TYP ,
    nls_language    VARCHAR2(3) ,
    nls_territory   VARCHAR2(30) ,
    credit_limit    NUMBER(9,2) ,
    cust_email      VARCHAR2(30) ) ;
  /
  --
  -- Create a dummy procedure with the customer_typ output
CREATE OR REPLACE
PROCEDURE getcustomeronid(
    p_id        IN  NUMBER,
    p_customer  OUT customer_typ)
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('test');
END;
/
--
-- Grant the execution to the correct user.
GRANT EXECUTE ON getcustomeronid TO webservice;
/
-- http://localhost:8080/orawsv/HR/GETCUSTOMERONID?wsdl
