# The below script generates a report which includes read and write capacity units for all DynamoDB tables. 
# This could be useful if your AWS account has many DynamoDB tables and you need a quick way to check the read/write capacity units. 
# If you don't have too many tables created in your account, then checking capacity units through AWS console should be easier.

export_path=~/dynamo_cap.csv
touch $export_path
echo "Table Name, Write Cap, Read Cap" >>$export_path
tables=$(aws dynamodb list-tables --region us-west-2 | grep ',')
for table in $tables; do
  table_name=$(echo $table | sed 's/\,//g; s/\"//g')
  res=$(aws dynamodb describe-table --table-name $table_name --region us-west-2 | grep 'ReadCapacityUnits\|WriteCapacityUnits')
  write_cap=$(cut -d',' -f1 <<<$res)
  read_cap=$(cut -d',' -f2 <<<$res)
  write_cap_val=$(cut -d':' -f2 <<<$write_cap)
  read_cap_val=$(cut -d':' -f2 <<<$read_cap)
  echo $table_name,$write_cap_val,$read_cap_val >>$export_path
done
