-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.22-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for fortis
CREATE DATABASE IF NOT EXISTS `fortis` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `fortis`;

-- Dumping structure for table fortis.apartments
CREATE TABLE IF NOT EXISTS `apartments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `citizenid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.apartments: ~2 rows (approximately)
DELETE FROM `apartments`;
/*!40000 ALTER TABLE `apartments` DISABLE KEYS */;
INSERT INTO `apartments` (`id`, `name`, `type`, `label`, `citizenid`) VALUES
	(1, 'apartment54726', 'apartment5', 'Fantastic Plaza 4726', 'HYV94545'),
	(2, 'apartment58236', 'apartment5', 'Fantastic Plaza 8236', 'CYW53116');
/*!40000 ALTER TABLE `apartments` ENABLE KEYS */;

-- Dumping structure for table fortis.api_tokens
CREATE TABLE IF NOT EXISTS `api_tokens` (
  `token` varchar(255) NOT NULL,
  `purpose` varchar(255) DEFAULT NULL,
  `time` int(25) DEFAULT NULL,
  PRIMARY KEY (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.api_tokens: ~0 rows (approximately)
DELETE FROM `api_tokens`;
/*!40000 ALTER TABLE `api_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_tokens` ENABLE KEYS */;

-- Dumping structure for table fortis.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL DEFAULT 'LeBanhammer',
  PRIMARY KEY (`id`),
  KEY `steam` (`steam`),
  KEY `license` (`license`),
  KEY `discord` (`discord`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB AUTO_INCREMENT=518 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.bans: ~0 rows (approximately)
DELETE FROM `bans`;
/*!40000 ALTER TABLE `bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `bans` ENABLE KEYS */;

-- Dumping structure for table fortis.bills
CREATE TABLE IF NOT EXISTS `bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=1111 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.bills: ~0 rows (approximately)
DELETE FROM `bills`;
/*!40000 ALTER TABLE `bills` DISABLE KEYS */;
/*!40000 ALTER TABLE `bills` ENABLE KEYS */;

-- Dumping structure for table fortis.bitcoinminen
CREATE TABLE IF NOT EXISTS `bitcoinminen` (
  `building` varchar(50) DEFAULT NULL,
  `coords` text DEFAULT NULL,
  `rackid` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.bitcoinminen: ~0 rows (approximately)
DELETE FROM `bitcoinminen`;
/*!40000 ALTER TABLE `bitcoinminen` DISABLE KEYS */;
/*!40000 ALTER TABLE `bitcoinminen` ENABLE KEYS */;

-- Dumping structure for table fortis.bm_berichten
CREATE TABLE IF NOT EXISTS `bm_berichten` (
  `bsn` varchar(50) DEFAULT NULL,
  `verzender` varchar(50) DEFAULT NULL,
  `bericht` text DEFAULT NULL,
  `datumtijd` date DEFAULT NULL,
  `gelezen` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.bm_berichten: ~0 rows (approximately)
DELETE FROM `bm_berichten`;
/*!40000 ALTER TABLE `bm_berichten` DISABLE KEYS */;
/*!40000 ALTER TABLE `bm_berichten` ENABLE KEYS */;

-- Dumping structure for table fortis.cellstraf
CREATE TABLE IF NOT EXISTS `cellstraf` (
  `steam` varchar(50) DEFAULT NULL,
  `maanden` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.cellstraf: ~0 rows (approximately)
DELETE FROM `cellstraf`;
/*!40000 ALTER TABLE `cellstraf` DISABLE KEYS */;
/*!40000 ALTER TABLE `cellstraf` ENABLE KEYS */;

-- Dumping structure for table fortis.crypto
CREATE TABLE IF NOT EXISTS `crypto` (
  `#` int(11) NOT NULL AUTO_INCREMENT,
  `crypto` varchar(50) NOT NULL DEFAULT 'qbit',
  `worth` int(11) NOT NULL DEFAULT 0,
  `history` text DEFAULT NULL,
  PRIMARY KEY (`#`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.crypto: ~0 rows (approximately)
DELETE FROM `crypto`;
/*!40000 ALTER TABLE `crypto` DISABLE KEYS */;
/*!40000 ALTER TABLE `crypto` ENABLE KEYS */;

-- Dumping structure for table fortis.crypto_transactions
CREATE TABLE IF NOT EXISTS `crypto_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `message` varchar(50) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=939 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.crypto_transactions: ~0 rows (approximately)
DELETE FROM `crypto_transactions`;
/*!40000 ALTER TABLE `crypto_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `crypto_transactions` ENABLE KEYS */;

-- Dumping structure for table fortis.dealers
CREATE TABLE IF NOT EXISTS `dealers` (
  `#` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `time` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `createdby` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`#`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.dealers: ~0 rows (approximately)
DELETE FROM `dealers`;
/*!40000 ALTER TABLE `dealers` DISABLE KEYS */;
/*!40000 ALTER TABLE `dealers` ENABLE KEYS */;

-- Dumping structure for table fortis.dpkeybinds
CREATE TABLE IF NOT EXISTS `dpkeybinds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keybind1` varchar(50) DEFAULT NULL,
  `emote1` varchar(50) DEFAULT NULL,
  `keybind2` varchar(50) DEFAULT NULL,
  `keybind3` varchar(50) DEFAULT NULL,
  `keybind4` varchar(50) DEFAULT NULL,
  `keybind5` varchar(50) DEFAULT NULL,
  `emote2` varchar(50) DEFAULT NULL,
  `emote3` varchar(50) DEFAULT NULL,
  `emote4` varchar(50) DEFAULT NULL,
  `emote5` varchar(50) DEFAULT NULL,
  `emote6` varchar(50) DEFAULT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.dpkeybinds: ~0 rows (approximately)
DELETE FROM `dpkeybinds`;
/*!40000 ALTER TABLE `dpkeybinds` DISABLE KEYS */;
/*!40000 ALTER TABLE `dpkeybinds` ENABLE KEYS */;

-- Dumping structure for table fortis.drugslabs
CREATE TABLE IF NOT EXISTS `drugslabs` (
  `citizenid` varchar(50) DEFAULT NULL,
  `labinfo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `datum` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.drugslabs: ~0 rows (approximately)
DELETE FROM `drugslabs`;
/*!40000 ALTER TABLE `drugslabs` DISABLE KEYS */;
/*!40000 ALTER TABLE `drugslabs` ENABLE KEYS */;

-- Dumping structure for table fortis.eenjaar
CREATE TABLE IF NOT EXISTS `eenjaar` (
  `steamid` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.eenjaar: ~0 rows (approximately)
DELETE FROM `eenjaar`;
/*!40000 ALTER TABLE `eenjaar` DISABLE KEYS */;
/*!40000 ALTER TABLE `eenjaar` ENABLE KEYS */;

-- Dumping structure for table fortis.gangs
CREATE TABLE IF NOT EXISTS `gangs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `grades` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.gangs: ~0 rows (approximately)
DELETE FROM `gangs`;
/*!40000 ALTER TABLE `gangs` DISABLE KEYS */;
/*!40000 ALTER TABLE `gangs` ENABLE KEYS */;

-- Dumping structure for table fortis.gang_territoriums
CREATE TABLE IF NOT EXISTS `gang_territoriums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gang` varchar(50) DEFAULT NULL,
  `points` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.gang_territoriums: ~0 rows (approximately)
DELETE FROM `gang_territoriums`;
/*!40000 ALTER TABLE `gang_territoriums` DISABLE KEYS */;
/*!40000 ALTER TABLE `gang_territoriums` ENABLE KEYS */;

-- Dumping structure for table fortis.gloveboxitems
CREATE TABLE IF NOT EXISTS `gloveboxitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `info` text DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `slot` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.gloveboxitems: ~0 rows (approximately)
DELETE FROM `gloveboxitems`;
/*!40000 ALTER TABLE `gloveboxitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `gloveboxitems` ENABLE KEYS */;

-- Dumping structure for table fortis.gloveboxitemsnew
CREATE TABLE IF NOT EXISTS `gloveboxitemsnew` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) DEFAULT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plate` (`plate`)
) ENGINE=InnoDB AUTO_INCREMENT=1551 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.gloveboxitemsnew: ~0 rows (approximately)
DELETE FROM `gloveboxitemsnew`;
/*!40000 ALTER TABLE `gloveboxitemsnew` DISABLE KEYS */;
/*!40000 ALTER TABLE `gloveboxitemsnew` ENABLE KEYS */;

-- Dumping structure for table fortis.groothandels
CREATE TABLE IF NOT EXISTS `groothandels` (
  `citizenid` varchar(50) DEFAULT NULL,
  `opslag` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `werknemers` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.groothandels: ~0 rows (approximately)
DELETE FROM `groothandels`;
/*!40000 ALTER TABLE `groothandels` DISABLE KEYS */;
/*!40000 ALTER TABLE `groothandels` ENABLE KEYS */;

-- Dumping structure for table fortis.houselocations
CREATE TABLE IF NOT EXISTS `houselocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `coords` text DEFAULT NULL,
  `owned` tinyint(2) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tier` tinyint(2) DEFAULT NULL,
  `garage` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.houselocations: ~0 rows (approximately)
DELETE FROM `houselocations`;
/*!40000 ALTER TABLE `houselocations` DISABLE KEYS */;
/*!40000 ALTER TABLE `houselocations` ENABLE KEYS */;

-- Dumping structure for table fortis.house_plants
CREATE TABLE IF NOT EXISTS `house_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `building` varchar(50) DEFAULT NULL,
  `stage` varchar(50) DEFAULT 'stage-a',
  `sort` varchar(50) DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `food` int(11) DEFAULT 100,
  `health` int(11) DEFAULT 100,
  `progress` int(11) DEFAULT 0,
  `coords` text DEFAULT NULL,
  `plantid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `building` (`building`),
  KEY `plantid` (`plantid`)
) ENGINE=InnoDB AUTO_INCREMENT=7123 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.house_plants: ~0 rows (approximately)
DELETE FROM `house_plants`;
/*!40000 ALTER TABLE `house_plants` DISABLE KEYS */;
/*!40000 ALTER TABLE `house_plants` ENABLE KEYS */;

-- Dumping structure for table fortis.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `grades` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.jobs: ~0 rows (approximately)
DELETE FROM `jobs`;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;

-- Dumping structure for table fortis.lapraces
CREATE TABLE IF NOT EXISTS `lapraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `raceid` (`raceid`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.lapraces: ~0 rows (approximately)
DELETE FROM `lapraces`;
/*!40000 ALTER TABLE `lapraces` DISABLE KEYS */;
/*!40000 ALTER TABLE `lapraces` ENABLE KEYS */;

-- Dumping structure for table fortis.moneysafes
CREATE TABLE IF NOT EXISTS `moneysafes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `safe` varchar(50) NOT NULL DEFAULT '0',
  `money` int(11) NOT NULL DEFAULT 0,
  `transactions` text NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.moneysafes: ~0 rows (approximately)
DELETE FROM `moneysafes`;
/*!40000 ALTER TABLE `moneysafes` DISABLE KEYS */;
/*!40000 ALTER TABLE `moneysafes` ENABLE KEYS */;

-- Dumping structure for table fortis.occasion_vehicles
CREATE TABLE IF NOT EXISTS `occasion_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seller` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mods` text DEFAULT NULL,
  `occasionid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `occasionId` (`occasionid`)
) ENGINE=InnoDB AUTO_INCREMENT=325 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.occasion_vehicles: ~0 rows (approximately)
DELETE FROM `occasion_vehicles`;
/*!40000 ALTER TABLE `occasion_vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `occasion_vehicles` ENABLE KEYS */;

-- Dumping structure for table fortis.permissions
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `permission` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `steam` (`steam`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.permissions: ~0 rows (approximately)
DELETE FROM `permissions`;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` (`id`, `name`, `steam`, `license`, `permission`) VALUES
	(1, 'Anykeys', 'steam:110000139cffd77', 'license:b8d74a1ececd5078486457d4eeea2879817842c1', 'god');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;

-- Dumping structure for table fortis.phone_invoices
CREATE TABLE IF NOT EXISTS `phone_invoices` (
  `#` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `invoiceid` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`#`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.phone_invoices: ~0 rows (approximately)
DELETE FROM `phone_invoices`;
/*!40000 ALTER TABLE `phone_invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_invoices` ENABLE KEYS */;

-- Dumping structure for table fortis.phone_messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `number` (`number`)
) ENGINE=InnoDB AUTO_INCREMENT=6732 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.phone_messages: ~0 rows (approximately)
DELETE FROM `phone_messages`;
/*!40000 ALTER TABLE `phone_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_messages` ENABLE KEYS */;

-- Dumping structure for table fortis.phone_tweets
CREATE TABLE IF NOT EXISTS `phone_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=5436 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.phone_tweets: ~0 rows (approximately)
DELETE FROM `phone_tweets`;
/*!40000 ALTER TABLE `phone_tweets` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_tweets` ENABLE KEYS */;

-- Dumping structure for table fortis.playerammo
CREATE TABLE IF NOT EXISTS `playerammo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `ammo` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=3638 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.playerammo: ~0 rows (approximately)
DELETE FROM `playerammo`;
/*!40000 ALTER TABLE `playerammo` DISABLE KEYS */;
/*!40000 ALTER TABLE `playerammo` ENABLE KEYS */;

-- Dumping structure for table fortis.playeritems
CREATE TABLE IF NOT EXISTS `playeritems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `info` text DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `slot` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=255891 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.playeritems: ~0 rows (approximately)
DELETE FROM `playeritems`;
/*!40000 ALTER TABLE `playeritems` DISABLE KEYS */;
/*!40000 ALTER TABLE `playeritems` ENABLE KEYS */;

-- Dumping structure for table fortis.players
CREATE TABLE IF NOT EXISTS `players` (
  `#` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `cid` int(11) DEFAULT NULL,
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `money` text NOT NULL,
  `charinfo` text DEFAULT NULL,
  `job` text NOT NULL,
  `gang` text DEFAULT NULL,
  `position` text NOT NULL,
  `metadata` text NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `tattoos` longtext DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`#`),
  KEY `citizenid` (`citizenid`),
  KEY `last_updated` (`last_updated`),
  KEY `steam` (`steam`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.players: ~2 rows (approximately)
DELETE FROM `players`;
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` (`#`, `citizenid`, `cid`, `steam`, `license`, `name`, `money`, `charinfo`, `job`, `gang`, `position`, `metadata`, `inventory`, `last_updated`, `tattoos`, `ip`, `discord`) VALUES
	(1, 'HYV94545', 0, 'steam:110000139cffd77', 'license:b8d74a1ececd5078486457d4eeea2879817842c1', 'Anykeys', '{"cash":1000,"bank":10000,"crypto":0}', '{"nationality":"Nederlands","backstory":"placeholder backstory","lastname":"test","account":"NL05ABNA9364641944","birthdate":"12-12-1930","phone":"0615619574","new":true,"firstname":"test","gender":"man","cid":0}', '{"onduty":false,"label":"Werkloos","payment":10,"name":"unemployed"}', '{"label":"Geen Gang","name":"geen"}', '{"a":295.5924072265625,"z":13.75663948059082,"y":-2728.1162109375,"x":-1030.5443115234376}', '{"hunger":100,"thirst":100,"status":[],"ishandcuffed":false,"commandbinds":[],"phone":[],"tracker":false,"phonedata":{"InstalledApps":[],"SerialNumber":15581597},"inside":{"apartment":[]},"stress":0,"armor":0,"fitbit":[],"criminalrecord":{"hasRecord":false},"injail":0,"fingerprint":"Jf408e42cvP3163","attachmentcraftingrep":0,"dealerrep":0,"inlaststand":false,"jobrep":{"hotdog":0,"tow":0,"trucker":0,"taxi":0},"callsign":"NO CALLSIGN","craftingrep":0,"bloodtype":"A-","isdead":false,"licences":{"driver":true,"business":false},"walletid":"FORTIS-32790798","jailitems":[]}', '[{"amount":1,"name":"id_card","slot":1,"type":"item","info":{"birthdate":"12-12-1930","nationality":"Nederlands","citizenid":"HYV94545","firstname":"test","gender":"man","lastname":"test"}},{"amount":1,"name":"driver_license","slot":2,"type":"item","info":{"type":"A1-A2-A | AM-B | C1-C-CE","birthdate":"12-12-1930","firstname":"test","lastname":"test"}},{"amount":1,"name":"phone","slot":3,"type":"item","info":[]}]', '2022-09-26 21:17:49', NULL, 'ip:80.57.41.232', 'discord:696770352092807169'),
	(2, 'CYW53116', 0, 'steam:110000139cffd77', 'license:b8d74a1ececd5078486457d4eeea2879817842c1', 'Anykeys', '{"crypto":0,"cash":700.0,"bank":10000}', '{"phone":"0652742512","lastname":"123","account":"NL01ABNA8522628054","birthdate":"1-1-1930","backstory":"placeholder backstory","gender":"man","nationality":"Nederlands","cid":0,"firstname":"123","new":true}', '{"payment":10,"label":"Werkloos","name":"unemployed","onduty":false}', '{"name":"geen","label":"Geen Gang"}', '{"x":-658.6764526367188,"y":-854.574462890625,"z":24.50095558166504,"a":180.88595581054688}', '{"jailitems":[],"bloodtype":"A-","phone":[],"callsign":"NO CALLSIGN","dealerrep":0,"currentapartment":"apartment58236","tracker":false,"stress":0,"ishandcuffed":false,"status":[],"inside":{"apartment":[]},"walletid":"FORTIS-60335286","isdead":false,"licences":{"driver":true,"business":false},"thirst":100,"inlaststand":false,"criminalrecord":{"hasRecord":false},"injail":0,"fitbit":[],"fingerprint":"cv231i32CYF7900","phonedata":{"SerialNumber":56854926,"InstalledApps":[]},"jobrep":{"trucker":0,"tow":0,"hotdog":0,"taxi":0},"attachmentcraftingrep":0,"craftingrep":0,"hunger":100,"commandbinds":[],"armor":0}', '[{"amount":1,"name":"id_card","slot":1,"info":{"citizenid":"CYW53116","nationality":"Nederlands","birthdate":"1-1-1930","gender":"man","firstname":"123","lastname":"123"},"type":"item"},{"amount":1,"name":"driver_license","slot":2,"info":{"type":"A1-A2-A | AM-B | C1-C-CE","birthdate":"1-1-1930","firstname":"123","lastname":"123"},"type":"item"},{"amount":1,"name":"phone","slot":3,"info":[],"type":"item"},{"amount":1,"name":"tablet","slot":4,"info":[],"type":"item"},{"amount":1,"name":"radio","slot":9,"info":[],"type":"item"}]', '2022-09-26 21:30:50', NULL, 'ip:80.57.41.232', 'discord:696770352092807169');
/*!40000 ALTER TABLE `players` ENABLE KEYS */;

-- Dumping structure for table fortis.playerskins
CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(2) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.playerskins: ~2 rows (approximately)
DELETE FROM `playerskins`;
/*!40000 ALTER TABLE `playerskins` DISABLE KEYS */;
INSERT INTO `playerskins` (`id`, `citizenid`, `model`, `skin`, `active`) VALUES
	(1, 'HYV94545', '1885233650', '{"lipstick":{"texture":1,"item":-1,"defaultTexture":1,"defaultItem":-1},"mask":{"texture":0,"item":0,"defaultTexture":0,"defaultItem":0},"accessory":{"texture":0,"item":0,"defaultTexture":0,"defaultItem":0},"ageing":{"texture":0,"item":-1,"defaultTexture":0,"defaultItem":-1},"face":{"texture":0,"item":3,"defaultTexture":0,"defaultItem":0},"makeup":{"texture":1,"item":-1,"defaultTexture":1,"defaultItem":-1},"ear":{"texture":0,"item":-1,"defaultTexture":0,"defaultItem":-1},"pants":{"texture":0,"item":0,"defaultTexture":0,"defaultItem":0},"glass":{"texture":0,"item":0,"defaultTexture":0,"defaultItem":0},"decals":{"texture":0,"item":0,"defaultTexture":0,"defaultItem":0},"beard":{"texture":1,"item":-1,"defaultTexture":1,"defaultItem":-1},"hair":{"texture":0,"item":0,"defaultTexture":0,"defaultItem":0},"watch":{"texture":0,"item":-1,"defaultTexture":0,"defaultItem":-1},"shoes":{"texture":0,"item":1,"defaultTexture":0,"defaultItem":1},"eyebrows":{"texture":1,"item":-1,"defaultTexture":1,"defaultItem":-1},"t-shirt":{"texture":0,"item":21,"defaultTexture":0,"defaultItem":15},"hat":{"texture":0,"item":-1,"defaultTexture":0,"defaultItem":-1},"torso2":{"texture":0,"item":14,"defaultTexture":0,"defaultItem":0},"arms":{"texture":0,"item":2,"defaultTexture":0,"defaultItem":0},"bag":{"texture":0,"item":0,"defaultTexture":0,"defaultItem":0},"vest":{"texture":0,"item":13,"defaultTexture":0,"defaultItem":0},"blush":{"texture":1,"item":-1,"defaultTexture":1,"defaultItem":-1},"bracelet":{"texture":0,"item":-1,"defaultTexture":0,"defaultItem":-1}}', 1),
	(2, 'CYW53116', '1885233650', '{"eyebrows":{"item":-1,"defaultTexture":1,"texture":1,"defaultItem":-1},"vest":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"shoes":{"item":1,"defaultTexture":0,"texture":0,"defaultItem":1},"blush":{"item":-1,"defaultTexture":1,"texture":1,"defaultItem":-1},"arms":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"makeup":{"item":-1,"defaultTexture":1,"texture":1,"defaultItem":-1},"ear":{"item":-1,"defaultTexture":0,"texture":0,"defaultItem":-1},"glass":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"hat":{"item":-1,"defaultTexture":0,"texture":0,"defaultItem":-1},"face":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"pants":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"hair":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"lipstick":{"item":-1,"defaultTexture":1,"texture":1,"defaultItem":-1},"ageing":{"item":-1,"defaultTexture":0,"texture":0,"defaultItem":-1},"decals":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"accessory":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"bracelet":{"item":-1,"defaultTexture":0,"texture":0,"defaultItem":-1},"watch":{"item":-1,"defaultTexture":0,"texture":0,"defaultItem":-1},"mask":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"bag":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"torso2":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"t-shirt":{"item":15,"defaultTexture":0,"texture":0,"defaultItem":15},"beard":{"item":-1,"defaultTexture":1,"texture":1,"defaultItem":-1}}', 1);
/*!40000 ALTER TABLE `playerskins` ENABLE KEYS */;

-- Dumping structure for table fortis.player_boats
CREATE TABLE IF NOT EXISTS `player_boats` (
  `#` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `boathouse` varchar(50) DEFAULT NULL,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `state` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.player_boats: ~4 rows (approximately)
DELETE FROM `player_boats`;
/*!40000 ALTER TABLE `player_boats` DISABLE KEYS */;
INSERT INTO `player_boats` (`#`, `citizenid`, `model`, `plate`, `boathouse`, `fuel`, `state`) VALUES
	(16, 'QRA63694', 'dinghy', 'IDEK6943', 'lsymc', 100, 1),
	(17, 'QRA63694', 'dinghy', 'IDEK9620', 'lsymc', 100, 1),
	(18, 'QRA63694', 'dinghy', 'IDEK7789', 'lsymc', 100, 1),
	(0, 'QEJ34052', 'dinghy', 'IDEK8417', NULL, 100, 0);
/*!40000 ALTER TABLE `player_boats` ENABLE KEYS */;

-- Dumping structure for table fortis.player_contacts
CREATE TABLE IF NOT EXISTS `player_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `iban` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=12433 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.player_contacts: ~0 rows (approximately)
DELETE FROM `player_contacts`;
/*!40000 ALTER TABLE `player_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_contacts` ENABLE KEYS */;

-- Dumping structure for table fortis.player_houses
CREATE TABLE IF NOT EXISTS `player_houses` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `house` varchar(50) NOT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `keyholders` text DEFAULT NULL,
  `decorations` text DEFAULT NULL,
  `stash` text DEFAULT NULL,
  `outfit` text DEFAULT NULL,
  `logout` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `house` (`house`),
  KEY `citizenid` (`citizenid`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.player_houses: ~0 rows (approximately)
DELETE FROM `player_houses`;
/*!40000 ALTER TABLE `player_houses` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_houses` ENABLE KEYS */;

-- Dumping structure for table fortis.player_mails
CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=67023 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.player_mails: ~0 rows (approximately)
DELETE FROM `player_mails`;
/*!40000 ALTER TABLE `player_mails` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_mails` ENABLE KEYS */;

-- Dumping structure for table fortis.player_outfits
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL,
  `model` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  `outfitId` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `outfitId` (`outfitId`)
) ENGINE=InnoDB AUTO_INCREMENT=8970 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.player_outfits: ~0 rows (approximately)
DELETE FROM `player_outfits`;
/*!40000 ALTER TABLE `player_outfits` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_outfits` ENABLE KEYS */;

-- Dumping structure for table fortis.player_planes
CREATE TABLE IF NOT EXISTS `player_planes` (
  `steam` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `plane` varchar(50) DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `mods` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`mods`)),
  `plate` varchar(50) DEFAULT NULL,
  `hangar` varchar(50) DEFAULT NULL,
  `state` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.player_planes: ~0 rows (approximately)
DELETE FROM `player_planes`;
/*!40000 ALTER TABLE `player_planes` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_planes` ENABLE KEYS */;

-- Dumping structure for table fortis.player_vehicles
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `#` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `mods` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `plate` varchar(50) NOT NULL,
  `fakeplate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT NULL,
  `fuel` int(11) DEFAULT 100,
  `engine` float DEFAULT 1000,
  `body` float DEFAULT 1000,
  `state` int(11) DEFAULT 1,
  `depotprice` int(11) NOT NULL DEFAULT 0,
  `drivingdistance` int(50) DEFAULT NULL,
  `status` text DEFAULT NULL,
  PRIMARY KEY (`#`),
  KEY `plate` (`plate`),
  KEY `citizenid` (`citizenid`),
  KEY `steam` (`steam`)
) ENGINE=InnoDB AUTO_INCREMENT=2432 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.player_vehicles: ~0 rows (approximately)
DELETE FROM `player_vehicles`;
/*!40000 ALTER TABLE `player_vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_vehicles` ENABLE KEYS */;

-- Dumping structure for table fortis.player_warns
CREATE TABLE IF NOT EXISTS `player_warns` (
  `#` int(11) NOT NULL AUTO_INCREMENT,
  `senderIdentifier` varchar(50) DEFAULT NULL,
  `targetIdentifier` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `warnId` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`#`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.player_warns: ~0 rows (approximately)
DELETE FROM `player_warns`;
/*!40000 ALTER TABLE `player_warns` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_warns` ENABLE KEYS */;

-- Dumping structure for table fortis.playtime
CREATE TABLE IF NOT EXISTS `playtime` (
  `steam` varchar(50) DEFAULT NULL,
  `playtime` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.playtime: ~0 rows (approximately)
DELETE FROM `playtime`;
/*!40000 ALTER TABLE `playtime` DISABLE KEYS */;
/*!40000 ALTER TABLE `playtime` ENABLE KEYS */;

-- Dumping structure for table fortis.playtime_final
CREATE TABLE IF NOT EXISTS `playtime_final` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(50) DEFAULT NULL,
  `minuten` int(11) DEFAULT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.playtime_final: ~1 rows (approximately)
DELETE FROM `playtime_final`;
/*!40000 ALTER TABLE `playtime_final` DISABLE KEYS */;
INSERT INTO `playtime_final` (`id`, `steam`, `minuten`) VALUES
	(1, 'steam:110000139cffd77', 19);
/*!40000 ALTER TABLE `playtime_final` ENABLE KEYS */;

-- Dumping structure for table fortis.portofoons
CREATE TABLE IF NOT EXISTS `portofoons` (
  `frequentie` double DEFAULT NULL,
  `naam` varchar(50) DEFAULT NULL,
  `citzenid` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.portofoons: ~0 rows (approximately)
DELETE FROM `portofoons`;
/*!40000 ALTER TABLE `portofoons` DISABLE KEYS */;
/*!40000 ALTER TABLE `portofoons` ENABLE KEYS */;

-- Dumping structure for table fortis.queue
CREATE TABLE IF NOT EXISTS `queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `priority` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.queue: ~0 rows (approximately)
DELETE FROM `queue`;
/*!40000 ALTER TABLE `queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `queue` ENABLE KEYS */;

-- Dumping structure for table fortis.sneeuwpoppen
CREATE TABLE IF NOT EXISTS `sneeuwpoppen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gevonden` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`gevonden`)),
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`coords`)),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.sneeuwpoppen: ~0 rows (approximately)
DELETE FROM `sneeuwpoppen`;
/*!40000 ALTER TABLE `sneeuwpoppen` DISABLE KEYS */;
/*!40000 ALTER TABLE `sneeuwpoppen` ENABLE KEYS */;

-- Dumping structure for table fortis.stashitems
CREATE TABLE IF NOT EXISTS `stashitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stash` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `info` text NOT NULL,
  `type` varchar(255) NOT NULL,
  `slot` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15024 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.stashitems: ~0 rows (approximately)
DELETE FROM `stashitems`;
/*!40000 ALTER TABLE `stashitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `stashitems` ENABLE KEYS */;

-- Dumping structure for table fortis.stashitemsnew
CREATE TABLE IF NOT EXISTS `stashitemsnew` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stash` varchar(255) NOT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `stash` (`stash`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.stashitemsnew: ~0 rows (approximately)
DELETE FROM `stashitemsnew`;
/*!40000 ALTER TABLE `stashitemsnew` DISABLE KEYS */;
/*!40000 ALTER TABLE `stashitemsnew` ENABLE KEYS */;

-- Dumping structure for table fortis.tablet
CREATE TABLE IF NOT EXISTS `tablet` (
  `citizenid` varchar(50) DEFAULT NULL,
  `token` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.tablet: ~0 rows (approximately)
DELETE FROM `tablet`;
/*!40000 ALTER TABLE `tablet` DISABLE KEYS */;
/*!40000 ALTER TABLE `tablet` ENABLE KEYS */;

-- Dumping structure for table fortis.tattoos
CREATE TABLE IF NOT EXISTS `tattoos` (
  `citizenid` varchar(50) DEFAULT NULL,
  `tattoos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tattoos`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.tattoos: ~0 rows (approximately)
DELETE FROM `tattoos`;
/*!40000 ALTER TABLE `tattoos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tattoos` ENABLE KEYS */;

-- Dumping structure for table fortis.trunkitems
CREATE TABLE IF NOT EXISTS `trunkitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `info` text NOT NULL,
  `type` varchar(255) NOT NULL,
  `slot` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=633 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.trunkitems: ~0 rows (approximately)
DELETE FROM `trunkitems`;
/*!40000 ALTER TABLE `trunkitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `trunkitems` ENABLE KEYS */;

-- Dumping structure for table fortis.trunkitemsnew
CREATE TABLE IF NOT EXISTS `trunkitemsnew` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) NOT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plate` (`plate`)
) ENGINE=InnoDB AUTO_INCREMENT=1127 DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.trunkitemsnew: ~0 rows (approximately)
DELETE FROM `trunkitemsnew`;
/*!40000 ALTER TABLE `trunkitemsnew` DISABLE KEYS */;
/*!40000 ALTER TABLE `trunkitemsnew` ENABLE KEYS */;

-- Dumping structure for table fortis.vissen
CREATE TABLE IF NOT EXISTS `vissen` (
  `steam` varchar(50) DEFAULT NULL,
  `plek` varchar(50) DEFAULT NULL,
  `positie` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fortis.vissen: ~0 rows (approximately)
DELETE FROM `vissen`;
/*!40000 ALTER TABLE `vissen` DISABLE KEYS */;
/*!40000 ALTER TABLE `vissen` ENABLE KEYS */;

-- Dumping structure for table fortis.whitelist
CREATE TABLE IF NOT EXISTS `whitelist` (
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`steam`),
  UNIQUE KEY `identifier` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table fortis.whitelist: ~0 rows (approximately)
DELETE FROM `whitelist`;
/*!40000 ALTER TABLE `whitelist` DISABLE KEYS */;
/*!40000 ALTER TABLE `whitelist` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
