--
-- Table structure for table `S1L`
--

CREATE TABLE `S1L` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(100) NOT NULL,
  PRIMARY KEY (`PK`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `S2L`
--

CREATE TABLE `S2L` (
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(200) NOT NULL,
  PRIMARY KEY (`RefID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `S3L`
--

CREATE TABLE `S3L` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(200) NOT NULL,
  PRIMARY KEY (`PK`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Table structure for table `S5L`
--

CREATE TABLE `S5L` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(100) NOT NULL,
  PRIMARY KEY (`PK`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Table structure for table `G1T`
--

CREATE TABLE `G1T` (
  `LanguageID` int(11) NOT NULL AUTO_INCREMENT,
  `LanguageDescription` varchar(50) NOT NULL,
  `LanguageDescriptionIcon` int(11) DEFAULT NULL,
  `TextID` int(11) NOT NULL,
  PRIMARY KEY (`LanguageID`),
  KEY `index1` (`LanguageID`,`LanguageDescription`,`LanguageDescriptionIcon`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Table structure for table `G4A1`
--

CREATE TABLE `G4A1` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(10) NOT NULL,
  PRIMARY KEY (`PK`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

--
-- Table structure for table `G4A2`
--

CREATE TABLE `G4A2` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(50) NOT NULL,
  PRIMARY KEY (`PK`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Table structure for table `G4A3`
--

CREATE TABLE `G4A3` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(200) NOT NULL,
  PRIMARY KEY (`PK`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `G4A4`
--

CREATE TABLE `G4A4` (
  `PK` int(11) NOT NULL AUTO_INCREMENT,
  `RefID` int(11) NOT NULL,
  `LanguageID` int(11) NOT NULL,
  `Translation` varchar(1000) NOT NULL,
  PRIMARY KEY (`PK`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `G4T`
--

CREATE TABLE `G4T` (
  `SystemID` int(11) NOT NULL AUTO_INCREMENT,
  `SystemTextKey` varchar(100) NOT NULL,
  `Format` int(11) NOT NULL,
  PRIMARY KEY (`SystemID`)
) ENGINE=MyISAM AUTO_INCREMENT=533 DEFAULT CHARSET=utf8;

--
-- Table structure for table `G5T`
--

CREATE TABLE `G5T` (
  `SystemsIconsID` int(11) NOT NULL AUTO_INCREMENT,
  `Icon` blob NOT NULL,
  PRIMARY KEY (`SystemsIconsID`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

