--
-- Table structure for table `CDT`
--

CREATE TABLE `CDT` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `creator` varchar(500) NOT NULL,
  `cover` varchar(10000) NOT NULL,
  `AccountDesignator` varchar(45) NOT NULL,
  `proprietorCode` varchar(100) NOT NULL,
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `lastTransaction` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `destroyed` tinyint(4) DEFAULT '0',
  `lastTransactionDesignation` varchar(500) NOT NULL DEFAULT 'credits created',
  `email` varchar(500) DEFAULT 'office@openflightmaps.org',
  `token` varchar(45) NOT NULL DEFAULT 'OFM CREDIT (ofmCr)',
  `blockSize` int(11) NOT NULL,
  `sender` varchar(1000) DEFAULT 'OFMA',
  `senderEmail` varchar(500) DEFAULT 'office@openflightmaps.org',
  PRIMARY KEY (`id`),
  KEY `accountDesig` (`AccountDesignator`,`email`),
  KEY `proprieterCode` (`proprietorCode`,`email`),
  KEY `lastTransaction` (`lastTransaction`)
) ENGINE=InnoDB AUTO_INCREMENT=2626699 DEFAULT CHARSET=latin1;

--
-- Table structure for table `CDT_VAL`
--

CREATE TABLE `CDT_VAL` (
  `emailAddress` varchar(100) NOT NULL,
  `validationCode` varchar(4) NOT NULL,
  `validUntil` timestamp NOT NULL,
  `validated` tinyint(4) NOT NULL,
  `requestedByEmail` varchar(200) DEFAULT NULL,
  `latch_amount` double DEFAULT NULL,
  `latch_proprietor` varchar(200) DEFAULT NULL,
  `latch_addressee` varchar(200) DEFAULT NULL,
  `latch_purpose` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`emailAddress`,`validated`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='	';
