CREATE TABLE `common`.`animal` (
`animal_id` varchar(20) NOT NULL COMMENT "id (internal to database)",
`dob` date                           DEFAULT NULL COMMENT "animal's date of birth",
`sex` enum('M','F','unknown') NOT NULL DEFAULT "unknown" COMMENT "sex",
`owner` varchar(20) NOT NULL DEFAULT "Unknown" COMMENT "owner's name",
`line` enum('Unknown','C57/BJ6 (WT)','Thy1-GCaMP6s,GP4.3','SST-Cre','PV-Cre','Wfs1-Cre','Wfs1-Ai9','Viaat-Ai9','PV-Ai9','SST-Ai9','VIP-Ai9','PV-ChR2-tdTomato','SST-ChR2-tdTomato','TH-DREADD','FVB','PV-tdtomato','MECP2(129)','MECP2(FVB)','129') NOT NULL DEFAULT "Unknown" COMMENT "mouse line",
`animal_notes` varchar(4096) NOT NULL DEFAULT "" COMMENT "strain, genetic manipulations",
`animal_ts` timestamp                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "automatic",
PRIMARY KEY (`animal_id`)
) ENGINE = InnoDB, COMMENT ""



<SQL>
CREATE TABLE `common`.`session` (
`animal_id` varchar(20) NOT NULL COMMENT "id (internal to database)",
CONSTRAINT `v3gxjWjT` FOREIGN KEY (`animal_id`) REFERENCES `common`.`animal` (`animal_id`) ON UPDATE CASCADE ON DELETE RESTRICT,
`session_id` varchar(20) NOT NULL COMMENT "session id",
`data_path` varchar(255) NOT NULL COMMENT "main directory for raw data",
`session_date` date  NOT NULL COMMENT "session date",
`pre_session_id` varchar(20) NOT NULL COMMENT "pre-session id",
`post_session_id` varchar(20) NOT NULL COMMENT "post-session id",
PRIMARY KEY (`animal_id`,`session_id`)
) ENGINE = InnoDB, COMMENT "common.Session"
</SQL>