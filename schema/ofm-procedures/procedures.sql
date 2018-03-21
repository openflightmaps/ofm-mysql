--
-- Dumping routines for database 'ofm'
--
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` FUNCTION `checkUserExists`(un VARCHAR(100), pw VARCHAR(100)) RETURNS tinyint(1)
BEGIN

DECLARE count INT;

    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
 


RETURN count > 0;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` FUNCTION `getUserId`(un VARCHAR(100), pw VARCHAR(100)) RETURNS int(11)
BEGIN
   return (SELECT userid FROM U1T WHERE Password = pw AND Username = un);
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_AddActivityDataRecord`(In pw VARCHAR(20), IN Un VARCHAR(50), IN record longtext, IN Login TIMESTAMP, IN Logout TIMESTAMP, IN activeMinutes INT)
BEGIN

    -- Check Table U1 exists
    DECLARE count INT(11);
        
    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
    
    IF count > 0 THEN     
		INSERT IGNORE `AMMNT_ACTIVITYDATARECORDER` (`UserID`, `record`,`LoginTime`,`LogoutTime`,`ActivityDurationMin`) VALUES ((SELECT UserID FROM U1T WHERE Password = pw AND Username = Un), record, Login,Logout,activeMinutes); 
	END IF;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_AddFirAmmnt`(IN Tablename varchar(10), IN ServEntityID INT, IN Fir_Id INT, parentServId INT)
BEGIN
 IF tablename = 'S4' then Update S4 Set ammnt_FirId = Fir_Id  where ServiceEntityId = ServEntityID and parentServiceId = ParentServId;end if;
 IF tablename = 'S3A1' then Update S3A1 Set ammnt_FirId = Fir_Id  where ServiceEntityId = ServEntityID and parentServiceId = ParentServId;  end if;
 IF tablename = 'S3A2' then Update S3A2 Set ammnt_FirId = Fir_Id  where ServiceEntityId = ServEntityID and parentServiceId = ParentServId; end if;
 IF tablename = 'S3A3' then Update S3A3 Set ammnt_FirId = Fir_Id  where ServiceEntityId = ServEntityID and parentServiceId = ParentServId; end if;
 IF tablename = 'S3A4' then Update S3A4 Set ammnt_FirId = Fir_Id  where ServiceEntityId = ServEntityID and parentServiceId = ParentServId; end if;
 IF tablename = 'S3A5' then Update S3A5 Set ammnt_FirId = Fir_Id  where ServiceEntityId = ServEntityID and parentServiceId = ParentServId; end if;
 IF tablename = 'S3A6' then Update S3A6 Set ammnt_FirId = Fir_Id  where ServiceEntityId = ServEntityID and parentServiceId = ParentServId; end if;
 IF tablename = 'S3A7' then Update S3A7 Set ammnt_FirId = Fir_Id  where ServiceEntityId = ServEntityID and parentServiceId = ParentServId; end if;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `ammnt_addSpatialIndex`(IN entityId INT, IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE)
BEGIN
   DECLARE tilesX INT;
   DECLARE tilesY INT;
   DECLARE startIdx BIGINT;
   DECLARE endIdx BIGINT;
   DECLARE diffX DOUBLE;
   DECLARE diffY DOUBLE;
   DECLARE id BIGINT;
   DECLARE firstVal BIGINT;
   DECLARE endVal BIGINT;
   DECLARE loopVal BIGINT;
 -- this function is going to be obsolete once branches and revision have been implemented, livetime left : 30 days ;-)
 -- defined tilegrid
   SET tilesX = 360 * 6;
   SET tilesY = 180 * 6;
	
   -- set noIdx, if bigger than width * height > 36
   IF width * height > 500 THEN
	SET width=0;
    set height=0;
	set lat=0;
    set lon=0;
   END IF;

   SET startIdx = FLOOR(tilesX / 360 * lon) * tilesY;
   SET endIdx = FLOOR(tilesX / 360 * (lon + width)) * tilesY;
   SET diffX  = width * tilesX / 360;
   SET diffY  = height * tilesY / 180;



   -- delete existing indices
   DELETE FROM AMMNT_S4_SPATIALINDEX WHERE ServiceEntityId = entityId;
   
   -- this particular case (as function is very soon obsolete), remove it from this history first
   DELETE FROM AMMNT_S4_SPATIALINDEX_CHANGES WHERE ServiceEntityId = entityId;

   SET id = 0;

   simple_loop: LOOP         
        
   -- new start idx
      SET startIdx = CEILING(tilesX / 360 * (lon + id * 360 / tilesX)) * tilesY;
	  SET firstVal = startIdx + (lat + 90) / 180 * tilesY;
	  SET endVal   = firstVal + diffy;

      SET loopVal = firstVal;

      insertLoop: LOOP
		INSERT IGNORE AMMNT_S4_SPATIALINDEX (ServiceEntityId, TileId, lastChange) VALUES (entityId,loopVal,Now());
        
		INSERT IGNORE AMMNT_S4_SPATIALINDEX_CHANGES (ServiceEntityId, TileId, effectiveDate,validUntilDate) VALUES (entityId,loopVal,NOW(), '2099-12-31');

         SET loopVal=loopVal+1;
         IF loopVal>=endVal THEN
            LEAVE insertLoop;
         END IF;
	  END LOOP insertLoop;
 

         SET id=id+1;
         IF id>=diffX THEN
            LEAVE simple_loop;
         END IF;
   END LOOP simple_loop;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `ammnt_addSpatialIndexEffectiveDate`(IN un VARCHAR(100), in pw VARCHAR(100), IN fir INT, IN branchId INT, IN revisionId INT, IN type VARCHAR(100), IN name longtext, IN commitMsg VARCHAR(50000), IN entityId INT, IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective dateTime, in validUntil dateTime)
BEGIN
   DECLARE tilesX INT;
   DECLARE tilesY INT;
   DECLARE startIdx BIGINT;
   DECLARE endIdx BIGINT;
   DECLARE diffX DOUBLE;
   DECLARE diffY DOUBLE;
   DECLARE id BIGINT;
   DECLARE firstVal BIGINT;
   DECLARE endVal BIGINT;
   DECLARE loopVal BIGINT;

 -- defined tilegrid
   SET tilesX = 360 * 6;
   SET tilesY = 180 * 6;

-- check user exists
if checkUserExists(un,pw) then

   -- set noIdx, if bigger than width * height > 36
   IF width * height > 500 THEN
	SET width=0;
    set height=0;
	set lat=0;
    set lon=0;
   END IF;

   SET startIdx = FLOOR(tilesX / 360 * lon) * tilesY;
   SET endIdx = FLOOR(tilesX / 360 * (lon + width)) * tilesY;
   SET diffX  = CEILING(width * tilesX / 360);
   SET diffY  = CEILING(height * tilesY / 180);



   -- delete existing indices
   DELETE FROM AMMNT_S4_SPATIALINDEX WHERE ServiceEntityId = entityId;

   SET id = 0;

   simple_loop: LOOP         
        
   -- new start idx
      SET startIdx = FLOOR(tilesX / 360 * (lon + id * 360 / tilesX)) * tilesY;
	  SET firstVal = FLOOR(startIdx + (lat + 90) / 180 * tilesY);
	  SET endVal   = CEILING(firstVal + diffy);

      SET loopVal = firstVal;

      insertLoop: LOOP
		INSERT IGNORE AMMNT_S4_SPATIALINDEX (ServiceEntityId, TileId, lastChange) VALUES (entityId,loopVal,Now());
		INSERT IGNORE AMMNT_S4_SPATIALINDEX_CHANGES( fir,ServiceEntityId,TileId, effectiveDate,validUntilDate, userId,type,name,commitMsg) VALUES (fir, entityId,loopVal,effective,validUntil,getUserId(un,pw),type,name,commitMsg);

         SET loopVal=loopVal+1;
         IF loopVal>endVal THEN
            LEAVE insertLoop;
         END IF;
	  END LOOP insertLoop;
 

         SET id=id+1;
         IF id>diffX THEN
            LEAVE simple_loop;
         END IF;
   END LOOP simple_loop;
 
