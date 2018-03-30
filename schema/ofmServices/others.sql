--
-- Table structure for table `idsToMigrate`
--

CREATE TABLE `idsToMigrate` (
  `id` bigint(20) NOT NULL,
  `accountDesignator` varchar(1000) DEFAULT NULL,
  `email` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
