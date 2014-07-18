nfldata
=======

The are two series of MapReduce programs.  One is a series of programs to extract and normalize the data.  The second is a simple program to look at incomplete passes.  

The play by play dataaset can be found at http://www.advancednflstats.com/2010/04/play-by-play-data.html.   

ETL Series
==========

This program takes the play by play dataset and merges it with other datasets like arrests, stadiums and weather.   

Set things up by running the setup.sh script or run the following steps manually:   
Run the PlayByPlayDriver on the play by data data.   
Run the ArrestJoinDriver on the data from PlayByPlayDriver. (place in HDFS under joinedoutput)      
Put the stadiums.csv in HDFS in a directory called stadium.      
Put the 173328.csv in HDFS in a directory called weather.      
In Hive, run playbyplay_tablecreate.hql.    
In Hive, run playbyplay_join.hql.   
In Hive, run adddrives.hql.   
In Hive, run adddriveresult.hql.   
Query and have fun!   
See the queries in queries.hql for some examples of how and what to query.   

Incomplete Passes
=================

Simple MapReduce on NFL play by play data.  This program focuses on incomplete passes and which receiver they were throw to.  See http://www.jesse-anderson.com/2013/01/nfl-play-by-play-analysis/ for the resulting charts.

Play Search
===========

Based on merged dataset from above ETL Series. Data is parsed using Morphlines and indexed using MapReduceIndexerTool. 

Setup the play search by editing & running the setupsearch.sh script. Script should work with no changes on quickstart VM. Otherwise you will need to fill env variables for ZK ensemble and base directories. 