END IF;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `ammnt_deleteSpatialIndex`(IN entityId INT)
BEGIN
 
	DELETE FROM AMMNT_S4_SPATIALINDEX where ServiceEntityId = entityId;
 
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_GetFirRevision`(In pw VARCHAR(20), IN Un VARCHAR(50),IN Fid INT)
BEGIN
DECLARE count INT;
DECLARE rev DOUBLE;
DECLARE loopCnt DOUBLE;
 
    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
          
    -- if yes return Table -> as it is available to anybody (no permissions required)
    IF count > 0 THEN

        -- To get the Service-Revision: Add all Service-Entity-Revisions to a number, as they are always growing this is a unique ID.
       set rev = (SELECT SUM(Revision) FROM S4 WHERE ammnt_FirId = Fid);
       WHILE(rev >= 32767 OR loopCnt > 100) DO
		set rev = rev - 32767;
        set loopCnt = loopCnt +1;
		END WHILE;
       select  CONVERT(rev, CHAR(50));
    END IF;

END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_GetNumberOfTodaysCommits`(In pw VARCHAR(20), IN Un VARCHAR(50),IN ServID INT)
BEGIN
 DECLARE count INT(11);
 DECLARE CNT INT(11);
SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);

IF count > 0 THEN
     (SELECT count( distinct (serviceEntityId)) FROM ofm.AMMNT_COMMIT WHERE ParentServiceID = ServID AND timestamp > DATE_SUB(NOW(), INTERVAL 24 HOUR));
  END IF;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_GetUserActivity`(In Pw VARCHAR(50), IN Un VARCHAR(50), IN StartDate DATE, IN EndDate DATE)
BEGIN	

	Select * FROM AMMNT_COMMIT where UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) and (PropertyID=12 or PropertyID=17) AND TimeStamp >= StartDate and TimeStamp <= EndDate  order by TimeStamp desc limit 300; 
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_IdentifyOadServiceEntity`(IN Designator VARCHAR(100), IN DataType VARCHAR(100), IN FirID INT)
BEGIN
	SELECT ServiceEntityID FROM S3A3 WHERE (ParentServiceID = 3 OR ParentServiceID = 4) AND (ServiceEntityPropertiesTypeID = 12 AND ServiceEntityPropertiesTypeValue = Designator AND ammnt_FIRID = FirID AND deleted is null);
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_queryTableFir`(in tablename varchar(10), in serviceid int, in firid int, in propertyid int)
BEGIN
IF TableName = 'S3A1' THEN SELECT * FROM S3A1 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0); END IF;
IF TableName = 'S3A2' THEN SELECT * FROM S3A2 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0); END IF;
IF TableName = 'S3A3' THEN SELECT * FROM S3A3 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0); END IF;
IF TableName = 'S3A4' THEN SELECT * FROM S3A4 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0); END IF;
IF TableName = 'S3A5' THEN SELECT * FROM S3A5 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0); END IF;
IF TableName = 'S3A6' THEN SELECT * FROM S3A6 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0); END IF;
IF TableName = 'S3A7' THEN SELECT * FROM S3A7 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0); END IF;

-- 2014-01-26 : deleted column added, and changed the following line accordingly
IF TableName = 'S4' THEN select * FROM S4 WHERE ammnt_FirId = Firid and ParentServiceId = serviceid and (deleted IS NULL or deleted = 0); END if;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_queryTableFirSpatial`(in tablename varchar(10), in serviceid int, in firid int, in propertyid int,IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE)
BEGIN

   -- create temporary table of relevant id´s
   DECLARE tilesX INT;
   DECLARE tilesY INT;
   DECLARE startIdx BIGINT;
   DECLARE endIdx BIGINT;
   DECLARE diffX DOUBLE;
   DECLARE diffY DOUBLE;
   DECLARE id BIGINT;
   DECLARE firstVal BIGINT;
   DECLARE endVal BIGINT;
   DECLARE loopVal BIGINT;
 

   DROP TEMPORARY TABLE IF EXISTS spatialQuery;     -- make sure it doesnt already exist
   CREATE TEMPORARY TABLE spatialQuery (
   serviceEntityId BIGINT
   ) ENGINE=memory;

 -- defined tilegrid
   SET tilesX = 360 * 6;
   SET tilesY = 180 * 6;

   SET startIdx = FLOOR(tilesX / 360 * lon) * tilesY;
   SET endIdx = FLOOR(tilesX / 360 * (lon + width)) * tilesY;
   SET diffX  = width * tilesX / 360;
   SET diffY  = height * tilesY / 180;
	
    SET id = 0;

   simple_loop: LOOP         
        
   -- new start idx
      SET startIdx = CEILING(tilesX / 360 * (lon + id * 360 / tilesX)) * tilesY;
	  SET firstVal = startIdx + (lat + 90) / 180 * tilesY;
	  SET endVal   = firstVal + diffy;

      SET loopVal = firstVal;

      insertLoop: LOOP
		INSERT IGNORE spatialQuery (serviceEntityId) VALUES (loopVal);

         SET loopVal=loopVal+1;
         IF loopVal>endVal THEN
            LEAVE insertLoop;
         END IF;
	  END LOOP insertLoop;
 

         SET id=id+1;
         IF id>diffX THEN
            LEAVE simple_loop;
         END IF;
   END LOOP simple_loop;

-- insert tile 0/0, for all data without geographic relation
set loopVal = (0 + 90) / 180 * tilesY;
INSERT IGNORE spatialQuery (serviceEntityId) VALUES (loopVal);

IF TableName = 'S3A1' THEN SELECT * FROM S3A1 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT serviceEntityId FROM spatialQuery)); END IF;
IF TableName = 'S3A2' THEN SELECT * FROM S3A2 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT serviceEntityId FROM spatialQuery)); END IF;
IF TableName = 'S3A3' THEN SELECT * FROM S3A3 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT serviceEntityId FROM spatialQuery)); END IF;
IF TableName = 'S3A4' THEN SELECT * FROM S3A4 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT serviceEntityId FROM spatialQuery)); END IF;
IF TableName = 'S3A5' THEN SELECT * FROM S3A5 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT serviceEntityId FROM spatialQuery));  END IF;
IF TableName = 'S3A6' THEN SELECT * FROM S3A6 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT serviceEntityId FROM spatialQuery)); END IF;
IF TableName = 'S3A7' THEN SELECT * FROM S3A7 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT serviceEntityId FROM spatialQuery)); END IF;

-- 2014-01-26 : deleted column added, and changed the following line accordingly
IF TableName = 'S4' THEN select * FROM S4 WHERE ammnt_FirId = Firid and ParentServiceId = serviceid and (deleted IS NULL or deleted = 0); END if;


