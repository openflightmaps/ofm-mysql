--
-- Table structure for table `O1A1`
--

CREATE TABLE `O1A1` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `OrganizationID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` float NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`OrganizationID`,`UserPropertiesTypeID`),
  KEY `index2` (`Hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `O1A2`
--

CREATE TABLE `O1A2` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `OrganizationID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` int(11) NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`OrganizationID`,`UserPropertiesTypeID`),
  KEY `index2` (`Hidden`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Table structure for table `O1A3`
--

CREATE TABLE `O1A3` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `OrganizationID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` varchar(200) NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`UserPropertiesTypeID`,`OrganizationID`),
  KEY `index` (`Hidden`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8;

--
-- Table structure for table `O1A4`
--

CREATE TABLE `O1A4` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `OrganizationID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` varchar(50) NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`OrganizationID`,`UserPropertiesTypeID`),
  KEY `index2` (`Hidden`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

--
-- Table structure for table `O1A5`
--

CREATE TABLE `O1A5` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `OrganizationID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` datetime NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`OrganizationID`,`UserPropertiesTypeID`),
  KEY `index2` (`Hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `O1A6`
--

CREATE TABLE `O1A6` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `OrganizationID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` longblob NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`OrganizationID`,`UserPropertiesTypeID`),
  KEY `index2` (`Hidden`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8;

--
-- Table structure for table `O1A7`
--

CREATE TABLE `O1A7` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `OrganizationID` int(11) NOT NULL,
  `UserPropertiesTypeID` int(11) NOT NULL,
  `UserPropertiesTypeValue` tinyint(1) NOT NULL,
  `Hidden` tinyint(1) NOT NULL,
  `IonChangeTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`OrganizationID`,`UserPropertiesTypeID`),
  KEY `index2` (`Hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `O1T`
--

CREATE TABLE `O1T` (
  `OrganizationID` int(11) NOT NULL AUTO_INCREMENT,
  `OrganizationName` varchar(200) NOT NULL,
  PRIMARY KEY (`OrganizationID`),
  KEY `index` (`OrganizationID`,`OrganizationName`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

--
-- Table structure for table `O1_O1A`
--

CREATE TABLE `O1_O1A` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `PrimaryOrganizationID` int(11) NOT NULL,
  `SubsidiaryOrganizationID` int(11) NOT NULL,
  PRIMARY KEY (`Pk`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
