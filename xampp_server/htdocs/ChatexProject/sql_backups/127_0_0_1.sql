-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2025. Már 12. 12:42
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `dbchatex`
--
CREATE DATABASE IF NOT EXISTS `dbchatex` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `dbchatex`;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message_text` varchar(500) NOT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `messages`
--

INSERT INTO `messages` (`message_id`, `sender_id`, `receiver_id`, `message_text`, `sent_at`, `is_read`) VALUES
(1, 1, 1, 'valami text', '2025-03-02 15:23:55', 0),
(2, 1, 1, 'valami 2 fldfsdúfokfúkowefúkowefefkefopef', '2025-03-04 12:54:04', 0);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `preferred_lang` text NOT NULL DEFAULT '\'magyar\'',
  `profile_picture` text DEFAULT NULL,
  `username` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `password_reset_token` varchar(255) DEFAULT NULL,
  `password_reset_expires` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`id`, `preferred_lang`, `profile_picture`, `username`, `email`, `password_hash`, `password_reset_token`, `password_reset_expires`, `created_at`) VALUES
(1, 'magyar', NULL, 'valakidddddddddddddd', 'ocsi2005levente@gmail.com', '$2y$10$Npsa/3eWFxssWcj4TBnETOK16LBuz9JSu9NVaKfge7uIxmYdYy3P6', '45a157961726288c65947ebf8a0d0c8a97b13a47', '2025-03-08 00:15:22', '2025-03-02 15:02:59'),
(2, 'magyar', NULL, 'valaki2', 'chatexfejlesztok@gmail.com', '$2y$10$HvL6BaKUqE1FTo9V.rLGK.9CxHVc2aJwiXeGVP9N5CXPz2U2LdHna', NULL, NULL, '2025-03-04 15:10:10'),
(7, 'english', NULL, 'ang', 'ang@ang.hu', '$2y$10$TrpuuLgt52QTDZqdJvopk.slaZR.wdgDXx2Sfe.9JK3YTWxsrzdSK', NULL, NULL, '2025-03-12 10:18:08');

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `idx_sender` (`sender_id`),
  ADD KEY `idx_receiver` (`receiver_id`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `fk_receiver` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
--
-- Adatbázis: `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(10) UNSIGNED NOT NULL,
  `dbase` varchar(255) NOT NULL DEFAULT '',
  `user` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `query` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

--
-- A tábla adatainak kiíratása `pma__designer_settings`
--

INSERT INTO `pma__designer_settings` (`username`, `settings_data`) VALUES
('root', '{\"relation_lines\":\"true\",\"snap_to_grid\":\"on\",\"angular_direct\":\"angular\"}');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

--
-- A tábla adatainak kiíratása `pma__pdf_pages`
--

INSERT INTO `pma__pdf_pages` (`db_name`, `page_nr`, `page_descr`) VALUES
('dbchatex', 1, 'kapcsolatok');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

--
-- A tábla adatainak kiíratása `pma__recent`
--

INSERT INTO `pma__recent` (`username`, `tables`) VALUES
('root', '[{\"db\":\"dbchatex\",\"table\":\"users\"},{\"db\":\"dbchatex\",\"table\":\"messages\"},{\"db\":\"dbchatex\",\"table\":\"messages2\"},{\"db\":\"dbchatex\",\"table\":\"users2\"}]');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

--
-- A tábla adatainak kiíratása `pma__table_coords`
--

INSERT INTO `pma__table_coords` (`db_name`, `table_name`, `pdf_page_number`, `x`, `y`) VALUES
('dbchatex', 'messages', 1, 610, 90),
('dbchatex', 'users', 1, 200, 90);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

--
-- A tábla adatainak kiíratása `pma__tracking`
--

