--
-- Table structure for table `U13`
--

CREATE TABLE `U13` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(200) NOT NULL,
  PRIMARY KEY (`PK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U14`
--

CREATE TABLE `U14` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(100) NOT NULL,
  PRIMARY KEY (`PK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U15`
--

CREATE TABLE `U15` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(200) NOT NULL,
  PRIMARY KEY (`PK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U1T`
--

CREATE TABLE `U1T` (
  `UserID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(20) NOT NULL,
  `Password` varchar(20) NOT NULL,
  `MainlanguagePref` int(11) DEFAULT NULL,
  `IonChangeTimeStamp` datetime DEFAULT NULL,
  `openIdProvider` varchar(45) DEFAULT NULL,
  `openIdSubject` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`UserID`),
  KEY `index1` (`Username`,`UserID`,`Password`,`MainlanguagePref`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `U1_O1A`
--

CREATE TABLE `U1_O1A` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) NOT NULL,
  `OrganizationID` int(11) NOT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index` (`UserId`,`OrganizationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U2A1`
--

CREATE TABLE `U2A1` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` float NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`UserID`,`UserPropertiesTypeID`),
  KEY `Index2` (`UserID`,`Hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U2A2`
--

CREATE TABLE `U2A2` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` int(11) NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`UserID`,`UserPropertiesTypeID`),
  KEY `index2` (`UserID`,`Hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U2A3`
--

CREATE TABLE `U2A3` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` varchar(200) NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`UserID`,`UserPropertiesTypeID`),
  KEY `index2` (`UserID`,`Hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U2A4`
--

CREATE TABLE `U2A4` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` varchar(50) NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`UserID`,`UserPropertiesTypeID`),
  KEY `index2` (`Hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U2A5`
--

CREATE TABLE `U2A5` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` datetime NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`UserID`,`UserPropertiesTypeID`),
  KEY `index2` (`Hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U2A6`
--

CREATE TABLE `U2A6` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` longblob NOT NULL,
  `UserPropertiesTypeFilesize` int(11) NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`UserID`,`UserPropertiesTypeID`),
  KEY `index2` (`Hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U2A7`
--

CREATE TABLE `U2A7` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` tinyint(1) NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`UserID`,`UserPropertiesTypeID`),
  KEY `index2` (`Hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U2L`
--

CREATE TABLE `U2L` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(200) NOT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`RefID`,`LanguageID`),
  KEY `index2` (`RefID`,`Translation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U2T`
--

CREATE TABLE `U2T` (
  `UserPropertiesTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `UserPropertiesTypeDescription` varchar(200) NOT NULL,
  `UserPropertiesTypeFormat` int(11) NOT NULL,
  `multipleUse` tinyint(1) NOT NULL,
  `protected` tinyint(1) NOT NULL,
  PRIMARY KEY (`UserPropertiesTypeID`),
  KEY `index1` (`UserPropertiesTypeID`),
  KEY `index2` (`UserPropertiesTypeDescription`),
  KEY `index3` (`UserPropertiesTypeFormat`),
  KEY `index4` (`multipleUse`),
  KEY `index5` (`protected`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `U3T`
--

CREATE TABLE `U3T` (
  `UserCategoryID` int(11) NOT NULL AUTO_INCREMENT,
  `UserCategoryName` varchar(50) NOT NULL,
  PRIMARY KEY (`UserCategoryID`),
  KEY `index1` (`UserCategoryID`),
  KEY `index2` (`UserCategoryName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
