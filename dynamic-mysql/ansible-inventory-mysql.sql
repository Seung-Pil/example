-- Create database
USE mysql;
CREATE DATABASE inventory;
USE inventory;

-- Create syntax for TABLE 'group'
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `variables` longtext,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'childgroups'
CREATE TABLE `childgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `child_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `childid` (`child_id`,`parent_id`),
  KEY `childgroups_child_id` (`child_id`),
  KEY `childgroups_parent_id` (`parent_id`),
  CONSTRAINT `childgroups_ibfk_1` FOREIGN KEY (`child_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `childgroups_ibfk_2` FOREIGN KEY (`parent_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'host'
CREATE TABLE `host` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host` varchar(255) NOT NULL,
  `hostname` varchar(255) NOT NULL,
  `variables` longtext,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `host_host` (`host`),
  UNIQUE KEY `host_hostname` (`hostname`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'hostgroups'
CREATE TABLE `hostgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `host_id` (`host_id`,`group_id`),
  KEY `hostgroups_host_id` (`host_id`),
  KEY `hostgroups_group_id` (`group_id`),
  CONSTRAINT `hostgroups_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `host` (`id`),
  CONSTRAINT `hostgroups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- Create syntax for VIEW 'inventory'
CREATE VIEW `inventory`
AS SELECT
   `groups`.`name` AS `groups`,
   `host`.`host` AS `host`,
   `host`.`hostname` AS `hostname`,
   `host`.`variables` AS `host_vars`
FROM (`groups` left join (`host` left join `hostgroups` on((`host`.`id` = `hostgroups`.`host_id`))) on((`hostgroups`.`group_id` = `groups`.`id`))) where ((`host`.`enabled` = 1) and (`groups`.`enabled` = 1)) order by `host`.`hostname`;

-- Create syntax for VIEW 'children'
CREATE VIEW `children`
AS SELECT
   `gparent`.`name` AS `parent`,
   `gchild`.`name` AS `child`
FROM ((`childgroups` left join `groups` `gparent` on((`childgroups`.`parent_id` = `gparent`.`id`))) left join `groups` `gchild` on((`childgroups`.`child_id` = `gchild`.`id`))) order by `gparent`.`name`;
