function connection = func_Dbconnector()
%FUNC_DBCONNECTOR Summary of this function goes here
%   This function connect to database and return the open connection as
%   output

dbname = 'nerofuzzysplicingfeaturesdb';
username = 'root';
password = 'as@hn6162';
driver = 'com.mysql.jdbc.Driver';
dburl = ['jdbc:mysql://localhost:3306/' dbname];

%javaclasspath('path-to-mysql-connector\mysql-connector-java-VERSION-bin.jar');

connection = database(dbname, username, password, driver, dburl);

return

