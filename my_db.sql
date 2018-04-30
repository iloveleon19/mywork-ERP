-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- 主機: 127.0.0.1
-- 產生時間： 2018-04-25 06:06:46
-- 伺服器版本: 5.7.17
-- PHP 版本： 7.1.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `my_db`
--

-- --------------------------------------------------------

--
-- 資料表結構 `item`
--

CREATE TABLE `item` (
  `sn` int(10) UNSIGNED NOT NULL,
  `name` char(25) CHARACTER SET utf8 NOT NULL,
  `price` int(10) UNSIGNED NOT NULL,
  `amount` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `item`
--

INSERT INTO `item` (`sn`, `name`, `price`, `amount`) VALUES
(14, 'wii U', 3000, 10),
(13, 'xbox one', 4000, 40),
(12, 'ps4', 9000, 50),
(15, 'switch', 10000, 10),
(16, 'ss', 300, 10),
(17, 'sega', 500, 20),
(18, 'dc', 100, 0),
(71, 'xxyy', 55, 10),
(70, 'xx', 4000, -10);

-- --------------------------------------------------------

--
-- 資料表結構 `member`
--

CREATE TABLE `member` (
  `sn` int(10) UNSIGNED NOT NULL,
  `id` char(30) CHARACTER SET utf8 NOT NULL,
  `password` char(255) CHARACTER SET utf8 DEFAULT NULL,
  `email` char(50) CHARACTER SET utf8 DEFAULT NULL,
  `phoneNum` char(12) CHARACTER SET utf8 DEFAULT NULL,
  `manager` char(25) CHARACTER SET utf8 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `member`
--

INSERT INTO `member` (`sn`, `id`, `password`, `email`, `phoneNum`, `manager`) VALUES
(1, 'leon19', '$2y$10$VGqT/jN82Ow9cwP801K.BOnqJC9PuTCGaneO8F3g9T9SK/NKtOPj6', 'leon19@gmail.com', '0422224302', 'supervisor'),
(81, 'supervisorA', '$2y$10$T5qMT5LKp8cfm.Qubi95.upRdvXrk2Nbpyp.aziItSA6DmnwWvSnO', 'xx@gmail.com', '111', 'supervisor'),
(78, 'supervisorB', '$2y$10$yLuUPbNUyxPkxWIa0SQriuVIC3M89Bu89x1B8U2mgVOv4wGpbBdi.', '11', '0972617500', 'supervisor'),
(79, 'business_C', '$2y$10$Y5m1gxmfQp9STiLKCUsjDetZhBSehojdFlH.IIl3z8thldNcDII2u', 'leon@gmail.com', '0972617566', 'business'),
(80, 'business_D', '$2y$10$O47xAk7KVaAdS813X1XJC.SF3hjkU9MhBA6/Ee6rDQ8vbNCcSLLbG', '15@gmail.com', '0972617500', 'business'),
(82, 'accountant', '$2y$10$j61x4nH7BsJL9m6KmqyKzOVEjP7ZiyAL7zyHjlmkLeVskKwK5YsHW', 'kevin@hotmail.com', '', 'accountant'),
(85, 'kevinvanse', '$2y$10$ESvcoX4UqN5fNWauzMN/Fe7U2OnRJP/AHxBVuTMhPBtXEQw5SmkOC', 'kevin@gmail.com', '', 'business'),
(86, 'business_E', '$2y$10$HtjD51o57LBYhvO.D.2AjuOQLSyCsLyRiRJLwTMVBAShvTc./DA4.', 'kein@hotmail.com', '0972617500', 'business'),
(87, 'ilove5566', '$2y$10$HJlKulThTsXKSq7PHrNa7.sE1Y20/EiO24YfCcV8QvRO34gqKlNbi', '5566@gmail.com', '0972555666', '0'),
(88, 'h556677', '$2y$10$HC/40su3x63DgPT17CNzDO2zVJxMp2EtrnL5IuIk2Z4tFTVv./17m', 'kevin@gmail.com', '0972617500', '0');

-- --------------------------------------------------------

--
-- 資料表結構 `relation`
--

CREATE TABLE `relation` (
  `sn` int(10) NOT NULL,
  `business` int(10) NOT NULL,
  `supervisor` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `relation`
--

INSERT INTO `relation` (`sn`, `business`, `supervisor`) VALUES
(1, 79, 81),
(2, 80, 78),
(3, 85, 1),
(4, 86, 1);

-- --------------------------------------------------------

--
-- 資料表結構 `stock`
--

CREATE TABLE `stock` (
  `sn` int(10) UNSIGNED NOT NULL,
  `item_num` int(10) UNSIGNED NOT NULL,
  `price` int(10) NOT NULL,
  `amount` int(10) NOT NULL,
  `store` int(10) NOT NULL,
  `op_business` int(11) NOT NULL,
  `time` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `stock`
--

INSERT INTO `stock` (`sn`, `item_num`, `price`, `amount`, `store`, `op_business`, `time`) VALUES
(30, 13, 3000, -10, 20, 0, '2018-04-10 09:04:27'),
(29, 13, 4000, -10, 30, 0, '2018-04-10 09:03:19'),
(28, 13, 3200, 10, 40, 0, '2018-04-10 09:02:46'),
(27, 13, 3500, 20, 30, 0, '2018-04-10 09:00:37'),
(26, 12, 9000, 30, 30, 0, '2018-04-10 09:00:18'),
(25, 13, 3000, 10, 10, 0, '2018-04-10 08:59:55'),
(31, 12, 10000, 10, 40, 0, '2018-04-12 09:26:17'),
(32, 12, 10000, -10, 30, 85, '2018-04-12 09:28:58'),
(33, 13, 3500, 10, 30, 85, '2018-04-12 09:30:20'),
(34, 16, 300, 10, 10, 85, '2018-04-18 15:28:38'),
(35, 12, 6000, 10, 50, 80, '2018-04-19 15:55:20'),
(36, 14, 3000, 10, 10, 85, '2018-04-23 13:29:49'),
(37, 13, 4500, -10, 20, 85, '2018-04-23 14:52:56'),
(38, 13, 3900, 10, 30, 85, '2018-04-23 17:28:52'),
(39, 13, 3500, 10, 40, 79, '2018-04-23 18:06:23'),
(40, 15, 9000, 10, 10, 86, '2018-04-24 14:54:15'),
(41, 14, 2500, 10, 20, 85, '2018-04-24 16:13:27'),
(42, 17, 100, 20, 20, 85, '2018-04-24 16:13:56');

--
-- 已匯出資料表的索引
--

--
-- 資料表索引 `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`sn`),
  ADD UNIQUE KEY `name` (`name`);

--
-- 資料表索引 `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`sn`),
  ADD UNIQUE KEY `id` (`id`);

--
-- 資料表索引 `relation`
--
ALTER TABLE `relation`
  ADD PRIMARY KEY (`sn`),
  ADD UNIQUE KEY `business` (`business`);

--
-- 資料表索引 `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`sn`);

--
-- 在匯出的資料表使用 AUTO_INCREMENT
--

--
-- 使用資料表 AUTO_INCREMENT `item`
--
ALTER TABLE `item`
  MODIFY `sn` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;
--
-- 使用資料表 AUTO_INCREMENT `member`
--
ALTER TABLE `member`
  MODIFY `sn` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;
--
-- 使用資料表 AUTO_INCREMENT `relation`
--
ALTER TABLE `relation`
  MODIFY `sn` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- 使用資料表 AUTO_INCREMENT `stock`
--
ALTER TABLE `stock`
  MODIFY `sn` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
