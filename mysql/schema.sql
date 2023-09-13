DROP TABLE IF EXISTS comment;
CREATE TABLE comment (
  id BIGINT NOT NULL, 
  approved BIT, 
  date DATETIME(6), 
  commit_id VARCHAR(255), 
  model_type VARCHAR(255), 
  path VARCHAR(4000), 
  ref_id VARCHAR(255), 
  released BIT, 
  repository_path VARCHAR(255), 
  restricted_to_role VARCHAR(255), 
  text VARCHAR(4000), 
  reply_to_id BIGINT, 
  user_id BIGINT, 
  PRIMARY KEY (id)
) engine = InnoDB;

DROP TABLE IF EXISTS job;
CREATE TABLE job (
  id BIGINT NOT NULL, 
  data VARCHAR(255), 
  token VARCHAR(255), 
  type VARCHAR(255), 
  valid_until DATE, 
  PRIMARY KEY (id)
) engine = InnoDB;

DROP TABLE IF EXISTS restriction;
CREATE TABLE restriction_set (
  id BIGINT NOT NULL,
  name VARCHAR(255),
  ref_ids LONGTEXT,
  PRIMARY KEY (id)
) engine=InnoDB;

DROP TABLE IF EXISTS membership;
CREATE TABLE membership (
  id BIGINT NOT NULL, 
  member_of VARCHAR(255), 
  role VARCHAR(255), 
  team_id BIGINT, 
  user_id BIGINT, 
  PRIMARY KEY (id)
) engine = InnoDB;

DROP TABLE IF EXISTS message;
CREATE TABLE message (
  id BIGINT NOT NULL, 
  date DATETIME(6), 
  read_date DATETIME(6), 
  show_read_receipt BIT, 
  text VARCHAR(4000), 
  from_id BIGINT, 
  team_id BIGINT, 
  to_id BIGINT, 
  PRIMARY KEY (id)
) engine = InnoDB;

DROP TABLE IF EXISTS review_reference;
CREATE TABLE review_reference (
  id BIGINT NOT NULL, 
  commit_id VARCHAR(255), 
  ref_id VARCHAR(255), 
  type VARCHAR(255), 
  reviewer_id BIGINT, 
  references_id BIGINT, 
  PRIMARY KEY (id)
) engine = InnoDB;

DROP TABLE IF EXISTS task_assignment;
CREATE TABLE task_assignment (
  id BIGINT NOT NULL, 
  canceled BIT, 
  end_date DATETIME(6), 
  iteration BIGINT, 
  start_date DATETIME(6), 
  assigned_to_id BIGINT, 
  ended_by_id BIGINT, 
  assignments_id BIGINT, 
  PRIMARY KEY (id)
) engine = InnoDB;


DROP TABLE IF EXISTS review;
CREATE TABLE review (
  id BIGINT NOT NULL, 
  comment VARCHAR(4000), 
  end_date DATETIME(6), 
  name VARCHAR(255), 
  repository_path VARCHAR(255), 
  start_date DATETIME(6), 
  state VARCHAR(255), 
  initiator_id BIGINT, 
  PRIMARY KEY (id)
) engine = InnoDB;

DROP TABLE IF EXISTS setting;
CREATE TABLE setting (
  id BIGINT NOT NULL, 
  data LONGBLOB, 
  name VARCHAR(255), 
  owner VARCHAR(255), 
  type VARCHAR(255), 
  value VARCHAR(4000), 
  PRIMARY KEY (id)
) engine = InnoDB;

DROP TABLE IF EXISTS team_users;
CREATE TABLE team_users (
  team_id BIGINT NOT NULL,
  users_id BIGINT NOT NULL
) engine = InnoDB;

DROP TABLE IF EXISTS team;
CREATE TABLE team (
  id BIGINT NOT NULL, 
  avatar LONGBLOB, 
  name VARCHAR(255), 
  teamname VARCHAR(255), 
  PRIMARY KEY (id)
) engine = InnoDB;

DROP TABLE IF EXISTS user_blocked_users;
CREATE TABLE user_blocked_users (
  user_id BIGINT NOT NULL,
  blocked_users_id BIGINT NOT NULL
) engine = InnoDB;

