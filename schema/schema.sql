-- MySQL Script generated by MySQL Workbench
-- 11/28/15 14:39:06
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema messages_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema messages_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `messages_db` DEFAULT CHARACTER SET utf8 ;
USE `messages_db` ;

-- -----------------------------------------------------
-- Table `messages_db`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `messages_db`.`Users` (
  `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `messages_db`.`Threads`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `messages_db`.`Threads` (
  `thread_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `subject` VARCHAR(140) NULL,
  PRIMARY KEY (`thread_id`),
  UNIQUE INDEX `subject_id_UNIQUE` (`thread_id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `messages_db`.`Messages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `messages_db`.`Messages` (
  `message_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `sender_id` INT NULL,
  `thread_id` INT UNSIGNED NULL,
  `body` VARCHAR(64000) NULL,
  `parent_message_id` INT UNSIGNED NULL,
  PRIMARY KEY (`message_id`),
  UNIQUE INDEX `comment_id_UNIQUE` (`message_id` ASC),
  INDEX `fk_Comments_Comments_idx` (`parent_message_id` ASC),
  INDEX `fk_Comments_Subjects_idx` (`thread_id` ASC),
  INDEX `fk_Messages_Users_idx` (`sender_id` ASC),
  CONSTRAINT `fk_Comments_Comments`
    FOREIGN KEY (`parent_message_id`)
    REFERENCES `messages_db`.`Messages` (`message_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comments_Subjects`
    FOREIGN KEY (`thread_id`)
    REFERENCES `messages_db`.`Threads` (`thread_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Messages_Users`
    FOREIGN KEY (`sender_id`)
    REFERENCES `messages_db`.`Users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `messages_db`.`Receipts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `messages_db`.`Receipts` (
  `receipt_id` INT UNSIGNED NOT NULL,
  `recipient_id` INT NULL,
  `message_id` INT NULL,
  PRIMARY KEY (`receipt_id`),
  UNIQUE INDEX `receipts_id_UNIQUE` (`receipt_id` ASC),
  INDEX `fk_Receipts_Users_idx` (`recipient_id` ASC),
  INDEX `fk_Receipts_Messages_idx` (`message_id` ASC),
  CONSTRAINT `fk_Receipts_Users`
    FOREIGN KEY (`recipient_id`)
    REFERENCES `messages_db`.`Users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Receipts_Messages`
    FOREIGN KEY (`message_id`)
    REFERENCES `messages_db`.`Messages` (`message_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;