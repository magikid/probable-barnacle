DROP DATABASE IF EXISTS `zoo_dos`;
CREATE DATABASE `zoo_dos` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `zoo_dos`;

CREATE TABLE `memberships` (
  `membership_id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `subscription_started` date NOT NULL,
  `subscription_expires` date NOT NULL,
  `price` integer NOT NULL
);

CREATE TABLE `people_memberships` (
  `membership_id` integer NOT NULL,
  `person_id` integer UNIQUE NOT NULL,
  PRIMARY KEY (`membership_id`, `person_id`)
);

CREATE TABLE `people` (
  `person_id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `mailing_address` varchar(255) NOT NULL,
  `phone_number` varchar(255) NOT NULL
);

CREATE TABLE `orders` (
  `order_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `person_id` int NOT NULL,
  `order_total` int NOT NULL,
  `order_placed` datetime NOT NULL,
  `order_shipped` datetime
);

CREATE TABLE `items` (
  `item_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `unit_price` int NOT NULL,
  `sale_price` int NOT NULL,
  `discount` int NOT NULL DEFAULT 0,
  `item_name` text
);

CREATE TABLE `order_items` (
  `item_id` integer NOT NULL,
  `order_id` integer NOT NULL,
  PRIMARY KEY (`item_id`, `order_id`)
);

CREATE TABLE `tickets` (
  `ticket_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `start_valid_period` datetime NOT NULL,
  `end_valid_period` datetime NOT NULL,
  `membership_id` int,
  `price` int NOT NULL,
  `order_id` int NOT NULL,
  `date_redeemed` datetime
);

CREATE TABLE `entrances` (
  `entrance_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `ticket_id` int,
  `membership_id` int,
  `time_entered` datetime NOT NULL
);

CREATE TABLE `donors` (
  `donor_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `person_id` int NOT NULL,
  `donation_date` date NOT NULL,
  `donation_amount` int NOT NULL
);

CREATE INDEX `people_index_0` ON `people` (`first_name`);

CREATE INDEX `people_index_1` ON `people` (`last_name`);

CREATE INDEX `people_index_2` ON `people` (`phone_number`);

ALTER TABLE `people_memberships` ADD FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`membership_id`);

ALTER TABLE `people_memberships` ADD FOREIGN KEY (`person_id`) REFERENCES `people` (`person_id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`person_id`) REFERENCES `people` (`person_id`);

ALTER TABLE `order_items` ADD FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`);

ALTER TABLE `order_items` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

ALTER TABLE `tickets` ADD FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`membership_id`);

ALTER TABLE `tickets` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

ALTER TABLE `entrances` ADD FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`ticket_id`);

ALTER TABLE `entrances` ADD FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`membership_id`);

ALTER TABLE `donors` ADD FOREIGN KEY (`person_id`) REFERENCES `people` (`person_id`);
