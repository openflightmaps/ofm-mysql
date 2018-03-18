--
-- Table structure for table `S1T`
--

CREATE TABLE `S1T` (
  `ServiceID` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceName` varchar(200) DEFAULT NULL,
  `OrganizationID` int(11) DEFAULT NULL,
  `Hidden` tinyint(4) DEFAULT NULL,
  `deveolperDescription` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`ServiceID`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2A2`
--

CREATE TABLE `S2A2` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceID` int(11) NOT NULL,
  `ServicePropertiesTypeID` int(11) NOT NULL,
  `ServicePropertiesTypeValue` int(11) NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `deleted` tinyint(4) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceID`,`ServicePropertiesTypeID`,`ammnt_FirId`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2A5`
--

CREATE TABLE `S2A5` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceID` int(11) NOT NULL,
  `ServicePropertiesTypeID` int(11) NOT NULL,
  `ServicePropertiesTypeValue` datetime DEFAULT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  `deleted` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceID`,`ServicePropertiesTypeID`,`ammnt_FirId`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2T`
--

CREATE TABLE `S2T` (
  `ServicePropertiesTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `ServicePropertiestypeDescription` varchar(200) NOT NULL,
  `ServicePropertiesTypeFormat` int(11) NOT NULL,
  `multipleUse` tinyint(4) NOT NULL,
  PRIMARY KEY (`ServicePropertiesTypeID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Table structure for table `S3A2`
--

CREATE TABLE `S3A2` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceEntityID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeValue` int(11) NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `UserID` int(11) NOT NULL,
  `ParentServiceId` int(11) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceEntityID`,`ServiceEntityPropertiesTypeID`,`UserID`,`ammnt_FirId`,`ParentServiceId`)
) ENGINE=MyISAM AUTO_INCREMENT=186833 DEFAULT CHARSET=utf8;

--
-- Table structure for table `S3A3`
--

CREATE TABLE `S3A3` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceEntityID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeValue` longtext NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `UserID` int(11) NOT NULL,
  `ParentServiceId` int(11) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceEntityID`,`ServiceEntityPropertiesTypeID`,`UserID`,`ammnt_FirId`,`ParentServiceId`)
) ENGINE=MyISAM AUTO_INCREMENT=198991 DEFAULT CHARSET=utf8;

--
-- Table structure for table `S3A5`
--

CREATE TABLE `S3A5` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceEntityID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeValue` datetime NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `UserID` int(11) NOT NULL,
  `ParentServiceId` int(11) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceEntityID`,`ServiceEntityPropertiesTypeID`,`ParentServiceId`,`UserID`,`ammnt_FirId`)
) ENGINE=InnoDB AUTO_INCREMENT=19500 DEFAULT CHARSET=utf8;

--
-- Table structure for table `S3A7`
--

CREATE TABLE `S3A7` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceEntityID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeValue` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `UserID` int(11) NOT NULL,
  `ParentServiceId` int(11) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceEntityID`,`ServiceEntityPropertiesTypeID`,`UserID`,`ParentServiceId`,`ammnt_FirId`)
) ENGINE=InnoDB AUTO_INCREMENT=13673 DEFAULT CHARSET=utf8;

--
-- Table structure for table `S3T`
--

CREATE TABLE `S3T` (
  `ServiceEntityTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceEntityTypeDescription` varchar(200) NOT NULL,
  `ServiceEntityTypeFormat` int(11) NOT NULL,
  `multipleUse` tinyint(4) NOT NULL,
  `ServiceCategory` int(11) NOT NULL,
  PRIMARY KEY (`ServiceEntityTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;

--
-- Table structure for table `S4`
--

CREATE TABLE `S4` (
  `ServiceEntityID` int(11) NOT NULL,
  `ParentServiceID` int(11) NOT NULL,
  `OrganizationID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `Revision` int(11) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  `searchTags` varchar(200) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `dateOfDeletion` timestamp NULL DEFAULT NULL,
  `dateOfCreation` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ServiceEntityID`),
  KEY `serviceEntityid` (`ServiceEntityID`,`OrganizationID`,`UserID`,`Revision`,`ammnt_FirId`,`ParentServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

