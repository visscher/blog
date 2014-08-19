-- http://www.oracle-base.com/articles/11g/native-oracle-xml-db-web-services-11gr1.php
--
-- See if the http servlet is already configured.
-- No rows will be shown if it is not!
SELECT dbms_xdb.gethttpport
FROM dual;
--
-- Set the port on which our servlet will be listening.
-- Please remember to map this port in your VM as well.
EXEC dbms_xdb.sethttpport(8080);
--
-- Configure the ORAWSV Servlet
  DECLARE
    l_servlet_name VARCHAR2(32) := 'orawsv';
  BEGIN
    DBMS_XDB.deleteServletMapping(l_servlet_name);
    DBMS_XDB.deleteServlet(l_servlet_name);
    DBMS_XDB.addServlet( name => l_servlet_name, language => 'C', dispname => 'Oracle Query Web Service', descript => 'Servlet for issuing queries as a Web Service', schema => 'XDB');
    DBMS_XDB.addServletSecRole( servname => l_servlet_name, rolename => 'XDB_WEBSERVICES', rolelink => 'XDB_WEBSERVICES');
    DBMS_XDB.addServletMapping( pattern => '/orawsv/*', name => l_servlet_name);
  END;
  /
--
-- Create user which will be used for the webservice calls.
CREATE USER webservice IDENTIFIED BY mypassword QUOTA UNLIMITED ON users;
-- Grant privileges to the user
GRANT CONNECT, CREATE TABLE, CREATE PROCEDURE TO webservice;
GRANT XDB_WEBSERVICES TO webservice;
GRANT XDB_WEBSERVICES_OVER_HTTP TO webservice;
-- GRANT XDB_WEBSERVICES_WITH_PUBLIC TO webservice;
--
-- That's it for SYS!
-- Let's look at the HR scheme now.

GRANT ALL PRIVILEGES TO webservice;
