#!/bin/bash

echo "Setting up env"
export SOLR_ZK_ENSEMBLE=localhost:2181/solr
export BASE_DIR=/home/cloudera/workspace/nfldata
export PROJECT_HOME=$BASE_DIR/nflsearch
export CLOUDERA_SEARCH_MR_PATH=/opt/cloudera/parcels/SOLR-1.1.0-1.cdh4.3.0.p0.21/lib/solr/contrib/mr/search-mr*-job.jar
export HDFS_AUTHORITY=localhost
export COLLECTION_NAME=NFL-Collection
#/usr/lib/solr/contrib/mr/search-mr-1.0.0-job.jar 

#/opt/cloudera/parcels/SOLR-1.1.0-1.cdh4.3.0.p0.21/lib/solr/contrib/mr/search-mr*-job.jar

echo "Cleanup any old configs"
{
 	solrctl --zk $SOLR_ZK_ENSEMBLE instancedir --delete $COLLECTION_NAME
	solrctl --zk $SOLR_ZK_ENSEMBLE collection --delete $COLLECTION_NAME
	rm -rf $PROJECT_HOME
}
echo "Setup config directory"
solrctl  instancedir --generate $PROJECT_HOME
cp $BASE_DIR/schema.xml $PROJECT_HOME/conf/schema.xml
cp $BASE_DIR/log4j.properties $PROJECT_HOME/log4j.properties


solrctl --zk $SOLR_ZK_ENSEMBLE instancedir --create $COLLECTION_NAME $PROJECT_HOME
solrctl --zk $SOLR_ZK_ENSEMBLE collection --create $COLLECTION_NAME -s 1

#hadoop jar /opt/cloudera/parcels/SOLR-1.1.0-1.cdh4.3.0.p0.21/lib/solr/contrib/mr/search-mr*-job.jar org.apache.solr.hadoop.MapReduceIndexerTool -D 'mapred.child.java.opts=-Xmx500m' --log4j $PROJECT_HOME/log4j.properties --morphline-file $BASE_DIR/nflmorphlines.conf --output-dir hdfs://localhost:8020/user/cloudera/nflsearchdata/ --verbose --go-live --zk-host localhost:2181/solr --collection $COLLECTION_NAME --dry-run hdfs://localhost:8020/user/hive/warehouse/playbyplay/

hadoop jar $CLOUDERA_SEARCH_MR_PATH org.apache.solr.hadoop.MapReduceIndexerTool -D 'mapred.child.java.opts=-Xmx500m' --log4j $PROJECT_HOME/log4j.properties --morphline-file $BASE_DIR/nflmorphlines.conf --output-dir hdfs://$HDFS_AUTHORITY/user/cloudera/nflsearchdata/ --verbose --go-live --zk-host $SOLR_ZK_ENSEMBLE --collection $COLLECTION_NAME hdfs://$HDFS_AUTHORITY/user/hive/warehouse/playbyplay/
