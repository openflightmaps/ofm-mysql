# Services and service instances
The ofm database contains services and each of those services contains many service instances.

As of 20180318

## Services in the ofm database
Table: S1T

ID|Name|Description|Status
---|---|---|---
1|ION originative suite|Client Software update Service|In Use
2|OAD Private Workspace|all Private Workspace stuff as coordinate notations etc.|Deprecated
3|OAD Pending Changes|Public OFM Aeronautical Data|In Use
4|OAD Static Data|Static OFM Data such as borders|In Use
5|Documents Libary|Stored AIP Libraries|In Use
6|AIS map design|0|Stored Design Sets of AIS_contributor|In Use
7|CFE definition file|Common Format Export Definitions (e.g. open air file export scheme ...)|In Use
8|Map Regions|Defines Mapsectors to be related with Organizations|In Use
9|OAD AIRAC Buffer|Buffer for Airac changes| to be committed and checked before each airac date|Deprecated

## Service properties
Table: S2T

ID|Description|Type
---|---|---
1|next Merge Date|5
2|pending Submissions|2
3|last Merge Date|5

## Service instance properties
Table: S3T

ID|Description|Type|Multiple use|Description
---|---|---|---|---
0|Flight Information Region|2|0
1|Last Pending Submission|5|0
2|Data Entity|6|1
3|PDF Attachment|6|0
4|Executable File Client|6|0
5|Executable File Updater|6|0
6|Version|2|0
7|Effective|5|0
8|valid|5|0
9|Built|2|0
10|Comment File|6|0
11|User|3|0
12|Designator|3|0
13|Datestamp|5|0
14|Appproval Date|5|0
15|Approved|7|0
16|Approved By User|3|0
17|Type|3|0
18|Coordinate Notation|3|0
19|Data Log Entry|3|1
20|ICAO|4|1
21|Document Reference|4|0
22|AIPSection_1AD_2ENR_3GEN_4OTHER|2|0
23|Revision|2|0
24|CurrentVersion|7|0
25|locked|2|0
26|Page Nbr|2|0
27|xml|3|0
28|rtf|3|0
29|geoReferencedImage|6|0
30|geoReferenceMapping|3|0
31|typeOfDocument_0pdf_1gri|2|0
32|binary|6|0
33|file storage location|3|0
34|geo frame|3|0
35|sectionFrameXml|3|0
36|lastCommitMsg|3|0
37|Executable File Client x64|6|0
38|Executable File Client Beta|6|0
39|Executable File Client Beta x64|6|0
40|Built Beta|2|0
41|beta tester msg|3|0
42|lookup values|3|0
43|image|6|1|
45|epsgRasterTilePath|3|0|
46|Bounding Box|4|0|format: `left,bottom,right,top` e.g. `5.123,45.78,10.876,47.650`

# Service instances
Table: S4

This table contains the main records of the ofm database
