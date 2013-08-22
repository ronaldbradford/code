################################################################################
# Name     :  audit_schemas.sql
# Purpose  :  List details of the specific schema
# Author   :  Ronald Bradford  http://ronaldbradford.com
# Version  :  2 03-June-2009
################################################################################

# One Line Schema Summary
SELECT   table_schema,
         ROUND(SUM(data_length+index_length)/1024/1024,2) AS total_mb,
         ROUND(SUM(data_length)/1024/1024,2) AS data_mb,
         ROUND(SUM(index_length)/1024/1024,2) AS index_mb,
         COUNT(*) AS tables,
         CURDATE() AS today
FROM     information_schema.tables
WHERE    table_schema NOT IN ('mysql','information_schema','performance_schema','ps_helper')
GROUP BY table_schema
ORDER BY 2 DESC;
