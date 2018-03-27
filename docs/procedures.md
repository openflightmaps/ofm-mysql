# User Management
## checkUserExists
```
CREATE FUNCTION `checkUserExists`(un VARCHAR(100), pw VARCHAR(100)) RETURNS tinyint(1)
```
### Arguments
* `un` Username
* `pw` Password

### Results
* `RETURNS` 1 = user exists, 0 = user doesn't exist

API Alternative: `GET /info/userinfo`

## getUserId
```
CREATE FUNCTION `getUserId`(un VARCHAR(100), pw VARCHAR(100)) RETURNS int(11)
```
### Arguments
* `un` Username
* `pw` Password

### Results
* `RETURNS` userid

API Alternative: `GET /info/userinfo`

## Others
```
CREATE PROCEDURE `SetLanguagePreference`(In pw VARCHAR(20), IN Un VARCHAR(50), IN LanguageID INT(11))
```

# Services
## DeleteInheritedService
```
CREATE PROCEDURE `DeleteInheritedService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN InhServId INT)
```
### Arguments
* `un` Username
* `pw` Password
* `InhServId` Inherited Service Id

### Results
* ??? TODO

API Alternative: `DELETE /node/{db}/{id}`

## GetServiceEntityRevision
```
CREATE PROCEDURE `GetServiceEntityRevision`(IN EntityID INT)
```
### Arguments
* `EntityID` Service Entity ID

### Results
* `Revision` Service Entity Revision

API Alternative: ??? TODO

## GetServiceRevision
```
CREATE PROCEDURE `GetServiceRevision`(In pw VARCHAR(20), IN Un VARCHAR(50),IN AnyID INT, IN Service1_ServiceEntity2 INT)
```
### Arguments
* `pw` Password
* `Un` Username
* `AnyID` ??? TODO
* `Service1_ServiceEntity2` ??? TODO

### Results
* ??? TODO

API Alternative: `GET /node/{db}/{id}` / field `_rev`

## InheritService
```
CREATE PROCEDURE `InheritService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN ServiceID INT, IN OrgID INT, IN IsPublic INT, IN InSearchTag VARCHAR(200))
```
### Arguments
* `Un` Username
* `pw` Password
* `ServiceID` Service ID
* `OrgID` Organisation ID
* `IsPublic` IsPublic ??? TODO
* `InSearchTag` SearchTag ??? TODO

### Results
* ??? TODO

API Alternative: `POST /node/{db}/_create`

## QueryTable
```
CREATE PROCEDURE `QueryTable`(In Un VARCHAR(50), IN Pw VARCHAR(50), IN TableName VARCHAR(10), IN AnyID INT(11), IN AnyID2 INT(11), IN AnyValue VARCHAR(500))
```
### Arguments
* `Un` Username
* `Pw` Password
* `TableName` Table Name (e.g. S3A1)
* `AnyID` ??? TODO
* `AnyID2` ??? TODO
* `AnyValue` ??? TODO

### Results
* ??? TODO

API Alternative: `POST /node/{db}/_search`

## SetBinary
```
CREATE PROCEDURE `SetBinary`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), PropertyID INT(11), IN BL LONGBLOB, OrgID INT(11), IN oldRef VARCHAR(20), IN ServiceIsPublic INT)
```
### Arguments
* `pw` Password
* `Un` Username
* `TableName` Password
* `PropertyID` Property ID
* `BL` Binary Data
* `OrgID` ??? TODO
* `oldRef` ??? TODO
* `ServiceIsPublic` ??? TODO

### Results
* ??? TODO

API Alternative: `PUT /blobstore/_create`

## UpdateProperty
```
CREATE PROCEDURE `UpdateProperty`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PropertyID INT(11), IN Value MEDIUMTEXT CHARSET utf8, IN anyId INT(11), AddReplace1_Add2_Delete3 INT(11), IN oldValue MEDIUMTEXT, IN ServiceIsPublic INT)
```
### Arguments
* `pw` Password
* `Un` Username
* `TableName` Password
* `PropertyID` Property ID
* `Value` Value
* `anyId` ??? TODO
* `AddReplace1_Add2_Delete3` 1=Replace, 2=Add, 3=Delete
* `oldValue` Previous Value
* `ServiceIsPublic` ??? TODO