END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `DeleteInheritedService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN InhServId INT)
BEGIN
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PK INT(11);
    
    -- Check the User Exists   
SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
  if count > 0 THEN
  
  -- Permissions missing here!
       
  -- this sets the entity as deleted in the s4 table : added 2014-01-26
	 UPDATE S4 set deleted = 1 where ServiceEntityID = InhServId;
	 UPDATE S3A1 set deleted = 1 where ServiceEntityID = InhServId;
	 UPDATE S3A2 set deleted = 1 where ServiceEntityID = InhServId;
	 UPDATE S3A3 set deleted = 1 where ServiceEntityID = InhServId;
	 UPDATE S3A4 set deleted = 1 where ServiceEntityID = InhServId;
	 UPDATE S3A5 set deleted = 1 where ServiceEntityID = InhServId;	
	 UPDATE S3A6 set deleted = 1 where ServiceEntityID = InhServId;

  -- THIS IS THE REAL DELETION : NOT ACTIVE IN THE MOMENT
  --  DELETE FROM S4 WHERE ServiceEntityID = InhServId;
  --  DELETE FROM S3A1 WHERE ServiceEntityID = InhServId;
  --  DELETE FROM S3A2 WHERE ServiceEntityID = InhServId;
  --  DELETE FROM S3A3 WHERE ServiceEntityID = InhServId;
  --  DELETE FROM S3A4 WHERE ServiceEntityID = InhServId;
  --  DELETE FROM S3A5 WHERE ServiceEntityID = InhServId;
  --  DELETE FROM S3A6 WHERE ServiceEntityID = InhServId;
  --  DELETE FROM S3A7 WHERE ServiceEntityID = InhServId;

-- following is OFM-Dependent code
-- Insert into Ammendmt-Table of Commits:
INSERT IGNORE `AMMNT_COMMIT` (`ServiceEntityID`,`ParentServiceID`,`UserID`, `TimeStamp`,`AddReplace1_Add2_Delete3`) VALUES (PK + 1, InhServId, (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un), CURRENT_TIMESTAMP,2);

  end if;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `execQuery`(IN qry VARCHAR(20000))
BEGIN
                   PREPARE stmt1 FROM @qry; 
                EXECUTE stmt1;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `GetServiceEntityRevision`(IN EntityID INT)
BEGIN
	SELECT Revision from S4 Where serviceEntityID = EntityID;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `GetServiceRevision`(In pw VARCHAR(20), IN Un VARCHAR(50),IN AnyID INT, IN Service1_ServiceEntity2 INT)
BEGIN

 DECLARE count INT(11);
 
    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
          
    -- if yes return Table -> as it is available to anybody (no permissions required)
    IF count > 0 THEN

        -- To get the Service-Revision: Add all Service-Entity-Revisions to a number, as they are always growing this is a unique ID.
        SELECT SUM(Revision) FROM S4 WHERE ParentServiceID = AnyID;
    END IF;

END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `getSpatialIndexChangesOfDates`(IN un VARCHAR(100), in pw VARCHAR(100), IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective datetime, in validUntil datetime)
BEGIN
   -- create temporary table of relevant id´s
   DECLARE tilesX INT;
   DECLARE tilesY INT;
   DECLARE startIdx BIGINT;
   DECLARE endIdx BIGINT;
   DECLARE diffX DOUBLE;
   DECLARE diffY DOUBLE;
   DECLARE id BIGINT;
   DECLARE firstVal BIGINT;
   DECLARE endVal BIGINT;
   DECLARE loopVal BIGINT;
 

   DROP TEMPORARY TABLE IF EXISTS spatialQuery;     -- make sure it doesnt already exist
   CREATE TEMPORARY TABLE spatialQuery (
   serviceEntityId BIGINT
   ) ENGINE=memory;

 -- defined tilegrid
   SET tilesX = 360 * 6;
   SET tilesY = 180 * 6;

   SET startIdx = FLOOR(tilesX / 360 * lon) * tilesY;
   SET endIdx = FLOOR(tilesX / 360 * (lon + width)) * tilesY;
   SET diffX  = width * tilesX / 360;
   SET diffY  = height * tilesY / 180;
	
   SET id = 0;

   simple_loop: LOOP         
        
   -- new start idx
      SET startIdx = CEILING(tilesX / 360 * (lon + id * 360 / tilesX)) * tilesY;
	  SET firstVal = startIdx + (lat + 90) / 180 * tilesY;
	  SET endVal   = firstVal + diffy;

      SET loopVal = firstVal;

      insertLoop: LOOP
		INSERT IGNORE spatialQuery (serviceEntityId) VALUES (loopVal);

         SET loopVal=loopVal+1;
         IF loopVal>endVal THEN
            LEAVE insertLoop;
         END IF;
	  END LOOP insertLoop;
         SET id=id+1;
         IF id>diffX THEN
            LEAVE simple_loop;
         END IF;
   END LOOP simple_loop;

-- insert tile 0/0, for all data without geographic relation
set loopVal = (0 + 90) / 180 * tilesY;
INSERT IGNORE spatialQuery (serviceEntityId) VALUES (loopVal);

select distinct fir,serviceEntityId,name,type,commitMsg,userId,effectiveDate,validUntilDate from AMMNT_S4_SPATIALINDEX_CHANGES  where tileId in (select * from spatialQuery) and ((effectiveDate > effective and effectiveDate < validUntil) or (validUntilDate > effective and validUntilDate < validUntil))  order by effectiveDate desc;

END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `getSpatialIndexTilesChangedOfDates`(IN un VARCHAR(100), in pw VARCHAR(100), IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective datetime, in validUntil datetime)
BEGIN
   -- create temporary table of relevant id´s
   DECLARE tilesX INT;
   DECLARE tilesY INT;
   DECLARE startIdx BIGINT;
   DECLARE endIdx BIGINT;
   DECLARE diffX DOUBLE;
   DECLARE diffY DOUBLE;
   DECLARE id BIGINT;
   DECLARE firstVal BIGINT;
   DECLARE endVal BIGINT;
   DECLARE loopVal BIGINT;
 

   DROP TEMPORARY TABLE IF EXISTS spatialQuery;     -- make sure it doesnt already exist
   CREATE TEMPORARY TABLE spatialQuery (
   serviceEntityId BIGINT
   ) ENGINE=memory;

 -- check user exists
 if checkUserExists(un,pw) then
 

 -- defined tilegrid
   SET tilesX = 360 * 6;
   SET tilesY = 180 * 6;

   SET startIdx = FLOOR(tilesX / 360 * lon) * tilesY;
   SET endIdx = FLOOR(tilesX / 360 * (lon + width)) * tilesY;
   SET diffX  = width * tilesX / 360;
   SET diffY  = height * tilesY / 180;
	
   SET id = 0;

   simple_loop: LOOP         
        
   -- new start idx
      SET startIdx = CEILING(tilesX / 360 * (lon + id * 360 / tilesX)) * tilesY;
	  SET firstVal = startIdx + (lat + 90) / 180 * tilesY;
	  SET endVal   = firstVal + diffy;

      SET loopVal = firstVal;

      insertLoop: LOOP
		INSERT IGNORE spatialQuery (serviceEntityId) VALUES (loopVal);

         SET loopVal=loopVal+1;
         IF loopVal>endVal THEN
            LEAVE insertLoop;
         END IF;
	  END LOOP insertLoop;
         SET id=id+1;
         IF id>diffX THEN
            LEAVE simple_loop;
         END IF;
   END LOOP simple_loop;

	select TileId from AMMNT_S4_SPATIALINDEX_CHANGES  where tileId in (select * from spatialQuery) and ((effectiveDate > effective and effectiveDate < validUntil) or (validUntilDate > effective and validUntilDate < validUntil));
end if;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `InheritService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN ServiceID INT, IN OrgID INT, IN IsPublic INT, IN InSearchTag VARCHAR(200))
BEGIN
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PK INT(11);
    
    -- Check the User Exists   
SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
  if count > 0 THEN
   -- Set UserID
    SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
        
    if IsPublic = 1 THEN Set UID = -1; END IF;
        
    SET PK = (SELECT ServiceEntityID FROM S4 ORDER BY ServiceEntityID DESC LIMIT 1);
 
    INSERT IGNORE `S4` (`ServiceEntityID`,`ParentServiceID`, `OrganizationID`, `UseriD`, `Revision`, `searchTags`) VALUES (PK+1, ServiceID,OrgID,UID,1,InSearchTag);
      
-- following is OFM-Dependent code
-- Insert into Ammendmt-Table of Commits:
	-- INSERT IGNORE `ammnt_commit` (`ServiceEntityID`,`ParentServiceID`,`UserID`, `TimeStamp`,`AddReplace1_Add2_Delete3`) VALUES (PK + 1, ServiceID, (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un), CURRENT_TIMESTAMP,2);
	-- UPDATE ammnt_commit SET TimeStamp = NOW() WHERE ServiceEntityID = ServiceID;



   SELECT PK+1;
  end if;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `QueryTable`(In Un VARCHAR(50), IN Pw VARCHAR(50), IN TableName VARCHAR(10), IN AnyID INT(11), IN AnyID2 INT(11), IN AnyValue VARCHAR(500))
BEGIN


    -- Check Table U1 exists
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE TN VARCHAR(5);
  
    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
          
    -- if yes return Table -> as it is available to anybody (no permissions required)
    IF count > 0 THEN
            IF TableName = 'G1T' THEN SELECT * FROM G1T ORDER BY LanguageID;END IF;
            IF TableName = 'G2T' THEN SELECT * FROM G2T ORDER BY CountryID; END IF;
            IF TableName = 'G5T' THEN SELECT * FROM G5T WHERE SystemsIconsID = AnyID; END IF;
            IF TableName = 'U2T' THEN SELECT * FROM U2T ORDER BY UserPropertiesTypeID;END IF;
          
            IF TableName = 'U1Com' THEN 
                IF (SELECT COUNT(*) FROM P1A WHERE UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) AND (SELECT PermissionsTypeID FROM P1T WHERE PermissionsTypeDescription = 'ION User Administration')) > 0 THEN
                    -- Check whether Permission 'Edit/Add/Delete User Data' is available
                    SELECT * FROM U1T;
                END IF;
            END IF;
                 
            IF TableName = 'U3T' THEN SELECT * FROM U3T;END IF;
            IF TableName = 'U1T' THEN SELECT * FROM U1T WHERE Password = pw AND Username = Un; END IF;
            IF TableName = 'P1T' THEN SELECT * FROM P1T;END IF;
            IF TableName = 'O1T' THEN SELECT * FROM O1T;END IF;
            IF TableName = 'S5T' THEN SELECT * FROM S5T; END IF;
            IF TableName = 'S3T' THEN SELECT * FROM S3T; END IF;
            
            -- Language Translations
             IF TableName = 'U2L' THEN SELECT * FROM U2L WHERE LanguageID = AnyID; END IF;
             IF TableName = 'O1L' THEN SELECT * FROM O1L WHERE LanguageID = AnyID; END IF;
             IF TableName = 'U3L' THEN SELECT * FROM U3L WHERE LanguageID = AnyID; END IF;
             IF TableName = 'P1L' THEN SELECT * FROM P1L WHERE LanguageID = AnyID; END IF;
             IF TableName = 'S1L' THEN SELECT * FROM S1L WHERE LanguageID = AnyID; END IF;
             IF TableName = 'S2L' THEN SELECT * FROM S2L WHERE LanguageID = AnyID; END IF;
             IF TableName = 'S5L' THEN SELECT * FROM S5L WHERE LanguageID = AnyID; END IF;
             IF TableName = 'G4T' THEN SELECT * FROM G4T; END IF;
             IF TableName = 'G4A1' THEN SELECT * FROM G4A1 WHERE LanguageID = AnyID; END IF;
             IF TableName = 'G4A2' THEN SELECT * FROM G4A2 WHERE LanguageID = AnyID; END IF;
             IF TableName = 'G4A3' THEN SELECT * FROM G4A3 WHERE LanguageID = AnyID; END IF;
             IF TableName = 'G4A4' THEN SELECT * FROM G4A4 WHERE LanguageID = AnyID; END IF;
             IF TableName = 'S4T' THEN SELECT * FROM S4T WHERE LanguageID = AnyID; END IF;
              
             -- Services (Origin only -> OrganizationID = 0)
             IF TableName = 'S1T' THEN SELECT * FROM S1T WHERE OrganizationID = 0; END IF;
             IF TableName = 'S2T' THEN SELECT * FROM S2T; END IF;
             
            -- User Allocations
            IF TableName = 'U2A1' OR TableName ='U2A2' OR TableName ='U2A3' OR TableName ='U2A4' OR TableName ='U2A5' OR TableName ='U2A6' OR TableName ='U2A7' OR TableName ='U1_O1A' THEN 
                SET @TN:= CONCAT('SELECT * FROM ', Tablename , ' WHERE UserID =', (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) , ';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
                
            -- Organization Allocations  
            IF TableName = 'O1A1' OR TableName ='O1A2' OR TableName ='O1A3' OR TableName ='O1A4' OR TableName ='O1A5' OR TableName ='O1A6' OR TableName ='O1A7' THEN
                SET @TN:= CONCAT('SELECT * FROM ', Tablename , ' WHERE OrganizationID = ', AnyID,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
                                     
                                     
            IF TableName = 'U1_O1A' THEN  SELECT * FROM U1_O1A WHERE UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un); END IF;
            IF TableName = 'P1A' THEN  SELECT * FROM P1A WHERE UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un); END IF;            
            
            -- Services
            -- AnyID ... ServiceEntityPropertyType
            -- AnyID2 ... ServiceEntityID
			
			-- S4 could be queried with or without a tagsearch-string (which is "anyValue")
			-- incase of with:
			IF TableName = 'S4' THEN
				IF AnyValue <> '' THEN
					SELECT * FROM S4 WHERE ParentServiceID = AnyID AND searchTags like AnyValue and (deleted <> 1 or deleted is null);
				ELSE
					SELECT * FROM S4 WHERE ParentServiceID = AnyID;
				END IF;	
			END IF;

            IF TableName = 'S3A1' THEN SELECT * FROM S3A1 WHERE ServiceEntityPropertiesTypeID = AnyID AND (ServiceEntityPropertiesTypeValue = AnyValue OR AnyValue = '-1') AND (UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) OR UserID = -1) AND (ServiceEntityID = AnyID2 OR AnyID2=-1) AND (deleted is null or deleted = 0); END IF;
            IF TableName = 'S3A2' THEN SELECT * FROM S3A2 WHERE ServiceEntityPropertiesTypeID = AnyID AND (ServiceEntityPropertiesTypeValue = AnyValue OR AnyValue = '-1') AND (UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) OR UserID = -1) AND (ServiceEntityID = AnyID2 OR AnyID2=-1) AND (deleted is null or deleted = 0); END IF;
            IF TableName = 'S3A3' THEN SELECT * FROM S3A3 WHERE ServiceEntityPropertiesTypeID = AnyID AND (ServiceEntityPropertiesTypeValue = AnyValue OR AnyValue = '-1') AND (UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) OR UserID = -1) AND (ServiceEntityID = AnyID2 OR AnyID2=-1) AND (deleted is null or deleted = 0); END IF;
            IF TableName = 'S3A4' THEN SELECT * FROM S3A4 WHERE ServiceEntityPropertiesTypeID = AnyID AND (ServiceEntityPropertiesTypeValue = AnyValue OR AnyValue = '-1') AND (UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) OR UserID = -1) AND (ServiceEntityID = AnyID2 OR AnyID2=-1) AND (deleted is null or deleted = 0); END IF;
            IF TableName = 'S3A5' THEN SELECT * FROM S3A5 WHERE ServiceEntityPropertiesTypeID = AnyID AND (ServiceEntityPropertiesTypeValue = AnyValue OR AnyValue = '-1') AND (UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) OR UserID = -1) AND (ServiceEntityID = AnyID2 OR AnyID2=-1) AND (deleted is null or deleted = 0); END IF;
            IF TableName = 'S3A6' THEN SELECT * FROM S3A6 WHERE ServiceEntityPropertiesTypeID = AnyID AND (UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) OR UserID = -1) AND (ServiceEntityID = AnyID2 OR AnyID2=-1)  AND deleted is null; END IF;
            IF TableName = 'S3A7' THEN SELECT * FROM S3A7 WHERE ServiceEntityPropertiesTypeID = AnyID AND (ServiceEntityPropertiesTypeValue = AnyValue  OR AnyValue = '-1') AND (UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) OR UserID = -1) AND (ServiceEntityID = AnyID2 OR AnyID2=-1) AND (deleted is null or deleted = 0); END IF;
                    
                       
            -- From now on : Ammendments for Openflightmaps:
            -- ---------------------------------------------
            IF TableName = 'AMMNT_FIR' THEN SELECT * FROM AMMNT_FIR; END IF;
    END IF;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `SetBinary`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), PropertyID INT(11), IN BL LONGBLOB, OrgID INT(11), IN oldRef VARCHAR(20), IN ServiceIsPublic INT)
