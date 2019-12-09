
DROP FUNCTION IF EXISTS `checkUserExists`;
DROP FUNCTION IF EXISTS `getUserId`;
DROP PROCEDURE IF EXISTS `ammnt_addSpatialIndexEffectiveDate`;
DROP PROCEDURE IF EXISTS `ammnt_addSpatialIndex`;
DROP PROCEDURE IF EXISTS `ammnt_deleteSpatialIndex`;
DROP PROCEDURE IF EXISTS `execQuery`;
DROP PROCEDURE IF EXISTS `getSpatialIndexChangesOfDates`;
DROP PROCEDURE IF EXISTS `getSpatialIndexTilesChangedOfDates`;
DROP PROCEDURE IF EXISTS `DeleteInheritedService`;
DROP PROCEDURE IF EXISTS `GetServiceEntityRevision`;
DROP PROCEDURE IF EXISTS `GetServiceRevision`;
DROP PROCEDURE IF EXISTS `InheritService`;
DROP PROCEDURE IF EXISTS `QueryTable`;
DROP PROCEDURE IF EXISTS `SetBinary`;
DROP PROCEDURE IF EXISTS `SetLanguagePreference`;
DROP PROCEDURE IF EXISTS `UpdateLangTransEntity`;
DROP PROCEDURE IF EXISTS `UpdateOrganization`;
DROP PROCEDURE IF EXISTS `UpdatePermission`;
DROP PROCEDURE IF EXISTS `UpdateProperty`;
DROP PROCEDURE IF EXISTS `UpdateService`;
DROP PROCEDURE IF EXISTS `ammnt_AddActivityDataRecord`;
DROP PROCEDURE IF EXISTS `ammnt_AddFirAmmnt`;
DROP PROCEDURE IF EXISTS `ammnt_GetFirRevision`;
DROP PROCEDURE IF EXISTS `ammnt_GetNumberOfTodaysCommits`;
DROP PROCEDURE IF EXISTS `ammnt_GetUserActivity`;
DROP PROCEDURE IF EXISTS `ammnt_IdentifyOadServiceEntity`;
DROP PROCEDURE IF EXISTS `ammnt_queryTableFirSpatial`;
DROP PROCEDURE IF EXISTS `ammnt_queryTableFir`;

--
-- Dumping routines for database 'ofm'
--

