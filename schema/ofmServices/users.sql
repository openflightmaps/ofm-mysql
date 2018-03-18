--
-- Table structure for table `U1T`
--

CREATE TABLE `U1T` (
  `UserID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(20) NOT NULL,
  `Password` varchar(20) NOT NULL,
  `MainlanguagePref` int(11) DEFAULT NULL,
  `IonChangeTimeStamp` datetime DEFAULT NULL,
  PRIMARY KEY (`UserID`),
  KEY `index1` (`Username`,`UserID`,`Password`,`MainlanguagePref`)
) ENGINE=MyISAM AUTO_INCREMENT=184 DEFAULT CHARSET=utf8;