INSERT INTO `pma__tracking` (`db_name`, `table_name`, `version`, `date_created`, `date_updated`, `schema_snapshot`, `schema_sql`, `data_sql`, `tracking`, `tracking_active`) VALUES
('dbchatex', 'users', 1, '2025-02-07 23:18:13', '2025-03-12 12:33:35', 'a:2:{s:7:\"COLUMNS\";a:5:{i:0;a:8:{s:5:\"Field\";s:2:\"id\";s:4:\"Type\";s:7:\"int(11)\";s:9:\"Collation\";N;s:4:\"Null\";s:2:\"NO\";s:3:\"Key\";s:3:\"PRI\";s:7:\"Default\";N;s:5:\"Extra\";s:14:\"auto_increment\";s:7:\"Comment\";s:0:\"\";}i:1;a:8:{s:5:\"Field\";s:8:\"username\";s:4:\"Type\";s:11:\"varchar(20)\";s:9:\"Collation\";s:20:\"utf8mb4_hungarian_ci\";s:4:\"Null\";s:2:\"NO\";s:3:\"Key\";s:3:\"MUL\";s:7:\"Default\";N;s:5:\"Extra\";s:0:\"\";s:7:\"Comment\";s:0:\"\";}i:2;a:8:{s:5:\"Field\";s:5:\"email\";s:4:\"Type\";s:12:\"varchar(100)\";s:9:\"Collation\";s:20:\"utf8mb4_hungarian_ci\";s:4:\"Null\";s:2:\"NO\";s:3:\"Key\";s:3:\"MUL\";s:7:\"Default\";N;s:5:\"Extra\";s:0:\"\";s:7:\"Comment\";s:0:\"\";}i:3;a:8:{s:5:\"Field\";s:13:\"password_hash\";s:4:\"Type\";s:12:\"varchar(255)\";s:9:\"Collation\";s:20:\"utf8mb4_hungarian_ci\";s:4:\"Null\";s:2:\"NO\";s:3:\"Key\";s:0:\"\";s:7:\"Default\";N;s:5:\"Extra\";s:0:\"\";s:7:\"Comment\";s:0:\"\";}i:4;a:8:{s:5:\"Field\";s:10:\"created_at\";s:4:\"Type\";s:9:\"timestamp\";s:9:\"Collation\";N;s:4:\"Null\";s:2:\"NO\";s:3:\"Key\";s:0:\"\";s:7:\"Default\";s:19:\"current_timestamp()\";s:5:\"Extra\";s:0:\"\";s:7:\"Comment\";s:0:\"\";}}s:7:\"INDEXES\";a:3:{i:0;a:13:{s:5:\"Table\";s:5:\"users\";s:10:\"Non_unique\";s:1:\"0\";s:8:\"Key_name\";s:7:\"PRIMARY\";s:12:\"Seq_in_index\";s:1:\"1\";s:11:\"Column_name\";s:2:\"id\";s:9:\"Collation\";s:1:\"A\";s:11:\"Cardinality\";s:1:\"0\";s:8:\"Sub_part\";N;s:6:\"Packed\";N;s:4:\"Null\";s:0:\"\";s:10:\"Index_type\";s:5:\"BTREE\";s:7:\"Comment\";s:0:\"\";s:13:\"Index_comment\";s:0:\"\";}i:1;a:13:{s:5:\"Table\";s:5:\"users\";s:10:\"Non_unique\";s:1:\"1\";s:8:\"Key_name\";s:8:\"username\";s:12:\"Seq_in_index\";s:1:\"1\";s:11:\"Column_name\";s:8:\"username\";s:9:\"Collation\";s:1:\"A\";s:11:\"Cardinality\";s:1:\"0\";s:8:\"Sub_part\";N;s:6:\"Packed\";N;s:4:\"Null\";s:0:\"\";s:10:\"Index_type\";s:5:\"BTREE\";s:7:\"Comment\";s:0:\"\";s:13:\"Index_comment\";s:0:\"\";}i:2;a:13:{s:5:\"Table\";s:5:\"users\";s:10:\"Non_unique\";s:1:\"1\";s:8:\"Key_name\";s:8:\"username\";s:12:\"Seq_in_index\";s:1:\"2\";s:11:\"Column_name\";s:5:\"email\";s:9:\"Collation\";s:1:\"A\";s:11:\"Cardinality\";s:1:\"0\";s:8:\"Sub_part\";N;s:6:\"Packed\";N;s:4:\"Null\";s:0:\"\";s:10:\"Index_type\";s:5:\"BTREE\";s:7:\"Comment\";s:0:\"\";s:13:\"Index_comment\";s:0:\"\";}}}', '# log 2025-02-07 23:18:13 root\nDROP TABLE IF EXISTS `users`;\n# log 2025-02-07 23:18:13 root\n\nCREATE TABLE `users` (\n  `id` int(11) NOT NULL,\n  `username` varchar(20) NOT NULL,\n  `email` varchar(100) NOT NULL,\n  `password_hash` varchar(255) NOT NULL,\n  `created_at` timestamp NOT NULL DEFAULT current_timestamp()\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;\n\n# log 2025-02-13 11:06:53 root\nALTER TABLE `users` ADD UNIQUE(`email`);\n# log 2025-02-13 11:07:27 root\nALTER TABLE `users` ADD UNIQUE(`username`);\n# log 2025-02-13 11:07:39 root\nALTER TABLE `users` DROP INDEX `username_2`;\n# log 2025-02-13 11:08:54 root\nALTER TABLE `users` DROP INDEX `username`;\n# log 2025-02-13 11:09:03 root\nALTER TABLE `users` DROP INDEX `email`;\n# log 2025-02-13 11:09:19 root\nALTER TABLE `users` ADD UNIQUE(`username`, `email`);\n# log 2025-02-17 21:46:10 root\nDROP TABLE `users`;\n\n# log 2025-02-17 21:46:46 root\nCREATE TABLE users (\r\n    id INT AUTO_INCREMENT PRIMARY KEY,\r\n    username VARCHAR(50) NOT NULL,\r\n    email VARCHAR(100) UNIQUE NOT NULL,\r\n    password_hash VARCHAR(255) NOT NULL,\r\n    password_reset_token VARCHAR(255) DEFAULT NULL,\r\n    password_reset_expires DATETIME DEFAULT NULL,\r\n    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n# log 2025-02-17 21:49:50 root\nALTER TABLE `users` CHANGE `username` `username` BLOB;\n# log 2025-02-17 21:49:50 root\nALTER TABLE `users` CHANGE `password_hash` `password_hash` BLOB;\n# log 2025-02-17 21:49:50 root\nALTER TABLE `users` CHANGE `password_reset_token` `password_reset_token` BLOB;\n# log 2025-02-17 21:49:50 root\nALTER TABLE `users` CHANGE `id` `id` INT(11) NOT NULL AUTO_INCREMENT, CHANGE `username` `username` VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_hungarian_ci NOT NULL, CHANGE `email` `email` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_hungarian_ci NOT NULL, CHANGE `password_hash` `password_hash` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_hungarian_ci NOT NULL, CHANGE `password_reset_token` `password_reset_token` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_hungarian_ci NULL DEFAULT NULL, CHANGE `created_at` `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;\n# log 2025-02-17 21:50:17 root\nALTER TABLE `users` ADD UNIQUE(`username`, `email`);\n# log 2025-02-17 21:50:58 root\nALTER TABLE `users` DROP INDEX `email`;\n# log 2025-03-02 14:34:03 root\nALTER TABLE `users` ADD `profile_picture` TEXT NOT NULL AFTER `id`;\n# log 2025-03-02 14:34:37 root\nALTER TABLE `users` CHANGE `profile_picture` `profile_picture` BLOB;\n# log 2025-03-02 14:34:37 root\nALTER TABLE `users` CHANGE `profile_picture` `profile_picture` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_hungarian_ci NOT NULL;\n# log 2025-03-02 15:31:37 root\nDROP TABLE `users`;\n\n# log 2025-03-02 15:32:03 root\nCREATE TABLE `users` (\r\n  `id` INT(11) NOT NULL AUTO_INCREMENT,\r\n  `profile_picture` TEXT NOT NULL,\r\n  `username` VARCHAR(20) NOT NULL UNIQUE,\r\n  `email` VARCHAR(100) NOT NULL UNIQUE,\r\n  `password_hash` VARCHAR(255) NOT NULL,\r\n  `password_reset_token` VARCHAR(255) DEFAULT NULL,\r\n  `password_reset_expires` DATETIME DEFAULT NULL,\r\n  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),\r\n  PRIMARY KEY (`id`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;\n# log 2025-03-02 15:55:48 root\nALTER TABLE `users` CHANGE `profile_picture` `profile_picture` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_hungarian_ci NULL DEFAULT NULL;\n# log 2025-03-12 10:22:41 root\nALTER TABLE `users` ADD `prefered_lang` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_hungarian_ci NOT NULL DEFAULT \'magyar\' AFTER `id`;\n# log 2025-03-12 10:30:37 root\nALTER TABLE `users` CHANGE `prefered_lang` `preferred_lang` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_hungarian_ci NOT NULL DEFAULT \'\\\'magyar\\\'\';', '\n\n# log 2025-02-08 17:10:24 root\nDELETE FROM `users` WHERE `users`.`id` = 1;\n\n# log 2025-02-08 18:53:41 root\nDELETE FROM `users` WHERE `users`.`id` = 2;\n\n# log 2025-02-11 20:29:06 root\nDELETE FROM `users` WHERE `users`.`id` = 3 LIMIT 1;\n# log 2025-02-11 20:29:06 root\nDELETE FROM `users` WHERE `users`.`id` = 4 LIMIT 1;\n# log 2025-02-11 20:29:06 root\nDELETE FROM `users` WHERE `users`.`id` = 5 LIMIT 1;\n# log 2025-02-11 22:09:19 root\nDELETE FROM `users` WHERE `users`.`id` = 6 LIMIT 1;\n# log 2025-02-11 22:09:19 root\nDELETE FROM `users` WHERE `users`.`id` = 7 LIMIT 1;\n# log 2025-02-11 22:30:38 root\nDELETE FROM `users` WHERE `users`.`id` = 8 LIMIT 1;\n# log 2025-02-11 22:30:38 root\nDELETE FROM `users` WHERE `users`.`id` = 9 LIMIT 1;\n# log 2025-02-11 22:30:41 root\nDELETE FROM `users` WHERE `users`.`id` = 10 LIMIT 1;\n# log 2025-02-12 22:39:59 root\nDELETE FROM `users` WHERE `users`.`id` = 12 LIMIT 1;\n# log 2025-02-13 09:16:20 root\nDELETE FROM `users` WHERE `users`.`id` = 11 LIMIT 1;\n# log 2025-02-13 09:16:20 root\nDELETE FROM `users` WHERE `users`.`id` = 13 LIMIT 1;\n# log 2025-02-13 09:47:18 root\nDELETE FROM `users` WHERE `users`.`id` = 14 LIMIT 1;\n# log 2025-02-13 10:37:40 root\nDELETE FROM `users` WHERE `users`.`id` = 15 LIMIT 1;\n# log 2025-02-13 10:37:40 root\nDELETE FROM `users` WHERE `users`.`id` = 16 LIMIT 1;\n# log 2025-02-13 10:37:45 root\nDELETE FROM `users` WHERE `users`.`id` = 17 LIMIT 1;\n# log 2025-02-13 11:35:05 root\nDELETE FROM `users` WHERE `users`.`id` = 18 LIMIT 1;\n# log 2025-02-13 11:35:05 root\nDELETE FROM `users` WHERE `users`.`id` = 19 LIMIT 1;\n# log 2025-02-13 11:35:05 root\nDELETE FROM `users` WHERE `users`.`id` = 20 LIMIT 1;\n# log 2025-02-13 11:41:08 root\nDELETE FROM `users` WHERE `users`.`id` = 21 LIMIT 1;\n# log 2025-02-13 11:41:08 root\nDELETE FROM `users` WHERE `users`.`id` = 22 LIMIT 1;\n# log 2025-02-13 11:48:40 root\nUPDATE `users` SET `id` = \'1\' WHERE `users`.`id` = 23;\n\n# log 2025-03-07 10:26:27 root\nDELETE FROM `users` WHERE `users`.`id` = 3 LIMIT 1;\n# log 2025-03-10 21:32:03 root\nDELETE FROM `users` WHERE `users`.`id` = 4;\n\n# log 2025-03-12 10:33:53 root\nDELETE FROM `users` WHERE `users`.`id` = 5 LIMIT 1;\n# log 2025-03-12 11:18:38 root\nUPDATE `users` SET `preferred_lang` = \'english\' WHERE `users`.`id` = 7;\n\n# log 2025-03-12 11:18:42 root\nDELETE FROM `users` WHERE `users`.`id` = 6 LIMIT 1;\n# log 2025-03-12 12:33:35 root\nUPDATE `users` SET `username` = \'valakiddddddddddddddddddddddddddddddddddddd\' WHERE `users`.`id` = 1;\n', 'UPDATE,INSERT,DELETE,TRUNCATE,CREATE TABLE,ALTER TABLE,RENAME TABLE,DROP TABLE,CREATE INDEX,DROP INDEX', 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- A tábla adatainak kiíratása `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2025-03-12 11:42:05', '{\"Console\\/Mode\":\"collapse\",\"lang\":\"hu\",\"NavigationWidth\":193}');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- A tábla indexei `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- A tábla indexei `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- A tábla indexei `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- A tábla indexei `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- A tábla indexei `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- A tábla indexei `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- A tábla indexei `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- A tábla indexei `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- A tábla indexei `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- A tábla indexei `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- A tábla indexei `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- A tábla indexei `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- A tábla indexei `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- A tábla indexei `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- A tábla indexei `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- A tábla indexei `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- A tábla indexei `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT a táblához `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Adatbázis: `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