BEGIN
 
    -- Check Table U1 exists
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE EXIST VARCHAR(11);
    DECLARE EXISTCNTR INT(11);
    
    DECLARE ServEntID INT;
   
    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
        
    -- if yes return Table -> as it is available to anybody (no permissions required)
    IF count > 0 THEN      
    
        -- Set UserID
        SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
                 
        IF Tablename = 'U2A6' THEN
              
			-- check multiple use (if false, remove existing items, even if they have been set multiple before)
			if (select multipleUse FROM U2T where userPropertiesTypeId = propertyId) = 0 THEN
				SET @TN:= CONCAT('DELETE FROM `',Tablename,'` WHERE ServiceEntityID = ' , OrgID ,' AND ServiceEntityPropertiesTypeID = ', PropertyID ,' AND UserID = ', UID,';'); 
				PREPARE stmt1 FROM @TN; 
				EXECUTE stmt1;
			END IF;
              
            SET EXISTCNTR = (SELECT COUNT(*) FROM U2A6 WHERE UserID = UID AND UserPropertiesTypeID = PropertyID AND PK= oldRef);
            IF EXISTCNTR = 0 THEN
                SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`UserID`, `UserPropertiesTypeID`, `UserPropertiesTypeValue`, `Hidden`,`IonChangeTimestamp`) VALUES (', UID,',', PropertyID,',', QUOTE(BL),', 0,', QUOTE(NOW()),');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            ELSE
                SET @TN:= CONCAT('UPDATE `',Tablename,'` SET UserPropertiesTypeValue= ', QUOTE(BL) , ' WHERE UserID = ' , UID ,' AND UserPropertiesTypeID = ', PropertyID ,' AND PK= ', oldRef ,';'); 
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
           END IF;
        END IF;
        IF Tablename = 'O1A6' THEN
            
			-- check multiple use (if false, remove existing items, even if they have been set multiple before)
			if (select multipleUse FROM U2T where userPropertiesTypeId = propertyId) = 0 THEN
				SET @TN:= CONCAT('DELETE FROM `',Tablename,'` WHERE organizationID = ' , OrgID ,' AND UserPropertiesTypeID = ', PropertyID ,';'); 
				PREPARE stmt1 FROM @TN; 
				EXECUTE stmt1;
			END IF;
		
            SET EXIST = (SELECT PK FROM O1A6 WHERE OrganizationID = OrgID AND UserPropertiesTypeID = PropertyID AND PK= oldRef);
            SET EXISTCNTR = (SELECT COUNT(*) FROM O1A6 WHERE OrganizationID = OrgID AND UserPropertiesTypeID = PropertyID AND PK= oldRef);
            IF EXISTCNTR = 0 THEN
                
                SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`OrganizationID`, `UserPropertiesTypeID`, `UserPropertiesTypeValue`, `Hidden`,`IonChangeTimestamp`) VALUES (', OrgID,',', PropertyID,',', QUOTE(BL),', 0,', QUOTE(NOW()),');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            ELSE
                SET @TN:= CONCAT('DELETE FROM `',Tablename,'` WHERE OrganizationID = ' , OrgID ,' AND UserPropertiesTypeID = ', PropertyID ,' AND PK= ', oldRef ,';'); 
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
                
                SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`PK`,`OrganizationID`, `UserPropertiesTypeID`, `UserPropertiesTypeValue`, `Hidden`,`IonChangeTimestamp`) VALUES (', EXIST , ',' , OrgID,',', PropertyID,',', QUOTE(BL),', 0,', QUOTE(NOW()),');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
        END IF;
         IF Tablename = 'S3A6' THEN
         
          IF ServiceIsPublic = 1 THEN SET UID = -1; END IF;
         
                -- GetCurrentRevision
               SET ServEntID = (SELECT Revision FROM S4 WHERE ServiceEntityID = OrgID);
               
               IF ServEntID > 20000 THEN  SET ServEntID = 1; END IF;        
               
               -- Update Service Entity Revision:
               UPDATE S4 SET Revision = (ServEntID +1) WHERE ServiceEntityID = OrgID;
               
				
				-- check multiple use (if false, remove existing items, even if they have been set multiple before)
                if (select multipleUse FROM S3T where serviceEntityTypeId = propertyId) = 0 THEN
					SET @TN:= CONCAT('DELETE FROM `',Tablename,'` WHERE ServiceEntityID = ' , OrgID ,' AND ServiceEntityPropertiesTypeID = ', PropertyID ,' AND UserID = ', UID,';'); 
					PREPARE stmt1 FROM @TN; 
					EXECUTE stmt1;
                END IF;
                
            SET EXIST = (SELECT PK FROM S3A6 WHERE ServiceEntityID = OrgID AND ServiceEntityPropertiesTypeID = PropertyID AND (UserID = UID) AND PK= oldRef);
            SET EXISTCNTR = (SELECT COUNT(*) FROM S3A6 WHERE ServiceEntityID = OrgID AND ServiceEntityPropertiesTypeID = PropertyID AND (UserID = UID) AND PK= oldRef);
       
            IF EXISTCNTR = 0 THEN
                
                SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`ServiceEntityID`, `ServiceEntityPropertiesTypeID`, `ServiceEntityPropertiesTypeValue`,`IonChangeTimestamp`,`UserID`,`ParentServiceId`) VALUES (', OrgID,',', PropertyID,',', QUOTE(BL),',', QUOTE(NOW()),',', UID ,',', (SELECT ParentServiceID From S4 Where ServiceEntityID = OrgID) , ');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            ELSE
                SET @TN:= CONCAT('DELETE FROM `',Tablename,'` WHERE ServiceEntityID = ' , OrgID ,' AND ServiceEntityPropertiesTypeID = ', PropertyID ,' AND UserID = ', UID,' AND PK=' ,  oldRef , ';'); 
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
                
                SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`PK`,`ServiceEntityID`, `ServiceEntityPropertiesTypeID`, `ServiceEntityPropertiesTypeValue`, `IonChangeTimestamp`, `UserID`,`ParentServiceId`) VALUES (', EXIST , ',' , OrgID,',', PropertyID,',', QUOTE(BL),',', QUOTE(NOW()),',', UID,',', (SELECT ParentServiceID From S4 Where ServiceEntityID = OrgID) ,');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
        END IF;
    END IF;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `SetLanguagePreference`(In pw VARCHAR(20), IN Un VARCHAR(50), IN LanguageID INT(11))