### Results
* ??? TODO

API Alternative: `PATCH /node/{db}/{id}`

## UpdateService
```
CREATE PROCEDURE `UpdateService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN ServiceID INT, IN ServiceEntityId_ INT, IN OrgID INT, IN IsPublic INT, IN InSearchTag VARCHAR(200))
```
Description: Updates the search tag on the Service

* `pw` Password
* `Un` Username
* `ServiceID` Service ID
* `ServiceEntityId` Service Entity ID
* `OrgID` ??? TODO
* `IsPublic` ??? TODO
* `InSearchTag` ??? TODO

### Results
* ??? TODO

API Alternative: `PATCH /node/{db}/{id}`

# Organization Management
## UpdateOrganization
```
CREATE PROCEDURE `UpdateOrganization`(In pw VARCHAR(20), IN Un VARCHAR(50), IN OrgName VARCHAR(100), Add1_Delete2 INT(11))
```

# Permission Management
```
CREATE PROCEDURE `UpdatePermission`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PermissionID INT(11), IN StartValidity VARCHAR(30), IN EndValidity VARCHAR(30), IN OrgID INT(11), IN ServiceID INT(11), IN RemovePermission BOOL)
```

# Spatial Index
```
CREATE PROCEDURE `ammnt_addSpatialIndex`(IN entityId INT, IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE)
```
```
CREATE PROCEDURE `ammnt_addSpatialIndexEffectiveDate`(IN un VARCHAR(100), in pw VARCHAR(100), IN fir INT, IN branchId INT, IN revisionId INT, IN type VARCHAR(100), IN name longtext, IN commitMsg VARCHAR(50000), IN entityId INT, IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective dateTime, in validUntil dateTime)
```
```
CREATE PROCEDURE `ammnt_deleteSpatialIndex`(IN entityId INT)
```
```
CREATE PROCEDURE `getSpatialIndexChangesOfDates`(IN un VARCHAR(100), in pw VARCHAR(100), IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective datetime, in validUntil datetime)
```
```
CREATE PROCEDURE `getSpatialIndexTilesChangedOfDates`(IN un VARCHAR(100), in pw VARCHAR(100), IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective datetime, in validUntil datetime)
```

# Query
```
CREATE PROCEDURE `ammnt_queryTableFirSpatial`(in tablename varchar(10), in serviceid int, in firid int, in propertyid int,IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE)
```
```
CREATE PROCEDURE `ammnt_queryTableFir`(in tablename varchar(10), in serviceid int, in firid int, in propertyid int)
```

# Other - Non-standard
```
CREATE PROCEDURE `ammnt_AddFirAmmnt`(IN Tablename varchar(10), IN ServEntityID INT, IN Fir_Id INT, parentServId INT)
```
```
CREATE PROCEDURE `ammnt_GetFirRevision`(In pw VARCHAR(20), IN Un VARCHAR(50),IN Fid INT)
```
```
CREATE PROCEDURE `ammnt_GetNumberOfTodaysCommits`(In pw VARCHAR(20), IN Un VARCHAR(50),IN ServID INT)
```

# Deprecated PROCEDURES
```
CREATE PROCEDURE `UpdateLangTransEntity`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PropertyID INT(11), IN Value VARCHAR(1000), IN LanguageID INT(11))
CREATE PROCEDURE `execQuery`(IN qry VARCHAR(20000))
CREATE PROCEDURE `ammnt_AddActivityDataRecord`(In pw VARCHAR(20), IN Un VARCHAR(50), IN record longtext, IN Login TIMESTAMP, IN Logout TIMESTAMP, IN activeMinutes INT)
CREATE PROCEDURE `ammnt_GetUserActivity`(In Pw VARCHAR(50), IN Un VARCHAR(50), IN StartDate DATE, IN EndDate DATE)
CREATE PROCEDURE `ammnt_IdentifyOadServiceEntity`(IN Designator VARCHAR(100), IN DataType VARCHAR(100), IN FirID INT)
```
