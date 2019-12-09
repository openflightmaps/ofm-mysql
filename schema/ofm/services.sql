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
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2A1`
--

CREATE TABLE `S2A1` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceID` int(11) NOT NULL,
  `ServicePropertiesTypeID` int(11) NOT NULL,
  `ServicePropertiesTypeValue` double NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `deleted` tinyint(4) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index2` (`ServiceID`,`ServicePropertiesTypeID`,`ammnt_FirId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2A2`
--

CREATE TABLE `S2A2` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceID` int(11) NOT NULL,
  `ServicePropertiesTypeID` int(11) NOT NULL,
  `ServicePropertiesTypeValue` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `deleted` tinyint(4) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceID`,`ServicePropertiesTypeID`,`ammnt_FirId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2A3`
--

CREATE TABLE `S2A3` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceID` int(11) NOT NULL,
  `ServicePropertiesTypeID` int(11) NOT NULL,
  `ServicePropertiesTypeValue` varchar(50) NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `deleted` tinyint(4) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceID`,`ServicePropertiesTypeID`,`ammnt_FirId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2A4`
--

CREATE TABLE `S2A4` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceID` int(11) NOT NULL,
  `ServicePropertiesTypeID` int(11) NOT NULL,
  `ServicePropertiesTypeValue` double NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  `deleted` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceID`,`ServicePropertiesTypeID`,`ammnt_FirId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2A5`
--

CREATE TABLE `S2A5` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceID` int(11) NOT NULL,
  `ServicePropertiesTypeID` int(11) NOT NULL,
  `ServicePropertiesTypeValue` double NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  `deleted` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceID`,`ServicePropertiesTypeID`,`ammnt_FirId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2A6`
--

CREATE TABLE `S2A6` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceID` int(11) NOT NULL,
  `ServicePropertiesTypeID` int(11) NOT NULL,
  `ServicePropertiesTypeValue` tinyblob NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  `deleted` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceID`,`ServicePropertiesTypeID`,`ammnt_FirId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2A7`
--

CREATE TABLE `S2A7` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceID` int(11) NOT NULL,
  `ServicePropertiesTypeID` int(11) NOT NULL,
  `ServicePropertiesTypeValue` double NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  `deleted` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceID`,`ServicePropertiesTypeID`,`ammnt_FirId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2T`
--

CREATE TABLE `S2T` (
  `ServicePropertiesTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `ServicePropertiestypeDescription` varchar(200) NOT NULL,
  `ServicePropertiesTypeFormat` int(11) NOT NULL,
  `multipleUse` tinyint(4) NOT NULL,
  PRIMARY KEY (`ServicePropertiesTypeID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `S3A1`
--

CREATE TABLE `S3A1` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceEntityID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeValue` double NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `UserID` int(11) NOT NULL,
  `ParentServiceId` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `ammnt_FirId` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceEntityPropertiesTypeID`,`ServiceEntityID`,`ParentServiceId`),
  KEY `index3` (`deleted`),
  KEY `index4` (`ServiceEntityID`,`ParentServiceId`),
  KEY `index5` (`ammnt_FirId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `deleted` int(11) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceEntityPropertiesTypeID`,`ServiceEntityID`,`ParentServiceId`),
  KEY `index3` (`deleted`),
  KEY `index4` (`ServiceEntityID`,`ParentServiceId`),
  KEY `index5` (`ammnt_FirId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `deleted` int(11) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceEntityPropertiesTypeID`,`ServiceEntityID`,`ParentServiceId`),
  KEY `Index3` (`deleted`),
  KEY `index4` (`ParentServiceId`,`ServiceEntityID`),
  KEY `index5` (`ammnt_FirId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `S3A4`
--

CREATE TABLE `S3A4` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceEntityID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeValue` varchar(50) NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `UserID` int(11) NOT NULL,
  `ParentServiceId` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceEntityPropertiesTypeID`,`ServiceEntityID`,`ParentServiceId`),
  KEY `index3` (`deleted`),
  KEY `index4` (`ServiceEntityID`,`ParentServiceId`),
  KEY `index5` (`ammnt_FirId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `deleted` int(11) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`ServiceEntityPropertiesTypeID`,`ServiceEntityID`,`ParentServiceId`),
  KEY `index3` (`deleted`),
  KEY `index4` (`ServiceEntityID`,`ParentServiceId`),
  KEY `index5` (`ammnt_FirId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `S3A6`
--

CREATE TABLE `S3A6` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceEntityID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeID` int(11) NOT NULL,
  `ServiceEntityPropertiesTypeValue` longblob NOT NULL,
  `IonChangeTimestamp` datetime NOT NULL,
  `UserId` int(11) NOT NULL,
  `ParentServiceId` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index3` (`deleted`),
  KEY `index5` (`ammnt_FirId`),
  KEY `index1` (`ServiceEntityID`),
  KEY `index6` (`ParentServiceId`),
  KEY `index4` (`ServiceEntityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  KEY `index1` (`ServiceEntityPropertiesTypeID`,`ServiceEntityID`,`ParentServiceId`),
  KEY `Index2` (`ammnt_FirId`),
  KEY `Index3` (`deleted`),
  KEY `index4` (`ServiceEntityID`,`ParentServiceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `S3T`
--

CREATE TABLE `S3T` (
  `ServiceEntityTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceEntityTypeDescription` varchar(200) NOT NULL,
  `ServiceEntityTypeFormat` int(11) NOT NULL,
  `multipleUse` tinyint(4) NOT NULL,
  `ServiceCategory` int(11) NOT NULL,
  `hidden` tinyint(1) NOT NULL,
  `ServiceEntityTypeApiName` varchar(45) NOT NULL,
  PRIMARY KEY (`ServiceEntityTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `S4`
--

CREATE TABLE `S4` (
  `ServiceEntityID` int(11) NOT NULL,
  `ParentServiceID` int(11) NOT NULL,
  `OrganizationID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `Revision` bigint(20) DEFAULT NULL,
  `ammnt_FirId` int(11) DEFAULT NULL,
  `searchTags` varchar(200) DEFAULT NULL,
  `deleted` int(11) NOT NULL,
  `dateOfDeletion` timestamp NULL DEFAULT NULL,
  `dateOfCreation` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ServiceEntityID`),
  KEY `index1` (`ParentServiceID`),
  KEY `index2` (`ammnt_FirId`),
  KEY `index3` (`deleted`),
  KEY `index4` (`UserID`),
  KEY `index5` (`OrganizationID`),
  KEY `index6` (`ServiceEntityID`,`ParentServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `S5T`
--

CREATE TABLE `S5T` (
  `ServiceCategoryID` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceCategoryName` varchar(100) NOT NULL,
  PRIMARY KEY (`ServiceCategoryID`),
  KEY `index` (`ServiceCategoryID`,`ServiceCategoryName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
