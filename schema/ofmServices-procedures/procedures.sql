--
-- Dumping routines for database 'ofmServices'
--
DELIMITER ;;
CREATE DEFINER=`admin`@`%` FUNCTION `checkUserExists`(un VARCHAR(100), pw VARCHAR(100)) RETURNS tinyint(1)
BEGIN

DECLARE count INT;

    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
 


RETURN count > 0;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` FUNCTION `credit_getNewpCode`() RETURNS varchar(200) CHARSET latin1
BEGIN
declare pCode VARCHAR(200);
declare cnt INT;

set cnt = 0;
pCodeLoop: LOOP
set cnt = cnt + 1;
	set pCode = MD5(RAND());
		 IF (select count(*) from CDT where proprietorCode = pCode) = 0 or cnt > 10 THEN
			
			leave pCodeLoop;
		 END IF;
	END LOOP pCodeLoop;
    
    return pCode;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` FUNCTION `getChecksum`(pCode VARCHAR(100)) RETURNS varchar(5) CHARSET latin1
BEGIN
declare pCodeString VARCHAR(1000);

set pCodeString = (SELECT sum(id) FROM CDT where proprietorCode = pCode);
	
if LENGTH(pCodeString) >4 then
  RETURN RIGHT(pCodeString,5);
else
	RETURN pCodeString;
