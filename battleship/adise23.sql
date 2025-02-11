-- --------------------------------------------------------
-- Διακομιστής:                  127.0.0.1
-- Έκδοση διακομιστή:            10.4.32-MariaDB - mariadb.org binary distribution
-- Λειτ. σύστημα διακομιστή:     Win64
-- HeidiSQL Έκδοση:              12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for adise23_2019_032-240
DROP DATABASE IF EXISTS `adise23_2019_032-240`;
CREATE DATABASE IF NOT EXISTS `adise23_2019_032-240` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `adise23_2019_032-240`;

-- Dumping structure for procedure adise23_2019_032-240.CheckWinner
DROP PROCEDURE IF EXISTS `CheckWinner`;
DELIMITER //
CREATE PROCEDURE `CheckWinner`()
BEGIN
    DECLARE player1_count INT;
    DECLARE player2_count INT;
    DECLARE winner_message VARCHAR(50);
    DECLARE winner_result ENUM('p1_wins', 'p2_wins');

    -- Count 'R' occurrences for player 1
    SELECT COUNT(*) INTO player1_count
    FROM player_1
    WHERE b_color = 'R';

    -- Count 'R' occurrences for player 2
    SELECT COUNT(*) INTO player2_count
    FROM player_2
    WHERE b_color = 'R';

    -- Check if either player has reached 3 'R' occurrences
    IF player1_count = 1 THEN
        SET winner_message = 'Player 2 wins!';
        SET winner_result = 'p2_wins';
    ELSEIF player2_count = 1 THEN
        SET winner_message = 'Player 1 wins!';
        SET winner_result = 'p1_wins';
    END IF;

    -- Update game_status table
    UPDATE game_status
    SET STATUS=  'ended'
    WHERE status <> 'ended'; -- Update only if the game is not already ended

	 UPDATE game_status
	 SET result = winner_result
	 WHERE STATUS = 'ended';
	 
    SELECT winner_message AS message; -- Return winner message
END//
DELIMITER ;

-- Dumping structure for procedure adise23_2019_032-240.clean_board
DROP PROCEDURE IF EXISTS `clean_board`;
DELIMITER //
CREATE PROCEDURE `clean_board`()
BEGIN
	REPLACE INTO player_1 SELECT * FROM emptyboard;
	REPLACE INTO player_2 SELECT * FROM emptyboard;
END//
DELIMITER ;

