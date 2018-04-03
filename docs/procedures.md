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
** Deprecated: G1T, G2T, G5T, XXL (translations),
** Others: U1T, U2T, U3T, O1T, S5T, S3T, S1T, U2AX, O1AX, U1_O1A, P1A, S4, S3X
* `AnyID` First query value: (e.g. ServiceEntityPropertyType)
* `AnyID2` 2nd query value (e.g. ServiceEntityID)
* `AnyValue` Search Tag

### Results
* ??? TODO

API Alternatives: 
*`POST /node/{db}/_search`
*`GET /info/regions`


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

### Arguments
* `pw` Password
* `Un` Username
* `ServiceID` Service ID
* `ServiceEntityId` Service Entity ID
* `OrgID` ??? TODO
* `IsPublic` ??? TODO
* `InSearchTag` ??? TODO

### Results
* ??? TODO

### Authentication: ??? Admin/ValidUser
API Alternative: `PATCH /node/{db}/{id}`

# Organization Management
## UpdateOrganization
```
CREATE PROCEDURE `UpdateOrganization`(In pw VARCHAR(20), IN Un VARCHAR(50), IN OrgName VARCHAR(100), Add1_Delete2 INT(11))
```
Description: Add or delete an Organization

### Arguments
* `pw` Password
* `Un` Username
* `OrgName` Organization name
* `Add1_Delete2` 1=Add, 2=Delete

### Results
* ??? TODO

### Authentication: ??? Admin/ValidUser
### API Alternatives: 
`PUT /org/_create`
`DELETE /org/{id}`


# Permission Management
```
CREATE PROCEDURE `UpdatePermission`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PermissionID INT(11), IN StartValidity VARCHAR(30), IN EndValidity VARCHAR(30), IN OrgID INT(11), IN ServiceID INT(11), IN RemovePermission BOOL)
```
Description: Add, update or delete a Permission

### Arguments
* `pw` Password
* `Un` Username
* TODO

### Results
* ??? TODO

### Authentication: ValidUser

### API Alternatives: 


# Spatial Index
## ammnt_addSpatialIndex
```
CREATE PROCEDURE `ammnt_addSpatialIndex`(IN entityId INT, IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE)
```
Description: ??? TODO

### Arguments
* `entityId` Entity Id
* `lon` longitude of point XXX ???
* `lat` latitude of point XXX ???
* `width` width of bbox in degrees?
* `height` height of bbox in degrees?


### Results
* ??? TODO

### Authentication: None

### API Alternatives: 

## ammnt_addSpatialIndexEffectiveDate
```
CREATE PROCEDURE `ammnt_addSpatialIndexEffectiveDate`(IN un VARCHAR(100), in pw VARCHAR(100), IN fir INT, IN branchId INT, IN revisionId INT, IN type VARCHAR(100), IN name longtext, IN commitMsg VARCHAR(50000), IN entityId INT, IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective dateTime, in validUntil dateTime)
```
Description: This function writes spatial index table. The spatial index grid is a uniform grid across the globe, that has 540 tiles per hemisphere, tiles are numbered from top to bottom, from left to right. This function marks all tiles the are effected by the given rectangle (lat, lon, width,height). This allows a spatial query. All elements in a certain geographic area (or in its vicinity) can be loaded relatively quickly, f the spatial index table is correctly scaled and indexed.

* `pw` Password
* `Un` Username
* `fir` FIR Id
* `branchId` Branch Id (unused)
* `revisionId` Revion Id of commited object
* `type` any type for filtering, e.g. core feature designator, e.g. Ahp (Airport)
* `name` core feature unique name (e.g. LSZH)
* `commitMsg` commit mesage of commit, when spatial index was created or changed
* `entityId` serviceEntityId of committed object
* `lon` longitude of point rectangle (top)
* `lat` latitude of point rectangle (left)
* `width` width of bbox in degrees
* `height` height of bbox in degrees
* `effective` not implemented yet
* `validUntil` not implemented yet

### Results
* ??? TODO

### Authentication: None

## ammnt_deleteSpatialIndex
```
CREATE PROCEDURE `ammnt_deleteSpatialIndex`(IN entityId INT)
```
Description: Deletes a spatial index for an entity

* `entityId` Entity Id

### Results
* ??? TODO

### Authentication: None


## getSpatialIndexChangesOfDates
```
CREATE PROCEDURE `getSpatialIndexChangesOfDates`(IN un VARCHAR(100), in pw VARCHAR(100), IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective datetime, in validUntil datetime)
```

Description: ??? TODO

### Arguments
* `pw` Password
* `Un` Username
* `lon` longitude of point rectangle (top)
* `lat` latitude of point rectangle (left)
* `width` width of bbox in degrees
* `height` height of bbox in degrees
* `effective` not implemented yet
* `validUntil` not implemented yet
* 
### Results
* ??? TODO

### Authentication: ValidUser

### API Alternatives: 

## getSpatialIndexTilesChangedOfDates
```
CREATE PROCEDURE `getSpatialIndexTilesChangedOfDates`(IN un VARCHAR(100), in pw VARCHAR(100), IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective datetime, in validUntil datetime)
```

# Query

## ammnt_queryTableFirSpatial
```
CREATE PROCEDURE `ammnt_queryTableFirSpatial`(in tablename varchar(10), in serviceid int, in firid int, in propertyid int,IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE)
```

## ammnt_queryTableFir
```
CREATE PROCEDURE `ammnt_queryTableFir`(in tablename varchar(10), in serviceid int, in firid int, in propertyid int)
```

# Other - Non-standard
## ammnt_AddFirAmmnt
```
CREATE PROCEDURE `ammnt_AddFirAmmnt`(IN Tablename varchar(10), IN ServEntityID INT, IN Fir_Id INT, parentServId INT)
```
## ammnt_GetFirRevision
```
CREATE PROCEDURE `ammnt_GetFirRevision`(In pw VARCHAR(20), IN Un VARCHAR(50),IN Fid INT)
```
## ammnt_GetNumberOfTodaysCommits
```
CREATE PROCEDURE `ammnt_GetNumberOfTodaysCommits`(In pw VARCHAR(20), IN Un VARCHAR(50),IN ServID INT)
```

# Deprecated PROCEDURES - Confirmed
```
CREATE PROCEDURE `UpdateLangTransEntity`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PropertyID INT(11), IN Value VARCHAR(1000), IN LanguageID INT(11))
CREATE PROCEDURE `execQuery`(IN qry VARCHAR(20000))
CREATE PROCEDURE `ammnt_AddActivityDataRecord`(In pw VARCHAR(20), IN Un VARCHAR(50), IN record longtext, IN Login TIMESTAMP, IN Logout TIMESTAMP, IN activeMinutes INT)
CREATE PROCEDURE `ammnt_GetUserActivity`(In Pw VARCHAR(50), IN Un VARCHAR(50), IN StartDate DATE, IN EndDate DATE)
CREATE PROCEDURE `ammnt_IdentifyOadServiceEntity`(IN Designator VARCHAR(100), IN DataType VARCHAR(100), IN FirID INT)
```
