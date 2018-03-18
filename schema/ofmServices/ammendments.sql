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
  KEY `date` (`ParentServiceId`,`TimeStamp`)
) ENGINE=InnoDB AUTO_INCREMENT=12608770 DEFAULT CHARSET=utf8;
