-- DROP DATABASE FindFolks;
-- CREATE DATABASE FindFolks;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

USE FindFolks
INSERT INTO member (username, password, firstname, lastname, email, zipcode) VALUES
('user1', 'ca5345c244db205261a5b3e46a4d3cfa', 'Ann', 'Anderson', 'user1@gmail.com', 11201),
('user2', '1ccfa1de7b2c274533e9a4d56e771aea', 'Bob', 'Bobber', 'user2@gmail.com', 11201),
('user3', 'c7b13c12f9023a6e8f1ee72c9214f32a', 'Cathy', 'Chen', 'user3@gmail.com', 11201),
('user4', 'efe3482eb818b2c78ca2c938e4c300469517a59095128f0402e520167ba18edb3505691777a95caf15412999cf112707add23204b56418a15a198fa62f1172c0', 'Dan', 'Duval', 'user4@gmail.com', 11201);
          # ^ password changed for sha256 (still does not work because bcrypt adds random salt)

INSERT INTO interest (interest_name) VALUES
('bird-watching'),
('bowling'),
('databases'),
('lacross'),
('ping pong'),
('walking');

INSERT INTO groups (group_id, group_name, description, username) VALUES
(1, 'Brooklyn Ping Pong', 'informal ping  pong tournaments and social events', 'user1'),
(2, 'DB study group', 'work on homework together and do practice quizzes', 'user1'),
(3, 'dumbo walkers', 'Long walks along the Bklyn waterfront', 'user2'),
(4, 'brooklyn bird lovers', 'Bring your binocs and hit Prospect Park', 'user3'),
(5, 'cs for society', 'hackathons to build useful stuff', 'user3');

INSERT INTO about (interest_name, group_id) VALUES
('bird-watching', 4),
('ping pong', 1),
('walking', 4);

INSERT INTO location (lname, zipcode, street, description, latitude, longitude) VALUES
('Pier 1', 10001, '', 'Another pier 1', '41', '-75'),
('Pier 2', 11201, 'Fulton St', 'North end of Bklyn Bridge Park ', '41', '-74'),
('Tandon Gym', 11202, '6 Metrotech', 'Your basic gym. No pool ', '41', '-74'),
('Tandon MakerSpace', 11203, '6 Metrotech', 'lots of gadgets and an event space', '41', '-74');

INSERT INTO events (event_id, title, description, start_time, end_time, lname, zipcode) VALUES
(1, 'End of semester tournament, round 1', 'First round of ping pong tournament', '2016-12-12 17:00:00', '2016-12-12 19:00:00', 'Tandon Gym', 11201),
(2, 'Ping Pong quarter-finals', '16 best from round1', '2016-12-13 17:00:00', '2016-12-13 19:00:00', 'Tandon Gym', 11201),
(3, 'Ping Pong Finals', 'Last rounds of ping pong tournament', '2016-12-14 17:00:00', '2016-12-14 19:00:00', 'Tandon Gym', 11201),
(4, 'Birds of Dumbo database', 'Help create a database tracking bird migrations through the Brooklyn Bridge Park', '2016-12-13 06:00:00', '2016-12-13 10:00:00', 'Pier 1', 11201),
(5, 'Park To Bridge 5K', 'Walk through the park and across the Bklyn Bridge', '2016-12-14 11:00:00', '2016-12-14 01:00:00', 'Pier 1', 11201),
(6, 'hackathon', 'develop aps to help Brooklyn Bridge park', '2016-12-15 14:00:00', '2016-12-15 16:00:00', 'Tandon MakerSpace', 11201),
(7, 'past event', 'awesome event that you missed', '2016-12-09 09:00:00', '2016-12-09 10:00:00', 'Tandon Gym', 11201),
(8, '<script>engineering.nyu.edu</script>', 'cross site scripting lesson', '2016-12-19 12:00:00', '2016-12-19 12:30:00', 'Tandon MakerSpace', 11201),
('9', 'extremely late thanksgiving party', 'lots of food', '2016-12-11 17:00:00', '2016-12-11 23:00:00', 'Tandon Gym', '11201'),
('10', 'extremely late halloween party', 'trick or treating', '2016-12-10 19:00:00', '2016-12-11 23:00:00', 'Pier 1', '10001'),
('11', 'july 4th party', 'independence day yay', '2016-07-04 00:00:00', '2016-07-05 00:00:00', 'Pier 1', '10001');

-- INSERT INTO organize (event_id, group_id) VALUES ('1', '1'), ('7', '4'), ('6', '5'), ('4', '2'), ('9', '2'), ('10', '3');

INSERT INTO belongs_to (group_id, username, authorized) VALUES
(1, 'user1', 1),
(2, 'user1', 1),
(3, 'user1', 1),
(3, 'user2', 1),
(4, 'user1', 0),
(4, 'user3', 1),
(5, 'user3', 1),
(5, 'user4', 0);

INSERT INTO friends (friend_of, friend_to) VALUES
('user1', 'user2'),
('user1', 'user3'),
('user3', 'user1'),
('user4', 'user0');  # friend_to used as primary key

INSERT INTO interested_in (username, interest_name) VALUES
('user1', 'bird-watching'),
('user1', 'databases'),
('user1', 'lacross'),
('user1', 'ping pong');

INSERT INTO attend (event_id, username, rating) VALUES
(1, 'user1', 0),
(1, 'user2', 0),
(1, 'user3', 0),
(1, 'user4', 0),
(2, 'user2', 0),
(3, 'user1', 0),
(3, 'user3', 0),
(4, 'user4', 0),
(5, 'user1', 0),
(5, 'user3', 0),
(6, 'user4', 0),
(7, 'user1', 1),
(9, 'user1', 3),
(10, 'user1', 0),
(9, 'user3', 5),
(10, 'user4', 2);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