BEGIN
 
    -- Check Table U1 exists
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PE INT(11);
    DECLARE TN VARCHAR(200);
    DECLARE TIM VARCHAR(200);
    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
        
    -- if yes return Table -> as it is available to anybody (no permissions required)
    IF count > 0 THEN      
    
        -- Set UserID
        SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
        
        UPDATE U1T SET MainlanguagePref = LanguageID WHERE UserID = UID;
            
    END IF;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `UpdateLangTransEntity`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PropertyID INT(11), IN Value VARCHAR(1000), IN LanguageID INT(11))
BEGIN
 
    -- Check Table U1 exists
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PE INT(11);
    DECLARE TN VARCHAR(200);
    DECLARE TIM VARCHAR(200);
    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
        
    -- if yes return Table -> as it is available to anybody (no permissions required)
    IF count > 0 THEN      
    
     -- Developer Feature : Update System Text Types (G4)
        if TableName = 'G4T' THEN
         SET @TN:= CONCAT('INSERT IGNORE `',TableName,'` (`SystemTextKey`, `Format`) VALUES (', QUOTE(Value),',', 2 ,');');
            PREPARE stmt1 FROM @TN; 
            EXECUTE stmt1;
        ELSE
          -- Set UserID
       -- SET UID = (SELECT UserID FROM U1 WHERE Password = pw AND Username = Un);
        
     
        -- Still missing: Check User has Permission to change Languages!
        
        -- Check if Update/or Add   
    IF Value <> '' AND TableName <> 'G4T' THEN
        
        SET @TN:= CONCAT('SET @PE = (SELECT COUNT(*) FROM ', TableName, ' WHERE RefID = ', PropertyID ,' AND LanguageID = ', LanguageID ,');');
            PREPARE stmt1 FROM @TN; 
            EXECUTE stmt1;
        
        
         IF @PE > 0 THEN
               SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET Translation = ', QUOTE(Value) ,' WHERE RefID = ', PropertyID ,' AND LanguageID = ', LanguageID,';');
                    PREPARE stmt1 FROM @TN; 
                    EXECUTE stmt1;
                    
            ELSE
               SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`RefID`, `LanguageID`, `Translation`) VALUES (', PropertyID,',', LanguageID,',', QUOTE(Value) ,');');
                    PREPARE stmt1 FROM @TN; 
                    EXECUTE stmt1;
            END IF;
        ELSE
          SET @TN:= CONCAT('DELETE from ',TableName ,' where RefID=', PropertyID,' AND LanguageID=', LanguageID, ';');
            PREPARE stmt1 FROM @TN; 
            EXECUTE stmt1;
        END IF;        
        END IF;
    
      
                                                          
    END IF;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `UpdateOrganization`(In pw VARCHAR(20), IN Un VARCHAR(50), IN OrgName VARCHAR(100), Add1_Delete2 INT(11))
BEGIN
 
    -- Check Table U1 exists
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PE INT(11);
    DECLARE OID INT(11);
    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
        
  -- if yes return Table -> as it is available to anybody (no permissions required)
    IF count > 0 THEN       
        -- Check if requested Parameters exists already;
        
        SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
        
         -- Get OrganizationID
        SET OID = (SELECT OrganizationID FROM O1T WHERE OrganizationName = OrgName);
        SET PE =  (SELECT COUNT(*) FROM U1_O1A WHERE OrganizationID = OID AND UserID = UID);
        
            IF Add1_Delete2 = 1 AND PE = 0 THEN
                INSERT IGNORE `U1_O1A` (`Pk`, `UserID`, `OrganizationID`) VALUES ('', UID,  OID); 
            END IF;
            IF Add1_delete2 = 2 THEN
                DELETE from U1_O1A where UserID=UID AND OrganizationID=OID;
            END IF;
 
    END IF;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `UpdatePermission`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PermissionID INT(11), IN StartValidity VARCHAR(30), IN EndValidity VARCHAR(30), IN OrgID INT(11), IN ServiceID INT(11), IN RemovePermission BOOL)
BEGIN
 
    -- Check Table U1 exists
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PE INT(11);
        
    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
    
    IF count > 0 THEN     
            IF Tablename = 'P1A' THEN  
                SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
                SET PE = (SELECT COUNT(*) FROM P1A WHERE (OrganizationID = OrgID) AND ServiceID = ServiceID AND UserID = UID AND PermissionTypeID = PermissionID);
                       
                IF RemovePermission = 1 then
                    DELETE from P1A WHERE (OrganizationID = OrgID) AND ServiceID = ServiceID AND UserID = UID AND PermissionTypeID = PermissionID;
                else
                    IF PE = 0 THEN
                        INSERT IGNORE `P1A` (`Pk`, `UserID`, `ServiceID`, `OrganizationID`, `PermissionTypeID`, `PermissionStartValidity`, `PermissionEndValidity`) VALUES ('', UID, ServiceID, OrgID, PermissionID, StartValidity,EndValidity); 
                    ELSE
                        UPDATE P1A SET PermissionStartValidity = StartValidity WHERE OrganizationID = OrgID AND ServiceID = ServiceID AND UserID = UID AND PermissionTypeID = PermissionID;
                        UPDATE P1A SET PermissionEndValidity = EndValidity WHERE OrganizationID = OrgID AND ServiceID = ServiceID AND UserID = UID AND PermissionTypeID = PermissionID;    
                    END IF;
                END IF;
                                       
               
            END IF;
    END IF;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `UpdateProperty`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PropertyID INT(11), IN Value MEDIUMTEXT CHARSET utf8, IN anyId INT(11), AddReplace1_Add2_Delete3 INT(11), IN oldValue MEDIUMTEXT, IN ServiceIsPublic INT)