-- Dumping structure for πίνακας adise23_2019_032-240.emptyboard
DROP TABLE IF EXISTS `emptyboard`;
CREATE TABLE IF NOT EXISTS `emptyboard` (
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `b_color` enum('W','B','G','R') DEFAULT NULL,
  PRIMARY KEY (`x`,`y`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adise23_2019_032-240.emptyboard: ~100 rows (approximately)
INSERT INTO `emptyboard` (`x`, `y`, `b_color`) VALUES
	(1, 1, 'W'),
	(1, 2, 'W'),
	(1, 3, 'W'),
	(1, 4, 'W'),
	(1, 5, 'W'),
	(1, 6, 'W'),
	(1, 7, 'W'),
	(1, 8, 'W'),
	(1, 9, 'W'),
	(1, 10, 'W'),
	(2, 1, 'W'),
	(2, 2, 'W'),
	(2, 3, 'W'),
	(2, 4, 'W'),
	(2, 5, 'W'),
	(2, 6, 'W'),
	(2, 7, 'W'),
	(2, 8, 'W'),
	(2, 9, 'W'),
	(2, 10, 'W'),
	(3, 1, 'W'),
	(3, 2, 'W'),
	(3, 3, 'W'),
	(3, 4, 'W'),
	(3, 5, 'W'),
	(3, 6, 'W'),
	(3, 7, 'W'),
	(3, 8, 'W'),
	(3, 9, 'W'),
	(3, 10, 'W'),
	(4, 1, 'W'),
	(4, 2, 'W'),
	(4, 3, 'W'),
	(4, 4, 'W'),
	(4, 5, 'W'),
	(4, 6, 'W'),
	(4, 7, 'W'),
	(4, 8, 'W'),
	(4, 9, 'W'),
	(4, 10, 'W'),
	(5, 1, 'W'),
	(5, 2, 'W'),
	(5, 3, 'W'),
	(5, 4, 'W'),
	(5, 5, 'W'),
	(5, 6, 'W'),
	(5, 7, 'W'),
	(5, 8, 'W'),
	(5, 9, 'W'),
	(5, 10, 'W'),
	(6, 1, 'W'),
	(6, 2, 'W'),
	(6, 3, 'W'),
	(6, 4, 'W'),
	(6, 5, 'W'),
	(6, 6, 'W'),
	(6, 7, 'W'),
	(6, 8, 'W'),
	(6, 9, 'W'),
	(6, 10, 'W'),
	(7, 1, 'W'),
	(7, 2, 'W'),
	(7, 3, 'W'),
	(7, 4, 'W'),
	(7, 5, 'W'),
	(7, 6, 'W'),
	(7, 7, 'W'),
	(7, 8, 'W'),
	(7, 9, 'W'),
	(7, 10, 'W'),
	(8, 1, 'W'),
	(8, 2, 'W'),
	(8, 3, 'W'),
	(8, 4, 'W'),
	(8, 5, 'W'),
	(8, 6, 'W'),
	(8, 7, 'W'),
	(8, 8, 'W'),
	(8, 9, 'W'),
	(8, 10, 'W'),
	(9, 1, 'W'),
	(9, 2, 'W'),
	(9, 3, 'W'),
	(9, 4, 'W'),
	(9, 5, 'W'),
	(9, 6, 'W'),
	(9, 7, 'W'),
	(9, 8, 'W'),
	(9, 9, 'W'),
	(9, 10, 'W'),
	(10, 1, 'W'),
	(10, 2, 'W'),
	(10, 3, 'W'),
	(10, 4, 'W'),
	(10, 5, 'W'),
	(10, 6, 'W'),
	(10, 7, 'W'),
	(10, 8, 'W'),
	(10, 9, 'W'),
	(10, 10, 'W');

-- Dumping structure for πίνακας adise23_2019_032-240.game_status
DROP TABLE IF EXISTS `game_status`;
CREATE TABLE IF NOT EXISTS `game_status` (
  `status` enum('not active','initialized','started','ended','aborted') NOT NULL DEFAULT 'not active',
  `p_turn` enum('player_1','player_2') DEFAULT NULL,
  `result` enum('p1_wins','p2_wins') DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adise23_2019_032-240.game_status: ~1 rows (approximately)
INSERT INTO `game_status` (`status`, `p_turn`, `result`, `last_change`) VALUES
	('not active', NULL, NULL, '2024-01-09 23:30:52');

-- Dumping structure for πίνακας adise23_2019_032-240.players
DROP TABLE IF EXISTS `players`;
CREATE TABLE IF NOT EXISTS `players` (
  `username` varchar(20) DEFAULT NULL,
  `player_nr` enum('player_1','player_2') NOT NULL,
  `token` varchar(100) DEFAULT NULL,
  `last_action` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`player_nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adise23_2019_032-240.players: ~2 rows (approximately)
INSERT INTO `players` (`username`, `player_nr`, `token`, `last_action`) VALUES
	(NULL, 'player_1', NULL, '2024-01-09 23:30:52'),
	(NULL, 'player_2', NULL, '2024-01-09 23:30:52');

-- Dumping structure for πίνακας adise23_2019_032-240.player_1
DROP TABLE IF EXISTS `player_1`;
CREATE TABLE IF NOT EXISTS `player_1` (
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `b_color` enum('W','B','G','R') DEFAULT NULL,
  PRIMARY KEY (`x`,`y`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adise23_2019_032-240.player_1: ~100 rows (approximately)
INSERT INTO `player_1` (`x`, `y`, `b_color`) VALUES
	(1, 1, 'W'),
	(1, 2, 'W'),
	(1, 3, 'W'),
	(1, 4, 'W'),
	(1, 5, 'W'),
	(1, 6, 'W'),
	(1, 7, 'W'),
	(1, 8, 'W'),
	(1, 9, 'W'),
	(1, 10, 'W'),
	(2, 1, 'W'),
	(2, 2, 'W'),
	(2, 3, 'W'),
	(2, 4, 'W'),
	(2, 5, 'W'),
	(2, 6, 'W'),
	(2, 7, 'W'),
	(2, 8, 'W'),
	(2, 9, 'W'),
	(2, 10, 'W'),
	(3, 1, 'W'),
	(3, 2, 'W'),
	(3, 3, 'W'),
	(3, 4, 'W'),
	(3, 5, 'W'),
	(3, 6, 'W'),
	(3, 7, 'W'),
	(3, 8, 'W'),
	(3, 9, 'W'),
	(3, 10, 'W'),
	(4, 1, 'W'),
	(4, 2, 'W'),
	(4, 3, 'W'),
	(4, 4, 'W'),
	(4, 5, 'W'),
	(4, 6, 'W'),
	(4, 7, 'W'),
	(4, 8, 'W'),
	(4, 9, 'W'),
	(4, 10, 'W'),
	(5, 1, 'W'),
	(5, 2, 'W'),
	(5, 3, 'W'),
	(5, 4, 'W'),
	(5, 5, 'W'),
	(5, 6, 'W'),
	(5, 7, 'W'),
	(5, 8, 'W'),
	(5, 9, 'W'),
	(5, 10, 'W'),
	(6, 1, 'W'),
	(6, 2, 'W'),
	(6, 3, 'W'),
	(6, 4, 'W'),
	(6, 5, 'W'),
	(6, 6, 'W'),
	(6, 7, 'W'),
	(6, 8, 'W'),
	(6, 9, 'W'),
	(6, 10, 'W'),
	(7, 1, 'W'),
	(7, 2, 'W'),
	(7, 3, 'W'),
	(7, 4, 'W'),
	(7, 5, 'W'),
	(7, 6, 'W'),
	(7, 7, 'W'),
	(7, 8, 'W'),
	(7, 9, 'W'),
	(7, 10, 'W'),
	(8, 1, 'W'),
	(8, 2, 'W'),
	(8, 3, 'W'),
	(8, 4, 'W'),
	(8, 5, 'W'),
	(8, 6, 'W'),
	(8, 7, 'W'),
	(8, 8, 'W'),
	(8, 9, 'W'),
	(8, 10, 'W'),
	(9, 1, 'W'),
	(9, 2, 'W'),
	(9, 3, 'W'),
	(9, 4, 'W'),
	(9, 5, 'W'),
	(9, 6, 'W'),
	(9, 7, 'W'),
	(9, 8, 'W'),
	(9, 9, 'W'),
	(9, 10, 'W'),
	(10, 1, 'W'),
	(10, 2, 'W'),
	(10, 3, 'W'),
	(10, 4, 'W'),
	(10, 5, 'W'),
	(10, 6, 'W'),
	(10, 7, 'W'),
	(10, 8, 'W'),
	(10, 9, 'W'),
	(10, 10, 'W');

-- Dumping structure for πίνακας adise23_2019_032-240.player_2
DROP TABLE IF EXISTS `player_2`;
CREATE TABLE IF NOT EXISTS `player_2` (
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `b_color` enum('W','B','G','R') DEFAULT NULL,
  PRIMARY KEY (`x`,`y`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adise23_2019_032-240.player_2: ~100 rows (approximately)
INSERT INTO `player_2` (`x`, `y`, `b_color`) VALUES
	(1, 1, 'W'),
	(1, 2, 'W'),
	(1, 3, 'W'),
	(1, 4, 'W'),
	(1, 5, 'W'),
	(1, 6, 'W'),
	(1, 7, 'W'),
	(1, 8, 'W'),
	(1, 9, 'W'),
	(1, 10, 'W'),
	(2, 1, 'W'),
	(2, 2, 'W'),
	(2, 3, 'W'),
	(2, 4, 'W'),
	(2, 5, 'W'),
	(2, 6, 'W'),
	(2, 7, 'W'),
	(2, 8, 'W'),
	(2, 9, 'W'),
	(2, 10, 'W'),
	(3, 1, 'W'),
	(3, 2, 'W'),
	(3, 3, 'W'),
	(3, 4, 'W'),
	(3, 5, 'W'),
	(3, 6, 'W'),
	(3, 7, 'W'),
	(3, 8, 'W'),
	(3, 9, 'W'),
	(3, 10, 'W'),
	(4, 1, 'W'),
	(4, 2, 'W'),
	(4, 3, 'W'),
	(4, 4, 'W'),
	(4, 5, 'W'),
	(4, 6, 'W'),
	(4, 7, 'W'),
	(4, 8, 'W'),
	(4, 9, 'W'),
	(4, 10, 'W'),
	(5, 1, 'W'),
	(5, 2, 'W'),
	(5, 3, 'W'),
	(5, 4, 'W'),
	(5, 5, 'W'),
	(5, 6, 'W'),
	(5, 7, 'W'),
	(5, 8, 'W'),
	(5, 9, 'W'),
	(5, 10, 'W'),
	(6, 1, 'W'),
	(6, 2, 'W'),
	(6, 3, 'W'),
	(6, 4, 'W'),
	(6, 5, 'W'),
	(6, 6, 'W'),
	(6, 7, 'W'),
	(6, 8, 'W'),
	(6, 9, 'W'),
	(6, 10, 'W'),
	(7, 1, 'W'),
	(7, 2, 'W'),
	(7, 3, 'W'),
	(7, 4, 'W'),
	(7, 5, 'W'),
	(7, 6, 'W'),
	(7, 7, 'W'),
	(7, 8, 'W'),
	(7, 9, 'W'),
	(7, 10, 'W'),
	(8, 1, 'W'),
	(8, 2, 'W'),
	(8, 3, 'W'),
	(8, 4, 'W'),
	(8, 5, 'W'),
	(8, 6, 'W'),
	(8, 7, 'W'),
	(8, 8, 'W'),
	(8, 9, 'W'),
	(8, 10, 'W'),
	(9, 1, 'W'),
	(9, 2, 'W'),
	(9, 3, 'W'),
	(9, 4, 'W'),
	(9, 5, 'W'),
	(9, 6, 'W'),
	(9, 7, 'W'),
	(9, 8, 'W'),
	(9, 9, 'W'),
	(9, 10, 'W'),
	(10, 1, 'W'),
	(10, 2, 'W'),
	(10, 3, 'W'),
	(10, 4, 'W'),
	(10, 5, 'W'),
	(10, 6, 'W'),
	(10, 7, 'W'),
	(10, 8, 'W'),
	(10, 9, 'W'),
	(10, 10, 'W');

-- Dumping structure for procedure adise23_2019_032-240.random_fleet_player_1
DROP PROCEDURE IF EXISTS `random_fleet_player_1`;
DELIMITER //
CREATE PROCEDURE `random_fleet_player_1`()
BEGIN
UPDATE `player_1`  SET `b_color`='G' ORDER BY RAND() LIMIT 12; 
END//
DELIMITER ;

-- Dumping structure for procedure adise23_2019_032-240.random_fleet_player_2
DROP PROCEDURE IF EXISTS `random_fleet_player_2`;
DELIMITER //
CREATE PROCEDURE `random_fleet_player_2`()
BEGIN
update `player_2`  SET `b_color`='G' ORDER BY RAND() LIMIT 10;
END//
DELIMITER ;

-- Dumping structure for procedure adise23_2019_032-240.reset_game_status
DROP PROCEDURE IF EXISTS `reset_game_status`;
DELIMITER //
CREATE PROCEDURE `reset_game_status`()
BEGIN
DELETE FROM `game_status`;
INSERT INTO `game_status` (`status`) VALUES
	('not active');
END//
DELIMITER ;

-- Dumping structure for procedure adise23_2019_032-240.reset_players
DROP PROCEDURE IF EXISTS `reset_players`;
DELIMITER //
CREATE PROCEDURE `reset_players`()
BEGIN
DELETE FROM `players` ;

INSERT INTO `players` (`username`, `player_nr`, `token`) VALUES
	(NULL, 'player_1', NULL);
INSERT INTO `players` (`username`, `player_nr`, `token`) VALUES
	(NULL, 'player_2', NULL);
END//
DELIMITER ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