DROP TABLE IF EXISTS user;
CREATE TABLE user (
  id BIGINT NOT NULL, 
  avatar LONGBLOB, 
  email VARCHAR(255), 
  name VARCHAR(255), 
  password VARCHAR(255), 
  active_until DATE, 
  admin BIT, 
  can_create_groups BIT, 
  can_create_repositories BIT, 
  data_manager BIT, 
  max_size BIGINT, 
  messaging_enabled BIT, 
  no_of_repositories INTEGER, 
  notifications BIGINT, 
  show_comment_activities BIT, 
  show_commit_activities BIT, 
  show_online_status BIT, 
  show_read_receipt BIT, 
  show_task_activities BIT, 
  user_manager BIT, 
  two_factor_secret VARCHAR(255), 
  username VARCHAR(255), 
  PRIMARY KEY (id)
) engine = InnoDB;

ALTER TABLE comment ADD CONSTRAINT FKqys9mdo2xp2p1848yk002bw8e FOREIGN KEY (reply_to_id) REFERENCES comment (id);
ALTER TABLE comment ADD CONSTRAINT FK8kcum44fvpupyw6f5baccx25c FOREIGN KEY (user_id) REFERENCES user (id);
ALTER TABLE membership ADD CONSTRAINT FK7mts58iqmathhpvblj7mj4yna FOREIGN KEY (team_id) REFERENCES team (id);
ALTER TABLE membership ADD CONSTRAINT FKjp7ht675da9n751xycuwii77s FOREIGN KEY (user_id) REFERENCES user (id);
ALTER TABLE message ADD CONSTRAINT FKkn6rt8591aaepiuacwuggj556 FOREIGN KEY (from_id) REFERENCES user (id);
ALTER TABLE message ADD CONSTRAINT FKjenmv4nkp4appqtxwk7cff8qt FOREIGN KEY (team_id) REFERENCES team (id);
ALTER TABLE message ADD CONSTRAINT FK7w4n34mf259wjvyqqc0pb534n FOREIGN KEY (to_id) REFERENCES user (id);
ALTER TABLE review ADD CONSTRAINT FKk2s031yih5b66mk2d1xpq4tfj FOREIGN KEY (initiator_id) REFERENCES user (id);
ALTER TABLE review_reference ADD CONSTRAINT FK4nhj8hy6l3c4beagdrtwaebal FOREIGN KEY (reviewer_id) REFERENCES user (id);
ALTER TABLE review_reference ADD CONSTRAINT FK5xdspyl5kpqg3vypqydnocv5f FOREIGN KEY (references_id) REFERENCES review (id);
ALTER TABLE task_assignment ADD CONSTRAINT FKf9gbrlloc1ymvr72i9ovfncr6 FOREIGN KEY (assigned_to_id) REFERENCES user (id);
ALTER TABLE task_assignment ADD CONSTRAINT FKcflcd8s8mupwk51gf6ytkrbap FOREIGN KEY (ended_by_id) REFERENCES user (id);
ALTER TABLE task_assignment ADD CONSTRAINT FKl8xt4oops51t1na4eax9gn2or FOREIGN KEY (assignments_id) REFERENCES review (id);
ALTER TABLE team_users ADD CONSTRAINT FKwc6xami57s4arstpnvqwccj8 FOREIGN KEY (users_id) REFERENCES user (id);
ALTER TABLE team_users ADD CONSTRAINT FKrkg4q3rf6sjc1mpnw9enibvh3 FOREIGN KEY (team_id) REFERENCES team (id);
ALTER TABLE user_blocked_users ADD CONSTRAINT FKdalh7bfc8m46286xk6cpmkj9c FOREIGN KEY (blocked_users_id) REFERENCES user (id);
ALTER TABLE user_blocked_users ADD CONSTRAINT FKrfu5nmyf90ym7iv09rvduv86p FOREIGN KEY (user_id) REFERENCES user (id);

INSERT INTO user(id, username, name, email, password, admin, can_create_groups, can_create_repositories, data_manager, max_size, messaging_enabled, no_of_repositories, notifications, show_comment_activities, show_commit_activities, show_online_status, show_read_receipt, show_task_activities, user_manager) VALUES (1, 'administrator', 'Administrator', 'please@change.me', '$2a$10$KN.4Uc0CngMH5qitgaLi.eM0gEi1tJioSdUwwKClLa1LA1E4XYXxe', 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1);