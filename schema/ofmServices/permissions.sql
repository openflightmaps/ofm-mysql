--
-- Table structure for table `P1A`
--

CREATE TABLE `P1A` (
  `Pk` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) NOT NULL,
  `ServiceID` int(11) NOT NULL,
  `OrganizationID` int(11) NOT NULL,
  `PermissionTypeID` int(11) NOT NULL,
  `PermissionStartValidity` datetime NOT NULL,
  `PermissionEndValidity` datetime NOT NULL,
  PRIMARY KEY (`Pk`),
  KEY `index1` (`UserID`,`PermissionTypeID`),
  KEY `index2` (`UserID`,`ServiceID`),
  KEY `index3` (`OrganizationID`),
  KEY `index4` (`PermissionStartValidity`),
  KEY `index5` (`PermissionEndValidity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `P1L`
--

CREATE TABLE `P1L` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(200) NOT NULL,
  PRIMARY KEY (`PK`),
  KEY `index1` (`RefID`,`LanguageID`,`Translation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `P1T`
--

CREATE TABLE `P1T` (
  `PermissionsTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `PermissionsTypeDescription` varchar(200) NOT NULL,
  PRIMARY KEY (`PermissionsTypeID`),
  KEY `index` (`PermissionsTypeID`,`PermissionsTypeDescription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
