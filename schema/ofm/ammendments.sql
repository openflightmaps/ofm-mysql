--
-- Table structure for table `AMMNT_ACTIVITYDATARECORDER`
--

CREATE TABLE `AMMNT_ACTIVITYDATARECORDER` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `record` longtext,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LoginTime` timestamp NULL DEFAULT NULL,
  `LogoutTime` timestamp NULL DEFAULT NULL,
  `ActivityDurationMin` int(11) DEFAULT '0',
  PRIMARY KEY (`PK`)
) ENGINE=InnoDB AUTO_INCREMENT=4614 DEFAULT CHARSET=utf8;

--
-- Table structure for table `AMMNT_COMMIT`
--

CREATE TABLE `AMMNT_COMMIT` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ParentServiceId` int(11) NOT NULL,
  `ServiceEntityId` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `TimeStamp` datetime NOT NULL,
  `AddReplace1_Add2_Delete3` int(11) DEFAULT NULL,
  `Tablename` varchar(20) DEFAULT NULL,
  `PropertyID` int(11) DEFAULT NULL,
  `Value` longtext,
  `oldValue` longtext,
  PRIMARY KEY (`PK`),
  KEY `property` (`UserID`,`PropertyID`),
  KEY `date` (`UserID`,`TimeStamp`),
  KEY `date2` (`ParentServiceId`,`TimeStamp`)
) ENGINE=InnoDB AUTO_INCREMENT=493399 DEFAULT CHARSET=utf8;

--
-- Table structure for table `AMMNT_FIR`
--

CREATE TABLE `AMMNT_FIR` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `IcaoCode` varchar(4) NOT NULL,
  PRIMARY KEY (`PK`),
  KEY `index` (`Name`,`IcaoCode`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;

--
-- Table structure for table `AMMNT_S4_SPATIALINDEX`
--

CREATE TABLE `AMMNT_S4_SPATIALINDEX` (
  `PK` bigint(20) NOT NULL AUTO_INCREMENT,
  `ServiceEntityId` bigint(20) NOT NULL,
  `TileId` bigint(20) NOT NULL,
  `lastChange` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `ServiceEntityId` (`TileId`,`ServiceEntityId`),
  KEY `2` (`ServiceEntityId`,`TileId`),
  KEY `4` (`lastChange`,`TileId`)
) ENGINE=InnoDB AUTO_INCREMENT=3209163 DEFAULT CHARSET=utf8;

--
-- Table structure for table `AMMNT_S4_SPATIALINDEX_CHANGES`
--

CREATE TABLE `AMMNT_S4_SPATIALINDEX_CHANGES` (
  `PK` bigint(20) NOT NULL AUTO_INCREMENT,
  `serviceEntityId` bigint(20) NOT NULL,
  `tileId` bigint(20) NOT NULL,
  `branchId` int(11) NOT NULL,
  `revisionId` int(11) NOT NULL DEFAULT '0',
  `fir` int(11) NOT NULL DEFAULT '-1',
  `effectiveDate` datetime NOT NULL,
  `validUntilDate` datetime NOT NULL,
  `userId` int(11) NOT NULL DEFAULT '-1',
  `type` varchar(45) CHARACTER SET latin1 NOT NULL DEFAULT 'NOT SET',
  `name` longtext NOT NULL,
  `commitMsg` varchar(50000) CHARACTER SET latin1 NOT NULL DEFAULT 'NOT SET',
  PRIMARY KEY (`PK`),
  KEY `tileId` (`tileId`,`serviceEntityId`),
  KEY `date1` (`effectiveDate`),
  KEY `date2` (`validUntilDate`)
) ENGINE=InnoDB AUTO_INCREMENT=2099046 DEFAULT CHARSET=utf8;