-- MySQL dump 10.13  Distrib 5.7.26, for Linux (x86_64)
--
-- Host: data.dev.openflightmaps.org    Database: ofm
-- ------------------------------------------------------
-- Server version	5.7.12

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'ofm'
--
/*!50003 DROP FUNCTION IF EXISTS `checkUserExists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` FUNCTION `checkUserExists`(un VARCHAR(100), pw VARCHAR(100)) RETURNS tinyint(1)
BEGIN

DECLARE count INT;

    
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
 


RETURN count > 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `getUserId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` FUNCTION `getUserId`(un VARCHAR(100), pw VARCHAR(100)) RETURNS int(11)
BEGIN
   return (SELECT userid FROM U1T WHERE Password = pw AND Username = un);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ammnt_AddActivityDataRecord` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_AddActivityDataRecord`(In pw VARCHAR(20), IN Un VARCHAR(50), IN record longtext, IN Login TIMESTAMP, IN Logout TIMESTAMP, IN activeMinutes INT)
BEGIN

    
    DECLARE count INT(11);
        
    
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
    
    IF count > 0 THEN     
		INSERT IGNORE `AMMNT_ACTIVITYDATARECORDER` (`UserID`, `record`,`LoginTime`,`LogoutTime`,`ActivityDurationMin`) VALUES ((SELECT UserID FROM U1T WHERE Password = pw AND Username = Un), record, Login,Logout,activeMinutes); 
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ammnt_AddFirAmmnt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ammnt_addSpatialIndex` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
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
 
 
   SET tilesX = 360 * 6;
   SET tilesY = 180 * 6;
	
   
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



   
   DELETE FROM AMMNT_S4_SPATIALINDEX WHERE ServiceEntityId = entityId;
   
   
   DELETE FROM AMMNT_S4_SPATIALINDEX_CHANGES WHERE ServiceEntityId = entityId;

   SET id = 0;

   simple_loop: LOOP         
        
   
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ammnt_addSpatialIndexEffectiveDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `ammnt_addSpatialIndexEffectiveDate`(IN un VARCHAR(100), in pw VARCHAR(100), IN fir INT, IN branchId INT, IN revisionId INT, IN type VARCHAR(100), IN name longtext, IN commitMsg VARCHAR(20000), IN entityId INT, IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective dateTime, in validUntil dateTime)
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

 
   SET tilesX = 360 * 6;
   SET tilesY = 180 * 6;


if checkUserExists(un,pw) then

   
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



   
   DELETE FROM AMMNT_S4_SPATIALINDEX WHERE ServiceEntityId = entityId;

   SET id = 0;

   simple_loop: LOOP         
        
   
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ammnt_deleteSpatialIndex` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `ammnt_deleteSpatialIndex`(IN entityId INT)
BEGIN
 
	DELETE FROM AMMNT_S4_SPATIALINDEX where ServiceEntityId = entityId;
 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ammnt_GetFirRevision` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_GetFirRevision`(In pw VARCHAR(20), IN Un VARCHAR(50),IN Fid INT)
BEGIN
DECLARE count INT;
DECLARE rev DOUBLE;
DECLARE loopCnt DOUBLE;
 
    
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
          
    
    IF count > 0 THEN

        
       set rev = (SELECT SUM(Revision) FROM S4 WHERE ammnt_FirId = Fid);
       WHILE(rev >= 32767 OR loopCnt > 100) DO
		set rev = rev - 32767;
        set loopCnt = loopCnt +1;
		END WHILE;
       select  CONVERT(rev, CHAR(50));
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ammnt_GetNumberOfTodaysCommits` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ammnt_GetUserActivity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_GetUserActivity`(In Pw VARCHAR(50), IN Un VARCHAR(50), IN StartDate DATE, IN EndDate DATE)
BEGIN	

	Select * FROM AMMNT_COMMIT where UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) and (PropertyID=12 or PropertyID=17) AND TimeStamp >= StartDate and TimeStamp <= EndDate  order by TimeStamp desc limit 300; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ammnt_IdentifyOadServiceEntity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_IdentifyOadServiceEntity`(IN Designator VARCHAR(100), IN DataType VARCHAR(100), IN FirID INT)
BEGIN
	SELECT ServiceEntityID FROM S3A3 WHERE (ParentServiceID = 3 OR ParentServiceID = 4) AND (ServiceEntityPropertiesTypeID = 12 AND ServiceEntityPropertiesTypeValue = Designator AND ammnt_FIRID = FirID AND deleted is null);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ammnt_queryTableFir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
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


IF TableName = 'S4' THEN select * FROM S4 WHERE ammnt_FirId = Firid and ParentServiceId = serviceid and (deleted IS NULL or deleted = 0); END if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ammnt_queryTableFirSpatial` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_queryTableFirSpatial`(in tablename varchar(10), in serviceid int, in firid int, in propertyid int,IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE)
BEGIN


   
   DECLARE tilesX BIGINT;
   DECLARE tilesY BIGINT;
   DECLARE startIdx BIGINT;
   DECLARE endIdx BIGINT;
   DECLARE diffX BIGINT;
   DECLARE diffY BIGINT;
   DECLARE id BIGINT;
   DECLARE endVal BIGINT;
   DECLARE loopVal BIGINT;
    DECLARE firstVal BIGINT;

   DROP TEMPORARY TABLE IF EXISTS spatialQuery;     
   CREATE TEMPORARY TABLE spatialQuery (
   tileId BIGINT
   ) ENGINE=memory;

   SET tilesX = 360 * 6;
   SET tilesY = 180 * 6;

   SET startIdx = (tilesX / 360 * lon * tilesY);
   SET endIdx = (tilesX / 360 * (lon + width)) * tilesY;
   SET diffX  = width * tilesX / 360;
   SET diffY  = height * tilesY / 180;
	
    SET id = 0;

   simple_loop: LOOP         
        
      SET startIdx = CEILING(tilesX / 360 * (lon + id * 360 / tilesX)) * tilesY;
	  SET firstVal = startIdx + (lat + 90) / 180 * tilesY;
	  SET endVal   = firstVal + diffy;

       SET loopVal = firstVal;

			  insertLoop: LOOP
				INSERT IGNORE spatialQuery (tileId) VALUES (loopVal);

				 SET loopVal=loopVal+1;
				 IF loopVal>endVal THEN
					LEAVE insertLoop;
				 END IF;
			  END LOOP insertLoop;
 

         SET id=id+1;
         IF id>=diffX THEN
            LEAVE simple_loop;
         END IF;
   END LOOP simple_loop;


set loopVal = (0 + 90) / 180 * tilesY;
INSERT IGNORE spatialQuery (tileid) VALUES (loopVal);

 

IF TableName = 'S3A1' THEN SELECT * FROM S3A1 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT tileid FROM spatialQuery)); END IF;
IF TableName = 'S3A2' THEN SELECT * FROM S3A2 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT tileid FROM spatialQuery)); END IF;
IF TableName = 'S3A3' THEN SELECT * FROM S3A3 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT tileid FROM spatialQuery)); END IF;
IF TableName = 'S3A4' THEN SELECT * FROM S3A4 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT tileid FROM spatialQuery)); END IF;
IF TableName = 'S3A5' THEN SELECT * FROM S3A5 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT tileid FROM spatialQuery));  END IF;
IF TableName = 'S3A6' THEN SELECT * FROM S3A6 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT tileid FROM spatialQuery)); END IF;
IF TableName = 'S3A7' THEN SELECT * FROM S3A7 WHERE ServiceEntityPropertiesTypeID = propertyid AND parentserviceid = serviceid and firid = ammnt_firid and (deleted IS NULL or deleted = 0) and serviceEntityId IN (select DISTINCT serviceEntityId FROM AMMNT_S4_SPATIALINDEX where tileId in (SELECT tileid FROM spatialQuery)); END IF;


IF TableName = 'S4' THEN select * FROM S4 WHERE ammnt_FirId = Firid and ParentServiceId = serviceid and (deleted IS NULL or deleted = 0); END if;

 -- select * from spatialQuery; -- debug

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DeleteInheritedService` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `DeleteInheritedService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN InhServId INT)
BEGIN
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PK INT(11);
    
    
SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
  if count > 0 THEN
  
  
       
  
	 UPDATE S4 set deleted = 1 where ServiceEntityID = InhServId;
	 UPDATE S3A1 set deleted = 1 where ServiceEntityID = InhServId;
	 UPDATE S3A2 set deleted = 1 where ServiceEntityID = InhServId;
	 UPDATE S3A3 set deleted = 1 where ServiceEntityID = InhServId;
	 UPDATE S3A4 set deleted = 1 where ServiceEntityID = InhServId;
	 UPDATE S3A5 set deleted = 1 where ServiceEntityID = InhServId;	
	 UPDATE S3A6 set deleted = 1 where ServiceEntityID = InhServId;

  
  
  
  
  
  
  
  
  



INSERT IGNORE `AMMNT_COMMIT` (`ServiceEntityID`,`ParentServiceID`,`UserID`, `TimeStamp`,`AddReplace1_Add2_Delete3`) VALUES (PK + 1, InhServId, (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un), CURRENT_TIMESTAMP,2);

  end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `execQuery` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `execQuery`(IN qry VARCHAR(20000))
BEGIN
                   PREPARE stmt1 FROM @qry; 
                EXECUTE stmt1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getBinary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `getBinary`(In un VARCHAR(20), IN pw VARCHAR(50), IN TableName VARCHAR(10),IN PK_ LONG, in serviceEntityId_ LONG)
BEGIN

   DECLARE count INT(11);
   SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = un);
        
	IF count > 0 THEN     

		if Tablename = "S3A6" then
			SELECT ServiceEntityPropertiesTypeValue FROM ofm.S3A6 where PK=PK_ and serviceEntityId=serviceEntityId_;
		end if;
		if Tablename = "U2A6" then
			SELECT ServiceEntityPropertiesTypeValue FROM ofm.U2A6 where PK=PK_ and serviceEntityId=serviceEntityId_;
		end if;
 		if Tablename = "O1A6" then
			SELECT ServiceEntityPropertiesTypeValue FROM ofm.O1A6 where PK=PK_ and serviceEntityId=serviceEntityId_;
		end if;
 
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetServiceEntityRevision` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `GetServiceEntityRevision`(IN EntityID INT)
BEGIN
	SELECT Revision from S4 Where serviceEntityID = EntityID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetServiceRevision` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `GetServiceRevision`(In pw VARCHAR(20), IN Un VARCHAR(50),IN AnyID INT, IN Service1_ServiceEntity2 INT)
BEGIN

 DECLARE count INT(11);
 
    
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
          
    
    IF count > 0 THEN

        
        SELECT SUM(Revision) FROM S4 WHERE ParentServiceID = AnyID;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getSpatialIndexChangesOfDates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `getSpatialIndexChangesOfDates`(IN un VARCHAR(100), in pw VARCHAR(100), IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective datetime, in validUntil datetime)
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
 

   DROP TEMPORARY TABLE IF EXISTS spatialQuery;     
   CREATE TEMPORARY TABLE spatialQuery (
   serviceEntityId BIGINT
   ) ENGINE=memory;

 
   SET tilesX = 360 * 6;
   SET tilesY = 180 * 6;

   SET startIdx = FLOOR(tilesX / 360 * lon) * tilesY;
   SET endIdx = FLOOR(tilesX / 360 * (lon + width)) * tilesY;
   SET diffX  = width * tilesX / 360;
   SET diffY  = height * tilesY / 180;
	
   SET id = 0;

   simple_loop: LOOP         
        
   
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


set loopVal = (0 + 90) / 180 * tilesY;
INSERT IGNORE spatialQuery (serviceEntityId) VALUES (loopVal);

select distinct fir,serviceEntityId,name,type,commitMsg,userId,effectiveDate,validUntilDate from AMMNT_S4_SPATIALINDEX_CHANGES  where tileId in (select * from spatialQuery) and ((effectiveDate > effective and effectiveDate < validUntil) or (validUntilDate > effective and validUntilDate < validUntil))  order by effectiveDate desc;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getSpatialIndexTilesChangedOfDates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `getSpatialIndexTilesChangedOfDates`(IN un VARCHAR(100), in pw VARCHAR(100), IN lon DOUBLE, IN lat DOUBLE, IN width DOUBLE, IN height DOUBLE, IN effective datetime, in validUntil datetime)
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
 

   DROP TEMPORARY TABLE IF EXISTS spatialQuery;     
   CREATE TEMPORARY TABLE spatialQuery (
   serviceEntityId BIGINT
   ) ENGINE=memory;

 
 if checkUserExists(un,pw) then
 

 
   SET tilesX = 360 * 6;
   SET tilesY = 180 * 6;

   SET startIdx = FLOOR(tilesX / 360 * lon) * tilesY;
   SET endIdx = FLOOR(tilesX / 360 * (lon + width)) * tilesY;
   SET diffX  = width * tilesX / 360;
   SET diffY  = height * tilesY / 180;
	
   SET id = 0;

   simple_loop: LOOP         
        
   
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InheritService` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `InheritService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN ServiceID INT, IN OrgID INT, IN IsPublic INT, IN InSearchTag VARCHAR(200))
BEGIN
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PK INT(11);
    
    
SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
  if count > 0 THEN
   
    SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
        
    if IsPublic = 1 THEN Set UID = -1; END IF;
        
    SET PK = (SELECT ServiceEntityID FROM S4 ORDER BY ServiceEntityID DESC LIMIT 1);
 
    INSERT IGNORE `S4` (`ServiceEntityID`,`ParentServiceID`, `OrganizationID`, `UseriD`, `Revision`, `searchTags`) VALUES (PK+1, ServiceID,OrgID,UID,1,InSearchTag);
      


	
	



   SELECT PK+1;
  end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `QueryTable` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `QueryTable`(In Un VARCHAR(50), IN Pw VARCHAR(50), IN TableName VARCHAR(10), IN AnyID INT(11), IN AnyID2 INT(11), IN AnyValue VARCHAR(500))
BEGIN


    
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE TN VARCHAR(5);
  
    
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
          
    
    IF count > 0 THEN
            IF TableName = 'G1T' THEN SELECT * FROM G1T ORDER BY LanguageID;END IF;
            IF TableName = 'G2T' THEN SELECT * FROM G2T ORDER BY CountryID; END IF;
            IF TableName = 'G5T' THEN SELECT * FROM G5T WHERE SystemsIconsID = AnyID; END IF;
            IF TableName = 'U2T' THEN SELECT * FROM U2T ORDER BY UserPropertiesTypeID;END IF;
          
            IF TableName = 'U1Com' THEN 
                IF (SELECT COUNT(*) FROM P1A WHERE UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) AND (SELECT PermissionsTypeID FROM P1T WHERE PermissionsTypeDescription = 'ION User Administration')) > 0 THEN
                    
                    SELECT * FROM U1T;
                END IF;
            END IF;
                 
            IF TableName = 'U3T' THEN SELECT * FROM U3T;END IF;
            IF TableName = 'U1T' THEN SELECT * FROM U1T WHERE Password = pw AND Username = Un; END IF;
            IF TableName = 'P1T' THEN SELECT * FROM P1T;END IF;
            IF TableName = 'O1T' THEN SELECT * FROM O1T;END IF;
            IF TableName = 'S5T' THEN SELECT * FROM S5T; END IF;
            IF TableName = 'S3T' THEN SELECT * FROM S3T; END IF;
            
            
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
              
             
             IF TableName = 'S1T' THEN SELECT * FROM S1T WHERE OrganizationID = 0; END IF;
             IF TableName = 'S2T' THEN SELECT * FROM S2T; END IF;
             
            
            IF TableName = 'U2A1' OR TableName ='U2A2' OR TableName ='U2A3' OR TableName ='U2A4' OR TableName ='U2A5' OR TableName ='U2A6' OR TableName ='U2A7' OR TableName ='U1_O1A' THEN 
                SET @TN:= CONCAT('SELECT * FROM ', Tablename , ' WHERE UserID =', (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) , ';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
                
            
            IF TableName = 'O1A1' OR TableName ='O1A2' OR TableName ='O1A3' OR TableName ='O1A4' OR TableName ='O1A5' OR TableName ='O1A6' OR TableName ='O1A7' THEN
                SET @TN:= CONCAT('SELECT * FROM ', Tablename , ' WHERE OrganizationID = ', AnyID,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;
                                     
                                     
            IF TableName = 'U1_O1A' THEN  SELECT * FROM U1_O1A WHERE UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un); END IF;
            IF TableName = 'P1A' THEN  SELECT * FROM P1A WHERE UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un); END IF;            
            
            
            
            
			
			
			
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
                    
                       
            
            
            IF TableName = 'AMMNT_FIR' THEN SELECT * FROM AMMNT_FIR; END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SetBinary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `SetBinary`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), PropertyID INT(11), IN BL LONGBLOB, OrgID INT(11), IN oldRef VARCHAR(20), IN ServiceIsPublic INT)
BEGIN
 
    
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE EXIST VARCHAR(11);
    DECLARE EXISTCNTR INT(11);
    
    DECLARE ServEntID INT;
   
    
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
        
    
    IF count > 0 THEN      
    
        
        SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
                 
        IF Tablename = 'U2A6' THEN
              
			
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
         
                
               SET ServEntID = (SELECT Revision FROM S4 WHERE ServiceEntityID = OrgID);
               
               IF ServEntID > 20000 THEN  SET ServEntID = 1; END IF;        
               
               
               UPDATE S4 SET Revision = (ServEntID +1) WHERE ServiceEntityID = OrgID;
               
				
				
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SetLanguagePreference` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `SetLanguagePreference`(In pw VARCHAR(20), IN Un VARCHAR(50), IN LanguageID INT(11))
BEGIN
 
    
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PE INT(11);
    DECLARE TN VARCHAR(200);
    DECLARE TIM VARCHAR(200);
    
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
        
    
    IF count > 0 THEN      
    
        
        SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
        
        UPDATE U1T SET MainlanguagePref = LanguageID WHERE UserID = UID;
            
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateLangTransEntity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `UpdateLangTransEntity`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PropertyID INT(11), IN Value VARCHAR(1000), IN LanguageID INT(11))
BEGIN
 
    
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PE INT(11);
    DECLARE TN VARCHAR(200);
    DECLARE TIM VARCHAR(200);
    
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
        
    
    IF count > 0 THEN      
    
     
        if TableName = 'G4T' THEN
         SET @TN:= CONCAT('INSERT IGNORE `',TableName,'` (`SystemTextKey`, `Format`) VALUES (', QUOTE(Value),',', 2 ,');');
            PREPARE stmt1 FROM @TN; 
            EXECUTE stmt1;
        ELSE
          
       
        
     
        
        
        
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateOrganization` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `UpdateOrganization`(In pw VARCHAR(20), IN Un VARCHAR(50), IN OrgName VARCHAR(100), Add1_Delete2 INT(11))
BEGIN
 
    
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PE INT(11);
    DECLARE OID INT(11);
    
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
        
  
    IF count > 0 THEN       
        
        
        SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
        
         
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdatePermission` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `UpdatePermission`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PermissionID INT(11), IN StartValidity VARCHAR(30), IN EndValidity VARCHAR(30), IN OrgID INT(11), IN ServiceID INT(11), IN RemovePermission BOOL)
BEGIN
 
    
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PE INT(11);
        
    
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateProperty` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `UpdateProperty`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), IN PropertyID INT(11), IN Value MEDIUMTEXT CHARSET utf8, IN anyId INT(11), AddReplace1_Add2_Delete3 INT(11), IN oldValue MEDIUMTEXT, IN ServiceIsPublic INT)
BEGIN
 
    
	
 
	

    
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PE INT(11);
    DECLARE TN VARCHAR(200);
    DECLARE TIM VARCHAR(200);
    
    DECLARE ServEntID INT;
    

    
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
       
	    
    IF count > 0 THEN      
     
	SET SQL_SAFE_UPDATES=0;

        
        SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
     
		if ServiceIsPublic = 1 then set UID=-1; END IF;
	    
		
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
				
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
			END IF;
            IF Tablename = 'S3A1' OR Tablename = 'S3A2' OR Tablename = 'S3A3' OR Tablename = 'S3A4' OR Tablename = 'S3A5' or Tablename = 'S3A7' THEN
               IF ServiceIsPublic = 1 then SET UID = -1; END IF;		
			    SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`ServiceEntityID`, `ServiceEntityPropertiesTypeID`, `ServiceEntityPropertiesTypeValue`, `IonChangeTimestamp`, `UserID`, `ParentServiceID`) VALUES (', anyId,',', PropertyID,',', QUOTE(Value) ,',', QUOTE(NOW()),',', UID, ',',(SELECT ParentServiceID From S4 Where ServiceEntityID = anyId) ,');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
                 SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET IonChangeTimestamp = ',QUOTE(NOW()),' WHERE ServiceEntityID = ', anyId ,' AND ServiceEntityPropertiesTypeID = ', PropertyID,' AND ServiceEntityPropertiesTypeValue = ' , QUOTE(Value) ,';');
              
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
              
				PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
			END IF;
            IF  Tablename = 'S3A1' OR Tablename = 'S3A2' OR Tablename = 'S3A3' OR Tablename = 'S3A4' OR Tablename = 'S3A5' or Tablename = 'S3A7' THEN
               
               
               SET ServEntID = (SELECT Revision FROM S4 WHERE ServiceEntityID = anyId);
               
               IF ServEntID > 20000 THEN  SET ServEntID = 1; END IF;        
               
               
                UPDATE S4 SET Revision = (ServEntID +1) WHERE ServiceEntityID = anyId;


				IF oldValue <> '-1' THEN
					SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET ServiceEntityPropertiesTypeValue = ',QUOTE(Value),' WHERE ServiceEntityID = ', anyId ,' AND ServiceEntityPropertiesTypeID = ', PropertyID,' AND ServiceEntityPropertiesTypeValue = ' , QUOTE(oldValue) , ';');
				ELSE
					SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET ServiceEntityPropertiesTypeValue = ',QUOTE(Value),' WHERE ServiceEntityID = ', anyId ,' AND ServiceEntityPropertiesTypeID = ', PropertyID,';');
				END IF;
      
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
                SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET IonChangeTimestamp = ',QUOTE(NOW()),' WHERE ServiceEntityID = ', anyId ,' AND ServiceEntityPropertiesTypeID = ', PropertyID,' AND ServiceEntityPropertiesTypeValue = ' , QUOTE(Value) ,';');
              
				PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;

				
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateService` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `UpdateService`(In Un VARCHAR(50), IN pw VARCHAR(50), IN ServiceID INT, IN ServiceEntityId_ INT, IN OrgID INT, IN IsPublic INT, IN InSearchTag VARCHAR(200))
BEGIN
    DECLARE count INT(11);
    DECLARE UID INT(11);
    DECLARE PK INT(11);
    
    
SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
  if count > 0 THEN
   
    SET UID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un);
        
    if IsPublic = 1 THEN Set UID = -1; END IF;
   
	Update S4 set searchtags = InSearchTag where ServiceEntityID = ServiceEntityId_ and parentServiceId = ServiceID;

   
  end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-12-09 14:25:26
