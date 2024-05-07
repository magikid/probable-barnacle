CREATE TABLE `memberships` (
  `member_id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `subscription_started` date NOT NULL,
  `subscription_expires` date NOT NULL,
  `price` int NOT NULL
);

CREATE TABLE `people_memberships` (
  `member_id` integer NOT NULL,
  `person_id` integer UNIQUE NOT NULL,
  PRIMARY KEY (`member_id`, `person_id`)
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
  `discount` int NOT NULL DEFAULT 0
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
  `member_id` int,
  `price` int NOT NULL,
  `order_id` int NOT NULL,
  `date_redeemed` datetime
);

CREATE TABLE `entrances` (
  `ticket_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
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

ALTER TABLE `people_memberships` ADD FOREIGN KEY (`member_id`) REFERENCES `memberships` (`member_id`);

ALTER TABLE `people` ADD FOREIGN KEY (`person_id`) REFERENCES `people_memberships` (`person_id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`person_id`) REFERENCES `people` (`person_id`);

ALTER TABLE `items` ADD FOREIGN KEY (`item_id`) REFERENCES `order_items` (`item_id`);

ALTER TABLE `tickets` ADD FOREIGN KEY (`member_id`) REFERENCES `memberships` (`member_id`);

ALTER TABLE `tickets` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

ALTER TABLE `donors` ADD FOREIGN KEY (`person_id`) REFERENCES `people` (`person_id`);
