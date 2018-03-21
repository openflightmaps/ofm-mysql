# Stored procedures

```
CREATE FUNCTION `checkUserExists`(un VARCHAR(100), pw VARCHAR(100)) RETURNS tinyint(1)
CREATE FUNCTION `getUserId`(un VARCHAR(100), pw VARCHAR(100)) RETURNS int(11)
CREATE PROCEDURE `DeleteInheritedService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN InhServId INT)
CREATE PROCEDURE `GetServiceEntityRevision`(IN EntityID INT)
CREATE PROCEDURE `GetServiceRevision`(In pw VARCHAR(20), IN Un VARCHAR(50),IN AnyID INT, IN Service1_ServiceEntity2 INT)
CREATE PROCEDURE `InheritService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN ServiceID INT, IN OrgID INT, IN IsPublic INT, IN InSearchTag VARCHAR(200))
CREATE PROCEDURE `QueryTable`(In Un VARCHAR(50), IN Pw VARCHAR(50), IN TableName VARCHAR(10), IN AnyID INT(11), IN AnyID2 INT(11), IN AnyValue VARCHAR(500))
CREATE PROCEDURE `SetBinary`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), PropertyID INT(11), IN BL LONGBLOB, OrgID INT(11), IN oldRef VARCHAR(20), IN ServiceIsPublic INT)
CREATE PROCEDURE `SetLanguagePreference`(In pw VARCHAR(20), IN Un VARCHAR(50), IN LanguageID INT(11))
CREATE PROCEDURE `UpdateLangTransEntity`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PropertyID INT(11), IN Value VARCHAR(1000), IN LanguageID INT(11))
CREATE PROCEDURE `UpdateOrganization`(In pw VARCHAR(20), IN Un VARCHAR(50), IN OrgName VARCHAR(100), Add1_Delete2 INT(11))
CREATE PROCEDURE `UpdatePermission`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PermissionID INT(11), IN StartValidity VARCHAR(30), IN EndValidity VARCHAR(30), IN OrgID INT(11), IN ServiceID INT(11), IN RemovePermission BOOL)
CREATE PROCEDURE `UpdateProperty`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PropertyID INT(11), IN Value MEDIUMTEXT CHARSET utf8, IN anyId INT(11), AddReplace1_Add2_Delete3 INT(11), IN oldValue MEDIUMTEXT, IN ServiceIsPublic INT)
CREATE PROCEDURE `UpdateService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN ServiceID INT, IN ServiceEntityId_ INT, IN OrgID INT, IN IsPublic INT, IN InSearchTag VARCHAR(200))
CREATE PROCEDURE `ammnt_AddActivityDataRecord`(In pw VARCHAR(20), IN Un VARCHAR(50), IN record longtext, IN Login TIMESTAMP, IN Logout TIMESTAMP, IN activeMinutes INT)
CREATE PROCEDURE `ammnt_AddFirAmmnt`(IN Tablename varchar(10), IN ServEntityID INT, IN Fir_Id INT, parentServId INT)
CREATE PROCEDURE `ammnt_GetFirRevision`(In pw VARCHAR(20), IN Un VARCHAR(50),IN Fid INT)
CREATE PROCEDURE `ammnt_GetNumberOfTodaysCommits`(In pw VARCHAR(20), IN Un VARCHAR(50),IN ServID INT)
CREATE PROCEDURE `ammnt_GetUserActivity`(In Pw VARCHAR(50), IN Un VARCHAR(50), IN StartDate DATE, IN EndDate DATE)
CREATE PROCEDURE `ammnt_IdentifyOadServiceEntity`(IN Designator VARCHAR(100), IN DataType VARCHAR(100), IN FirID INT)
CREATE PROCEDURE `ammnt_addSpatialIndexEffectiveDate`(IN un VARCHAR(100), in pw VARCHAR(100), IN fir INT, IN branchId INT, IN revisionId INT, IN type VARCHAR(100), IN name longtext, IN commitMsg VARCHAR(50000), IN entityId INT, IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective dateTime, in validUntil dateTime)
CREATE PROCEDURE `ammnt_addSpatialIndex`(IN entityId INT, IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE)
CREATE PROCEDURE `ammnt_deleteSpatialIndex`(IN entityId INT)
CREATE PROCEDURE `ammnt_queryTableFirSpatial`(in tablename varchar(10), in serviceid int, in firid int, in propertyid int,IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE)
CREATE PROCEDURE `ammnt_queryTableFir`(in tablename varchar(10), in serviceid int, in firid int, in propertyid int)
CREATE PROCEDURE `execQuery`(IN qry VARCHAR(20000))
CREATE PROCEDURE `getSpatialIndexChangesOfDates`(IN un VARCHAR(100), in pw VARCHAR(100), IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective datetime, in validUntil datetime)
CREATE PROCEDURE `getSpatialIndexTilesChangedOfDates`(IN un VARCHAR(100), in pw VARCHAR(100), IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective datetime, in validUntil datetime)
```