end if;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_GetFirRevision`(In pw VARCHAR(20), IN Un VARCHAR(50),IN Fid INT)
BEGIN
DECLARE count DOUBLE;
 
    -- Check the User Exists   
    SET count = (SELECT COUNT(*) FROM U1T WHERE Password = pw AND Username = Un);
          
    -- if yes return Table -> as it is available to anybody (no permissions required)
    IF count > 0 THEN

        -- To get the Service-Revision: Add all Service-Entity-Revisions to a number, as they are always growing this is a unique ID.
        SELECT SUM(Revision) FROM S4 WHERE ammnt_FirId = Fid;
    END IF;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `ammnt_GetNumberOfTodaysCommits`(un VARCHAR(20), IN pw VARCHAR(50))
BEGIN
IF checkUserExists(un,pw) THEN
     (SELECT count( distinct (serviceEntityId)) FROM ofm.AMMNT_COMMIT WHERE ParentServiceID = 3 AND timestamp > DATE_SUB(NOW(), INTERVAL 24 HOUR));
  END IF;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `ammnt_getOfmLatestCommits`(IN un VARCHAR(100), IN pw VARCHAR(100), IN firId INT, IN hours INT)
BEGIN
if checkUserExists(un, pw) then

  DROP TEMPORARY TABLE IF EXISTS entityIds;     -- make sure it doesnt already exist
   CREATE TEMPORARY TABLE entityIds (
   serviceEntityId BIGINT,
   primary key(serviceEntityId) -- do we want to enforce array as a set?
   ) ENGINE=memory;

	INSERT INTO entityIds SELECT DISTINCT serviceEntityId FROM ofm.AMMNT_COMMIT where parentserviceid=3 and (propertyId=0 and value=firId) and timestamp >= DATE_ADD(CURDATE(), INTERVAL -3 DAY); 

	select * FROM ofm.AMMNT_COMMIT where serviceEntityId IN (select serviceEntityId from entityIds) and  parentserviceid=3 and timestamp >= DATE_ADD(CURDATE(), INTERVAL -hours HOUR);
end if;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `credit_createCredit`(IN amount INT,IN cover VARCHAR(10000), IN creator VARCHAR(1000), IN accountDesignator VARCHAR(1000), IN accountEmail VARCHAR(1000))
BEGIN

DECLARE pCode VARCHAR(1000);
DECLARE firstVal BIGINT;
DECLARE loopVal BIGINT;
DECLARE timest DATETIME;
set firstVal = 0;
set loopVal = 1;
set timest = NOW();
if amount < 1000001  then
 
-- first account does not exist already
if (select count(id) from CDT where accountDesignator = accountDesignator and email = accountEmail) > 0 then
	set pCode = (select proprietorCode from CDT where accountDesignator = accountDesignator and email = accountEmail limit 1);
      insertLoop1: LOOP
		 INSERT INTO `ofmServices`.`CDT`
		(`creator`,
		`cover`,
		`proprietorCode`,
		`accountDesignator`,
		`email`, `blockSize`,
        `lastTransaction`)
		VALUES
		(creator,
		cover,
		pCode,
		accountDesignator,
		accountEmail,
        amount,
        timest
		);
	 SET loopVal=loopVal+1;
		 IF loopVal>amount THEN
			LEAVE insertLoop1;
		 END IF;
	END LOOP insertLoop1;
else
	set pCode = credit_getNewpCode();
	insertLoop2: LOOP
	INSERT INTO `ofmServices`.`CDT`
	(`creator`,
	`cover`,
	`proprietorCode`,
	`email`,
	`accountDesignator`,
    `blockSize`,
	`lastTransaction`)
	VALUES
	(creator,
	cover,
	pCode,
	accountEmail,
	accountDesignator,
    amount,
	timest);
     SET loopVal=loopVal+1;
		 IF loopVal>amount THEN
			LEAVE insertLoop2;
		 END IF;
	END LOOP insertLoop2;
end if;
select pCode;
else
select 'amount too big';
end if;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `credit_getBalance`(IN pCode VARCHAR(1000), IN accountDesig VARCHAR(1000))
BEGIN
	SELECT count(id) FROM CDT where proprietorCode = pCode and accountDesignator = accountDesig;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `credit_getChecksum`(IN pCode VARCHAR(1000))
BEGIN

SELECT getChecksum(pCode);
    

END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `credit_getLastTransaction`(IN pCode VARCHAR(1000), IN accountDesig VARCHAR(1000))
BEGIN
	SELECT distinct lastTransactionDesignation FROM CDT where proprietorCode = pCode and accountDesignator = accountDesig order by lastTransaction desc;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `credit_getLastTransactionDate`(IN pCode VARCHAR(1000), IN accountDesig VARCHAR(1000))
BEGIN
	SELECT distinct lastTransaction FROM CDT where proprietorCode = pCode and accountDesignator = accountDesig order by lastTransaction desc limit 1;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `credit_getTransactions`(IN pCode VARCHAR(1000), IN accountDesig VARCHAR(1000))
BEGIN

	-- SELECT COUNT(*),lastTransactionDesignation,lastTransaction,  creator, token,cover,blockSize,sender,email,senderEmail
	-- FROM CDT where proprietorCode = pCode and accountDesignator = accountDesig
	-- GROUP BY lastTransaction  order by lastTransaction desc;
    
SELECT CDT.*,C
FROM   CDT,
     ( SELECT lastTransaction, MIN(ID) ID, count(*) c
       FROM   CDT
       GROUP  BY lastTransaction
     ) a
WHERE  a.id = CDT.id
AND    proprietorCode = pCode
and    accountDesignator = accountDesig
order by lastTransaction desc ;
    
 END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `credit_transmit`(IN pCode VARCHAR(1000), IN senderChecksum DOUBLE, IN addressee VARCHAR(1000),amount INT,msg VARCHAR(1000),addresseeEmail VARCHAR(1000), optional_validationCode VARCHAR(4))
BEGIN
	-- check sender has enough credit
  declare senderServerCredit INT;
  declare senderServerChecksum DOUBLE;
  declare adresseeExists BOOL;
  declare adresseeProprietor VARCHAR(1000);
  declare abortTransaction BOOL; 
  
  declare emailValCode VARCHAR(10);
 
  declare senderEmail VARCHAR(1000);
  declare sender VARCHAR(1000);
 
  
  set abortTransaction = false;
  set senderServerCredit = (SELECT count(*) FROM CDT where proprietorCode = pCode);
    
    
  if senderServerCredit < amount then
	select 'error','insufficientCreditBalance';
	set abortTransaction = true;
  end if;
  
  -- check addressee exists
  set adresseeExists = (SELECT count(ProprietorCode) from CDT where accountDesignator = addressee and email = addresseeEmail) > 0;
  
  if adresseeExists = false and abortTransaction=false then
  
	  -- check optional validation code fits or activation done by the NEW user
	  if optional_validationCode = (select validationCode from CDT_VAL where emailAddress = addresseeEmail) or (select validated from CDT_VAL where emailAddress = addresseeEmail) then
		
           
		-- add the new account
		set adresseeProprietor = credit_getNewpCode();
	  else
		 
      -- check new account desig not existent
      if (SELECT count(*) from CDT where accountDesignator = addressee) > 0 then
      	select 'error','accountNameNotpossible';
        set abortTransaction = true;
      else
	  -- register emailAdress to be verified
		set emailValCode = floor(0+ RAND() * 10000);
		INSERT IGNORE CDT_VAL (emailAddress,validationCode,validUntil,requestedByEmail,latch_amount,latch_proprietor,latch_addressee,latch_purpose) values (addresseeEmail,emailValCode,ADDTIME(now(), '02:00:00'),(SELECT email FROM CDT where proprietorCode = pCode limit 1),amount,pCode,addressee,msg);
		set abortTransaction = true;
		select 'validation required','newAccount',addresseeEmail,ADDTIME(now(), '02:00:00'),emailValCode;
        set abortTransaction = true;
		end if;
      end if;

 
	  -- cleanup job of table
      DELETE FROM CDT_VAL WHERE validUntil < NOW();
 
  else
	set adresseeProprietor = (select proprietorCode from CDT where accountDesignator = addressee  limit 1);
  end if;
      
-- check checksum fits
  set senderServerChecksum = getChecksum(pCode);
  if senderServerChecksum <> senderChecksum and abortTransaction = false then
   set senderEmail =  (select email from CDT where proprietorCode = pCode  limit 1);
	select 'error','wrongChecksum', getChecksum(pCode),senderEmail;
    set abortTransaction = true;
  end if;
      
  -- finally do transaction
  if abortTransaction = false  then
 
		-- cleanup as not anymore needed
		DELETE FROM CDT_VAL WHERE emailAddress = addresseeEmail;
      
	  DROP TABLE IF EXISTS idsToMigrate;     -- make sure it doesnt already exist
	   CREATE TABLE idsToMigrate (
	   id BIGINT,
	   accountDesignator VARCHAR(1000),
       email VARCHAR(1000),
	   PRIMARY KEY (`id`)
	   ) ;
	  
	  INSERT INTO idsToMigrate (id,accountDesignator,email)  
	  SELECT id,accountDesignator,email from CDT where proprietorCode = pCode order by lastTransaction asc limit amount;
	   
       set senderEmail = (select email from idsToMigrate limit 1);
       set sender =  (select accountDesignator from idsToMigrate limit 1);
         
	 SET SQL_SAFE_UPDATES = 0;
	 update CDT set proprietorCode = adresseeProprietor, 
     accountDesignator = addressee,
     lastTransactionDesignation = msg,
     email = addresseeEmail,
     lastTransaction = now(),
     sender = sender,
     senderEmail = senderEmail,
     blockSize = amount
     where id in (select id from idsToMigrate);
     
	  select 'success','transactionCompleted',amount,adresseeProprietor,senderEmail;
 end if;


END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `credit_transmitToNewAccount`(IN pCode VARCHAR(1000), IN senderChecksum BIGINT,amount INT,msg VARCHAR(1000),IN addNewAccountUserEmail VARCHAR(1000), IN addNewAccountDesignator VARCHAR(1000))
BEGIN
	-- check sender has enough credit
  declare senderServerCredit INT;
  declare senderServerChecksum INT;
  declare adresseeExists BOOL;
  declare adresseeProprietor VARCHAR(1000);
  declare abortTransaction BOOL; 
  set abortTransaction = false;
  set senderServerCredit = (SELECT count(*) FROM CDT where proprietorCode = pCode);
    
  -- check checksum fits
  set senderServerChecksum = (select sum(id) FROM CDT where proprietorCode = pCode);
  if senderServerChecksum <> senderChecksum then
	select 'error','wrong checksum!';
    set abortTransaction = true;
  end if;
    
  if senderServerCredit < amount then
	select 'error','insufficient credit balance!';
	set abortTransaction = true;
  end if;
  
  set adresseeExists = (select count(proprietorCode) from CDT where email = addNewAccountUserEmail and accountDesignator= addNewAccountDesignator) > 0;
if adresseeExists then
	select 'error','addressee already exists!';
	set abortTransaction = true;
  end if;
  
  -- add the new account
  set adresseeProprietor = MD5(RAND());
  
  -- finally do transaction
  if abortTransaction = false  then
 
	  DROP TEMPORARY TABLE IF EXISTS idsToMigrate;     -- make sure it doesnt already exist
	   CREATE TEMPORARY TABLE idsToMigrate (
	   id BIGINT,
       accountDesignator VARCHAR(1000),
       email VARCHAR(1000),
	   PRIMARY KEY (`id`)
	   )  ENGINE=memory;
	  
	  INSERT INTO idsToMigrate (id,sender,email) 
	  SELECT id from CDT where proprietorCode = pCode order by lastTransaction asc limit amount;
	   
	 SET SQL_SAFE_UPDATES = 0;
	 update CDT set proprietorCode = adresseeProprietor where id in (select id from idsToMigrate);
	 update CDT set accountDesignator = addNewAccountDesignator where id in (select id from idsToMigrate);
	 update CDT set lastTransactionDesignation = msg where id in (select id from idsToMigrate);
     update CDT set email = addNewAccountUserEmail where id in (select id from idsToMigrate);
	 update CDT set lastTransaction = now() where id in (select id from idsToMigrate);
     update CDT set sender = (select accountDesignator from idsToMigrate limit 1) where id in (select id from idsToMigrate);
     update CDT set senderEmail = (select email from idsToMigrate limit 1) where id in (select id from idsToMigrate);

	SELECT * from idsToMigrate;
 end if;
 

END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `credit_validateEmail`(IN email varchar(200),IN  valCode varchar(4))
BEGIN
-- check if exist
if (select count(*) from CDT_VAL  where emailAddress=email and validationCode = valCode) > 0 then

    update CDT_VAL set validated = true  where emailAddress=email and validationCode = valCode;
 	select * from CDT_VAL where emailAddress=email ;
else
	select 'failed';
end if;
END ;;
DELIMITER ;
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
     
	if (SELECT count(*) FROM information_schema.tables where table_name='S3A1' and TABLE_SCHEMA=DATABASE()) > 0 then
		UPDATE S3A1 set deleted = 1 where ServiceEntityID = InhServId;
     end if;
	if (SELECT  count(*) FROM information_schema.tables where table_name='S3A2' and TABLE_SCHEMA=DATABASE()) > 0 then
		UPDATE S3A2 set deleted = 1 where ServiceEntityID = InhServId;
     end if;	 
	if (SELECT  count(*) FROM information_schema.tables where table_name='S3A3' and TABLE_SCHEMA=DATABASE()) > 0 then
		UPDATE S3A3 set deleted = 1 where ServiceEntityID = InhServId;
     end if;
	if (SELECT  count(*) FROM information_schema.tables where table_name='S3A4' and TABLE_SCHEMA=DATABASE()) > 0 then
		UPDATE S3A4 set deleted = 1 where ServiceEntityID = InhServId;
     end if;
	if (SELECT  count(*) FROM information_schema.tables where table_name='S3A5' and TABLE_SCHEMA=DATABASE()) > 0 then
		UPDATE S3A5 set deleted = 1 where ServiceEntityID = InhServId;
     end if;	 
	if (SELECT  count(*) FROM information_schema.tables where table_name='S3A6' and TABLE_SCHEMA=DATABASE()) > 0 then
		UPDATE S3A6 set deleted = 1 where ServiceEntityID = InhServId;
     end if;
	if (SELECT  count(*) FROM information_schema.tables where table_name='S3A7' and TABLE_SCHEMA=DATABASE()) > 0 then
		UPDATE S3A7 set deleted = 1 where ServiceEntityID = InhServId;
     end if;

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
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `getOfmLatestCommits`(IN un VARCHAR(100), IN pw VARCHAR(100))
BEGIN
if userExists(un, pw) then
	select * from ofm.U1T order by PK limit 100;
end if;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `GetServiceEnitityPropertiesByParentalService`(IN TableName VARCHAR(15),IN ParentServID INT, IN PropertyTypeID INT, IN PropValue VARCHAR(200))
BEGIN

DECLARE done INT DEFAULT FALSE;
DECLARE ServiceEntID INT;
  DECLARE cur1 CURSOR FOR SELECT  ServiceEntityID FROM S4 WHERE ParentServiceID = ParentServID; 
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

-- Declare Table
DROP TABLE IF EXISTS RetService;
IF TableName = "S3A1" THEN Create table RetService(PK INT, ServiceEntityID INT, ServiceEntityPropertiesTypeID INT, ServiceEntityPropertiesTypeValue DOUBLE, IonChangeTimestamp DateTime, UserID INT); end if;
IF TableName = "S3A2" THEN Create table RetService(PK INT, ServiceEntityID INT, ServiceEntityPropertiesTypeID INT, ServiceEntityPropertiesTypeValue INT, IonChangeTimestamp DateTime, UserID INT); end if;
IF TableName = "S3A3" THEN Create table RetService(PK INT, ServiceEntityID INT, ServiceEntityPropertiesTypeID INT, ServiceEntityPropertiesTypeValue VARCHAR(600), IonChangeTimestamp DateTime, UserID INT); end if;
IF TableName = "S3A4" THEN Create table RetService(PK INT, ServiceEntityID INT, ServiceEntityPropertiesTypeID INT, ServiceEntityPropertiesTypeValue VARCHAR(50), IonChangeTimestamp DateTime, UserID INT); end if;
IF TableName = "S3A5" THEN Create table RetService(PK INT, ServiceEntityID INT, ServiceEntityPropertiesTypeID INT, ServiceEntityPropertiesTypeValue DATETIME, IonChangeTimestamp DateTime, UserID INT); end if;
IF TableName = "S3A6" THEN Create table RetService(PK INT, ServiceEntityID INT, ServiceEntityPropertiesTypeID INT, ServiceEntityPropertiesTypeValue LONGBLOB, IonChangeTimestamp DateTime, UserID INT); end if;
IF TableName = "S3A7" THEN Create table RetService(PK INT, ServiceEntityID INT, ServiceEntityPropertiesTypeID INT, ServiceEntityPropertiesTypeValue TINYINT(1), IonChangeTimestamp DateTime, UserID INT); end if;

OPEN cur1;

 read_loop: LOOP
    FETCH cur1 INTO ServiceEntID;
    IF done THEN
      LEAVE read_loop;
    END IF;

 IF TableName = "S3A1" THEN Insert into RetService Select * from S3A1 Where ServiceEntityID = ServiceEntID AND ServiceEntityPropertiesTypeID = PropertyTypeID AND ServiceEntityPropertiesTypeValue = PropValue; END IF;
 IF TableName = "S3A2" THEN Insert into RetService Select * from S3A2 Where ServiceEntityID = ServiceEntID AND ServiceEntityPropertiesTypeID = PropertyTypeID AND ServiceEntityPropertiesTypeValue = PropValue; END IF;
 IF TableName = "S3A3" THEN Insert into RetService Select * from S3A3 Where ServiceEntityID = ServiceEntID AND ServiceEntityPropertiesTypeID = PropertyTypeID AND ServiceEntityPropertiesTypeValue = PropValue; END IF;
 IF TableName = "S3A4" THEN Insert into RetService Select * from S3A4 Where ServiceEntityID = ServiceEntID AND ServiceEntityPropertiesTypeID = PropertyTypeID AND ServiceEntityPropertiesTypeValue = PropValue; END IF;
 IF TableName = "S3A5" THEN Insert into RetService Select * from S3A5 Where ServiceEntityID = ServiceEntID AND ServiceEntityPropertiesTypeID = PropertyTypeID AND ServiceEntityPropertiesTypeValue = PropValue; END IF;
 IF TableName = "S3A6" THEN Insert into RetService Select * from S3A6 Where ServiceEntityID = ServiceEntID AND ServiceEntityPropertiesTypeID = PropertyTypeID AND ServiceEntityPropertiesTypeValue = PropValue; END IF;
 IF TableName = "S3A7" THEN Insert into RetService Select * from S3A7 Where ServiceEntityID = ServiceEntID AND ServiceEntityPropertiesTypeID = PropertyTypeID AND ServiceEntityPropertiesTypeValue = PropValue; END IF;
  
	END LOOP;
  CLOSE cur1;

SELECT * FROM retService;

END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `GetServiceEntityRevision`(IN EntityID INT)
BEGIN
	SELECT Revision from S4 Where serviceEntityID = EntityID;
END ;;
DELIMITER ;
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
    
    -- disable those tables in ofmServices
            -- IF TableName = 'G1T' THEN SELECT * FROM G1T ORDER BY LanguageID;END IF;
            -- IF TableName = 'G2T' THEN SELECT * FROM G2T ORDER BY CountryID; END IF;
            -- IF TableName = 'G5T' THEN SELECT * FROM G5T WHERE SystemsIconsID = AnyID; END IF;
            -- IF TableName = 'U2T' THEN SELECT * FROM U2T ORDER BY UserPropertiesTypeID;END IF;
          
            IF TableName = 'U1Com' THEN 
                IF (SELECT COUNT(*) FROM P1A WHERE UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) AND (SELECT PermissionsTypeID FROM P1T WHERE PermissionsTypeDescription = 'ION User Administration')) > 0 THEN
                    -- Check whether Permission 'Edit/Add/Delete User Data' is available
                    SELECT * FROM U1T;
                END IF;
            END IF;
                 
			-- disable those tables in ofmServices
            -- IF TableName = 'U3T' THEN SELECT * FROM U3T;END IF;
            IF TableName = 'U1T' THEN SELECT * FROM U1T WHERE Password = pw AND Username = Un; END IF;
            -- IF TableName = 'P1T' THEN SELECT * FROM P1T;END IF;
            -- IF TableName = 'O1T' THEN SELECT * FROM O1T;END IF;
            -- IF TableName = 'S5T' THEN SELECT * FROM S5T; END IF;
            IF TableName = 'S3T' THEN SELECT * FROM S3T; END IF;
            
            -- Language Translations
            
            -- disable those tables in ofmServices
            -- IF TableName = 'U2L' THEN SELECT * FROM U2L WHERE LanguageID = AnyID; END IF;
            
             IF TableName = 'O1L' THEN SELECT * FROM O1L WHERE LanguageID = AnyID; END IF;
             IF TableName = 'U3L' THEN SELECT * FROM U3L WHERE LanguageID = AnyID; END IF;
             
             -- disable those tables in ofmServices
             -- IF TableName = 'P1L' THEN SELECT * FROM P1L WHERE LanguageID = AnyID; END IF;
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
            -- disable those tables in ofmServices
           -- IF TableName = 'U2A1' OR TableName ='U2A2' OR TableName ='U2A3' OR TableName ='U2A4' OR TableName ='U2A5' OR TableName ='U2A6' OR TableName ='U2A7' OR TableName ='U1_O1A' THEN 
           --     SET @TN:= CONCAT('SELECT * FROM ', Tablename , ' WHERE UserID =', (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un) , ';');
           --     PREPARE stmt1 FROM @TN; 
           --     EXECUTE stmt1;
           -- END IF;
                
            -- Organization Allocations  
			-- disable those tables in ofmServices
            -- IF TableName = 'O1A1' OR TableName ='O1A2' OR TableName ='O1A3' OR TableName ='O1A4' OR TableName ='O1A5' OR TableName ='O1A6' OR TableName ='O1A7' THEN
            --    SET @TN:= CONCAT('SELECT * FROM ', Tablename , ' WHERE OrganizationID = ', AnyID,';');
            --    PREPARE stmt1 FROM @TN; 
            --    EXECUTE stmt1;
            -- END IF;
                                     
            -- disable those tables in ofmServices                         
            -- IF TableName = 'U1_O1A' THEN  SELECT * FROM U1_O1A WHERE UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un); END IF;
            -- IF TableName = 'P1A' THEN  SELECT * FROM P1A WHERE UserID = (SELECT UserID FROM U1T WHERE Password = pw AND Username = Un); END IF;            
            
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
DELIMITER ;;
CREATE DEFINER=`flightplan`@`%` PROCEDURE `SetBinary`(In pw VARCHAR(20), IN Un VARCHAR(50), IN TableName VARCHAR(10), PropertyID INT(11), IN BL LONGBLOB, OrgID INT(11), IN oldRef INT, IN ServiceIsPublic INT)
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
            
            SET EXIST = (SELECT PK FROM O1A6 WHERE OrganizationID = OrgID AND UserPropertiesTypeID = PropertyID);
            SET EXISTCNTR = (SELECT COUNT(*) FROM O1A6 WHERE OrganizationID = OrgID AND UserPropertiesTypeID = PropertyID);
            IF EXISTCNTR = 0 THEN
                
                SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`OrganizationID`, `UserPropertiesTypeID`, `UserPropertiesTypeValue`, `Hidden`,`IonChangeTimestamp`) VALUES (', OrgID,',', PropertyID,',', QUOTE(BL),', 0,', QUOTE(NOW()),');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            ELSE
                SET @TN:= CONCAT('DELETE FROM `',Tablename,'` WHERE OrganizationID = ' , OrgID ,' AND UserPropertiesTypeID = ', PropertyID ,';'); 
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
               
         
            SET EXIST = (SELECT PK FROM S3A6 WHERE ServiceEntityID = OrgID AND ServiceEntityPropertiesTypeID = PropertyID AND (UserID = UID));
            SET EXISTCNTR = (SELECT COUNT(*) FROM S3A6 WHERE ServiceEntityID = OrgID AND ServiceEntityPropertiesTypeID = PropertyID AND (UserID = UID));
       
            IF EXISTCNTR = 0 THEN
                
                SET @TN:= CONCAT('INSERT IGNORE `',Tablename,'` (`ServiceEntityID`, `ServiceEntityPropertiesTypeID`, `ServiceEntityPropertiesTypeValue`,`IonChangeTimestamp`,`UserID`,`ParentServiceId`) VALUES (', OrgID,',', PropertyID,',', QUOTE(BL),',', QUOTE(NOW()),',', UID ,',', (SELECT ParentServiceID From S4 Where ServiceEntityID = OrgID) , ');');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            ELSE
                SET @TN:= CONCAT('DELETE FROM `',Tablename,'` WHERE ServiceEntityID = ' , OrgID ,' AND ServiceEntityPropertiesTypeID = ', PropertyID ,' AND UserID = ', UID,';'); 
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
                SET PE = (SELECT COUNT(*) FROM P1A WHERE OrganizationID = OrgID AND ServiceID = ServiceID AND UserID = UID AND PermissionTypeID = PermissionID);
                       
                IF RemovePermission = 1 then
                    DELETE from P1A WHERE OrganizationID = OrgID AND ServiceID = ServiceID AND UserID = UID AND PermissionTypeID = PermissionID;
                else
                    IF PE = 0 THEN
                        INSERT IGNORE `P1A` (`Pk`, `UserID`, `ServiceID`, `OrganizationID`, `PermissionTypeID`, `PermissionStartValidity`, `PermissionEndValidity`) VALUES ('', UID, ServiceID, OrganizationID, PermissionID, StartValidity,EndValidity); 
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
            IF Tablename = 'U2A6' OR Tablename = 'S2A6' or Tablename = 'U3A6' THEN
                SET @TN:= CONCAT('DELETE from ',TableName ,' where UserID=', UID,' AND UserPropertiesTypeID=', PropertyID, ' AND PK=', Value ,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
            END IF;

			IF Tablename = 'S2A1' OR Tablename = 'S2A2' OR Tablename = 'S2A3' OR Tablename = 'S2A4' OR Tablename = 'S2A5' OR Tablename = 'S2A6' OR Tablename = 'S2A7' THEN
               SET @TN:= CONCAT('DELETE from ',TableName ,' where serviceID=', anyId,' AND ServicePropertiesTypeID=', PropertyID,' AND ServicePropertiesTypeValue=', QUOTE(Value) ,';');
                PREPARE stmt1 FROM @TN; 
                EXECUTE stmt1;
			END IF;

			IF Tablename = 'S3A1' OR Tablename = 'S3A2' OR Tablename = 'S3A3' OR Tablename = 'S3A4' OR Tablename = 'S3A5' OR Tablename = 'S3A6' OR Tablename = 'S3A7' THEN
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
                SET @TN:= CONCAT(' UPDATE ', Tablename ,' SET UserPropertiesTypeValue = ',QUOTE(Value),' WHERE OrganizationID = ', anyId ,' AND UserPropertiesTypeID = ', PropertyID,' AND UserPropertiesTypeValue = ' , QUOTE(oldValue) , ';');
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