BEGIN
 
    -- This class writes all system properties available, basically it differs between 'AddReplace1_Add2_Delete3'.
	-- All tables involved have specific columns - U2 - S2 - S3 ... this is why we need special cases for each.
 
	-- for debug purposes: INSERT IGNORE debug (output) values ('any output');

    -- Check Table U1 exists
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PE INT(11);
    DECLARE TN VARCHAR(200);
    DECLARE TIM VARCHAR(200);
    
    DECLARE ServEntID INT;
    

    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
       
	    -- if yes return Table -> as it is available to anybody (no permissions required)
    IF count > 0 THEN      
     
	SET SQL_SAFE_UPDATES=0;

        -- Set UserID
        SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
     
	    -- Check if requested Parameters exists already
		-- -------------------------------------------------------------------------------------------------------------------------------------------------------------
        IF Tablename = 'U2A1' OR Tablename = 'U2A2' OR Tablename = 'U2A3' OR Tablename = 'U2A4' OR Tablename = 'U2A5' or Tablename = 'U2A6' or Tablename = 'U2A7' THEN        
            SET @TN:= CONCAT('SET @PE = (SELECT COUNT(*) FROM ', TableName, ' WHERE UserPropertiesTypeID = ', PropertyID ,' AND UserID = ', UID ,');');
            PREPARE stmt1 FROM @TN; 
            EXECUTE stmt1;
        END IF;
        IF Tablename = 'O1A1' OR Tablename = 'O1A2' OR Tablename = 'O1A3' OR Tablename = 'O1A4' OR Tablename = 'O1A5' or Tablename = 'O1A6' or Tablename = 'O1A7' THEN
            SET @TN:= CONCAT('SET @PE = (SELECT COUNT(*) FROM ', TableName, ' WHERE UserPropertiesTypeID = ', PropertyID ,' AND OrganizationID = ', anyId ,');');
            PREPARE stmt1 FROM @TN; 
            EXECUTE stmt1;
        END IF;
        IF Tablename = 'S2A1' OR Tablename = 'S2A2' OR Tablename = 'S2A3' OR Tablename = 'S2A4' OR Tablename = 'S2A5' or Tablename = 'S2A6' or Tablename = 'S2A7' THEN
		  SET @TN:= CONCAT('SET @PE = (SELECT COUNT(*) FROM ', TableName, ' WHERE ServicePropertiesTypeId = ', PropertyID ,' AND ServiceID = ', anyId ,');');
            PREPARE stmt1 FROM @TN; 
            EXECUTE stmt1;
		END IF;
		IF Tablename = 'S3A1' OR Tablename = 'S3A2' OR Tablename = 'S3A3' OR Tablename = 'S3A4' OR Tablename = 'S3A5' or Tablename = 'S3A6' or Tablename = 'S3A7' THEN
            SET @TN:= CONCAT('SET @PE = (SELECT COUNT(*) FROM ', TableName, ' WHERE ServiceEntityPropertiesTypeId = ', PropertyID ,' AND ServiceEntityID = ', anyId ,');');
            PREPARE stmt1 FROM @TN; 
            EXECUTE stmt1;

			-- log services issues
			INSERT IGNORE `AMMNT_COMMIT` (`ServiceEntityID`,`ParentServiceID`,`UserID`, `TimeStamp`,`AddReplace1_Add2_Delete3`, `Tablename`, `PropertyID`,`Value`,`OldValue`) VALUES (anyId, (SELECT ParentServiceID From S4 Where ServiceEntityID = anyId), (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un), CURRENT_TIMESTAMP,AddReplace1_Add2_Delete3, Tablename,PropertyID,Value, OldValue);

        END IF;

        IF AddReplace1_Add2_Delete3 = 3 THEN
            IF Tablename = 'U2A1' OR Tablename = 'U2A2' OR Tablename = 'U2A3' OR Tablename = 'U2A4' OR Tablename = 'U2A5' OR Tablename = 'U2A7' THEN
               SET @TN:= CONCAT('DELETE from ',TableName ,' where UserID=', UID,' AND UserPropertiesTypeID=', PropertyID,' AND UserPropertiesTypeValue=', QUOTE(Value) ,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
            IF Tablename = 'U2A6' THEN
                SET @TN:= CONCAT('DELETE from ',TableName ,' where UserID=', UID,' AND UserPropertiesTypeID=', PropertyID, ' AND PK=', Value ,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
			IF Tablename = 'S2A6' THEN
                SET @TN:= CONCAT('DELETE from ',TableName ,' where UserID=', UID,' AND ServicePropertiesTypeID=', PropertyID, ' AND PK=', Value ,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
			IF Tablename = 'S3A6' THEN
                SET @TN:= CONCAT('DELETE from ',TableName ,' where UserID=', UID,' AND ServiceEntityPropertiesTypeID=', PropertyID, ' AND PK=', Value ,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
			
			IF Tablename = 'S2A1' OR Tablename = 'S2A2' OR Tablename = 'S2A3' OR Tablename = 'S2A4' OR Tablename = 'S2A5' OR Tablename = 'S2A7' THEN
               SET @TN:= CONCAT('DELETE from ',TableName ,' where serviceID=', anyId,' AND ServicePropertiesTypeID=', PropertyID,' AND ServicePropertiesTypeValue=', QUOTE(Value) ,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
			END IF;

			IF Tablename = 'S3A1' OR Tablename = 'S3A2' OR Tablename = 'S3A3' OR Tablename = 'S3A4' OR Tablename = 'S3A5' OR Tablename = 'S3A7' THEN
				SET @TN:= CONCAT('DELETE from ',TableName ,' where serviceEntityId=', anyId,' AND ServiceEntityPropertiesTypeID=', PropertyID,' AND ServiceEntityPropertiesTypeValue=', QUOTE(Value) ,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
			END IF;
        
            IF Tablename = 'O1A1' OR Tablename = 'O1A2' OR Tablename = 'O1A3' OR Tablename = 'O1A4' OR Tablename = 'O1A5' or Tablename = 'O1A7' THEN
             SET @TN:= CONCAT('DELETE from ',TableName ,' where OrganizationID=', anyId,' AND UserPropertiesTypeID=', PropertyID,' AND UserPropertiesTypeValue=', QUOTE(Value)   ,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
            IF Tablename = 'O1A6' THEN
                SET @TN:= CONCAT('DELETE from ',TableName ,' where OrganizationID=', anyId,' AND UserPropertiesTypeID=', PropertyID, ' AND PK=', Value ,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
        END IF;
        IF (AddReplace1_Add2_Delete3 = 1 AND @PE = 0) OR AddReplace1_Add2_Delete3 = 2 THEN
            IF Tablename = 'U2A1' OR Tablename = 'U2A2' OR Tablename = 'U2A3' OR Tablename = 'U2A4' OR Tablename = 'U2A5' or Tablename = 'U2A7'  THEN
                SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`UserID`, `UserPropertiesTypeID`, `UserPropertiesTypeValue`, `Hidden`,`IonChangeTimestamp`) VALUES (', UID,',', PropertyID,',', QUOTE(Value) ,', 0,', QUOTE(NOW()),');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
            IF Tablename = 'O1A1' OR Tablename = 'O1A2' OR Tablename = 'O1A3' OR Tablename = 'O1A4' OR Tablename = 'O1A5' or Tablename = 'O1A7' THEN
                SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`OrganizationID`, `UserPropertiesTypeID`, `UserPropertiesTypeValue`, `Hidden`,`IonChangeTimestamp`) VALUES (', anyId,',', PropertyID,',', QUOTE(Value) ,', 0,', QUOTE(NOW()),');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;  
			IF Tablename = 'S2A1' OR Tablename = 'S2A2' OR Tablename = 'S2A3' OR Tablename = 'S2A4' OR Tablename = 'S2A5' or Tablename = 'S2A7' THEN
	
				SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`ServiceID`, `ServicePropertiesTypeID`, `ServicePropertiesTypeValue`, `IonChangeTimestamp`) VALUES (', anyId,',', PropertyID,',', QUOTE(Value) ,',', QUOTE(NOW()),');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
                 SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET IonChangeTimestamp = ',QUOTE(NOW()),' WHERE ServiceID = ', anyId ,' AND ServicePropertiesTypeID = ', PropertyID,' AND ServicePropertiesTypeValue = ' , QUOTE(Value) ,';');
				-- Time Stamp
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
			END IF;
            IF Tablename = 'S3A1' OR Tablename = 'S3A2' OR Tablename = 'S3A3' OR Tablename = 'S3A4' OR Tablename = 'S3A5' or Tablename = 'S3A7' THEN
               IF ServiceIsPublic = 1 then SET UID = -1; END IF;		
			    SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`ServiceEntityID`, `ServiceEntityPropertiesTypeID`, `ServiceEntityPropertiesTypeValue`, `IonChangeTimestamp`, `UserID`, `ParentServiceID`) VALUES (', anyId,',', PropertyID,',', QUOTE(Value) ,',', QUOTE(NOW()),',', UID, ',',(SELECT ParentServiceID From S4 Where ServiceEntityID = anyId) ,');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
                 SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET IonChangeTimestamp = ',QUOTE(NOW()),' WHERE ServiceEntityID = ', anyId ,' AND ServiceEntityPropertiesTypeID = ', PropertyID,' AND ServiceEntityPropertiesTypeValue = ' , QUOTE(Value) ,';');
              -- Time Stamp
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
        END IF;
        IF AddReplace1_Add2_Delete3 =1 AND @PE <> 0 THEN
            IF Tablename = 'U2A1' OR Tablename = 'U2A2' OR Tablename = 'U2A3' OR Tablename = 'U2A4' OR Tablename = 'U2A5' or Tablename = 'U2A7' THEN
                SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET UserPropertiesTypeValue = ',QUOTE(Value),' WHERE UserID = ', UID ,' AND UserPropertiesTypeID = ', PropertyID,' AND UserPropertiesTypeValue = ' , QUOTE(oldValue)  , ' ;');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
                SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET IonChangeTimestamp = ',QUOTE(NOW()),' WHERE UserID = ', anyId ,' AND UserPropertiesTypeID = ', PropertyID,' AND UserPropertiesTypeValue = ' , QUOTE(Value) ,';');
                -- Time Stamp
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
           END IF;
            IF Tablename = 'O1A1' OR Tablename = 'O1A2' OR Tablename = 'O1A3' OR Tablename = 'O1A4' OR Tablename = 'O1A5' or Tablename = 'O1A6' or Tablename = 'O1A7' THEN
                
				IF oldValue <> '-1' THEN
					SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET UserPropertiesTypeValue = ',QUOTE(Value),' WHERE OrganizationID = ', anyId ,' AND UserPropertiesTypeID = ', PropertyID,' AND UserPropertiesTypeValue = ' , QUOTE(oldValue) , ';');
				ELSE
					SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET UserPropertiesTypeValue = ',QUOTE(Value),' WHERE OrganizationID = ', anyId ,' AND UserPropertiesTypeID = ', PropertyID,';');
				END IF;
				PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
			 
                SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET IonChangeTimestamp = ',QUOTE(NOW()),' WHERE OrganizationID = ', anyId ,' AND UserPropertiesTypeID = ', PropertyID,';');
              -- Time Stamp
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;   
			IF  Tablename = 'S2A1' OR Tablename = 'S2A2' OR Tablename = 'S2A3' OR Tablename = 'S2A4' OR Tablename = 'S2A5' or Tablename = 'S2A7' THEN
				IF oldValue <> '-1' THEN
					SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET ServicePropertiesTypeValue = ',QUOTE(Value),' WHERE ServiceID = ', anyId ,' AND ServicePropertiesTypeID = ', PropertyID,' AND ServicePropertiesTypeValue = ' , QUOTE(oldValue) , ';');
				ELSE
					SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET ServicePropertiesTypeValue = ',QUOTE(Value),' WHERE ServiceID = ', anyId ,' AND ServicePropertiesTypeID = ', PropertyID,';');
				END IF;
      
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
                SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET IonChangeTimestamp = ',QUOTE(NOW()),' WHERE ServiceID = ', anyId ,' AND ServicePropertiesTypeID = ', PropertyID,' AND ServicePropertiesTypeValue = ' , QUOTE(Value) ,';');
              -- Time Stamp
				PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
			END IF;
            IF  Tablename = 'S3A1' OR Tablename = 'S3A2' OR Tablename = 'S3A3' OR Tablename = 'S3A4' OR Tablename = 'S3A5' or Tablename = 'S3A7' THEN
               
               -- GetCurrentRevision
               SET ServEntID = (SELECT Revision FROM S4 WHERE ServiceEntityID = anyId);
               
               IF ServEntID > 20000 THEN  SET ServEntID = 1; END IF;        
               
               -- Update Service Entity Revision:
                UPDATE S4 SET Revision = (ServEntID +1) WHERE ServiceEntityID = anyId;


				IF oldValue <> '-1' THEN
					SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET ServiceEntityPropertiesTypeValue = ',QUOTE(Value),' WHERE ServiceEntityID = ', anyId ,' AND ServiceEntityPropertiesTypeID = ', PropertyID,' AND ServiceEntityPropertiesTypeValue = ' , QUOTE(oldValue) , ';');
				ELSE
					SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET ServiceEntityPropertiesTypeValue = ',QUOTE(Value),' WHERE ServiceEntityID = ', anyId ,' AND ServiceEntityPropertiesTypeID = ', PropertyID,';');
				END IF;
      
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
                SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET IonChangeTimestamp = ',QUOTE(NOW()),' WHERE ServiceEntityID = ', anyId ,' AND ServiceEntityPropertiesTypeID = ', PropertyID,' AND ServiceEntityPropertiesTypeValue = ' , QUOTE(Value) ,';');
              -- Time Stamp
				PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;

				-- update public or not
				IF ServiceIsPublic = 1 then 
				SET UID = -1; 
				else
					SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET UserId = ',UID,' WHERE ServiceEntityID = ', anyId ,' AND ServiceEntityPropertiesTypeID = ', PropertyID,' AND ServiceEntityPropertiesTypeValue = ' , QUOTE(Value) ,';');
					PREPARE stmt1 FROM @TN; 
					EXECUTE stmt1;
				END IF;
				
                
                
            END IF;
        END IF;                                                                
    END IF;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `UpdateService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN ServiceID INT, IN ServiceEntityId_ INT, IN OrgID INT, IN IsPublic INT, IN InSearchTag VARCHAR(200))
BEGIN
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PK INT(11);
    
    -- Check the User Exists   
SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
  if count > 0 THEN
   -- Set UserID
    SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
        
    if IsPublic = 1 THEN Set UID = -1; END IF;
   
	Update S4 set searchtags = InSearchTag where ServiceEntityID = ServiceEntityId_ and parentServiceId = ServiceID;

   
  end if;
END ;;
DELIMITER ;
ALTER DATABASE `ofm` CHARACTER SET utf8 COLLATE utf8_general_ci ;
