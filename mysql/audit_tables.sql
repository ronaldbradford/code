################################################################################
# Name     :  audit.sql
# Purpose  :  List details of the specific schema
# Author   :  Ronald Bradford  http://ronaldbradford.com
# Version  :  August 22, 2013
################################################################################
SELECT   table_schema, 
         table_name,
         engine,
         row_format AS format, 
         table_rows, 
         avg_row_length AS avg_row,
         ROUND((data_length+index_length)/1024/1024,2) AS total_mb, 
         ROUND((data_length)/1024/1024,2) AS data_mb, 
         ROUND((index_length)/1024/1024,2) AS index_mb,
         CURDATE() AS today
FROM     information_schema.tables 
WHERE    table_schema NOT IN ('mysql','information_schema','performance_schema','ps_helper')
ORDER BY 7 DESC;
