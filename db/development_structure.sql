CREATE TABLE `activities` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `description` varchar(255) default NULL,
  `position` int(11) default NULL,
  `alt_text` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `blacklisted_sites` (
  `id` int(11) NOT NULL auto_increment,
  `url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(50) default '',
  `comment` varchar(255) default '',
  `created_at` datetime NOT NULL,
  `commentable_id` int(11) NOT NULL default '0',
  `commentable_type` varchar(15) NOT NULL default '',
  `user_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `index_comments_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `countries` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `code` varchar(2) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `domains` (
  `id` int(11) NOT NULL auto_increment,
  `url` varchar(255) default NULL,
  `phrase` varchar(255) default NULL,
  `link_name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `key_phrases` (
  `id` int(11) NOT NULL auto_increment,
  `phrase` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `site_id` int(11) default NULL,
  `preferred` tinyint(1) default '0',
  `paid` tinyint(1) default '0',
  `label` varchar(255) default NULL,
  `link_name` varchar(255) default NULL,
  `linkable` tinyint(1) default NULL,
  `domain_id` int(11) default NULL,
  `advertisement_url` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_key_phrases_on_site_id` (`site_id`),
  KEY `index_key_phrases_on_link_name` (`link_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `locations` (
  `id` int(11) NOT NULL auto_increment,
  `addressable_id` int(11) default NULL,
  `addressable_type` varchar(255) default NULL,
  `address_line1` varchar(255) default NULL,
  `address_line2` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(2) default NULL,
  `postal_code` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `directions` varchar(255) default NULL,
  `longitude` float default NULL,
  `latitude` float default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_locations_on_addressable_id_and_addressable_type` (`addressable_id`,`addressable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `metro_service_area_links` (
  `id` int(11) NOT NULL auto_increment,
  `metro_service_area_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `metro_service_areas` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `link_name` varchar(255) default NULL,
  `homepage` int(11) default NULL,
  `domain_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `flash_filename` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_metro_service_areas_on_link_name` (`link_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `open_id_associations` (
  `id` int(11) NOT NULL auto_increment,
  `server_url` blob,
  `handle` varchar(255) default NULL,
  `secret` blob,
  `issued` int(11) default NULL,
  `lifetime` int(11) default NULL,
  `assoc_type` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `open_id_nonces` (
  `id` int(11) NOT NULL auto_increment,
  `nonce` varchar(255) default NULL,
  `created` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `open_id_settings` (
  `id` int(11) NOT NULL auto_increment,
  `setting` varchar(255) default NULL,
  `value` blob,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `payments` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `discount_id` int(11) default NULL,
  `amount` int(11) default NULL,
  `payment_type_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_payments_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `personable_id` int(11) default NULL,
  `personable_type` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `city` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `birth_year` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `description` text,
  `agreed_to_terms` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_people_on_personable_id_and_personable_type` (`personable_id`,`personable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `phones` (
  `id` int(11) NOT NULL auto_increment,
  `callable_id` int(11) default NULL,
  `callable_type` varchar(255) default NULL,
  `number` varchar(255) default NULL,
  `extension` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `phone_type` varchar(255) default NULL,
  `main` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_phones_on_callable_id_and_callable_type` (`callable_id`,`callable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sites` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `free` tinyint(1) default NULL,
  `registration_required` tinyint(1) default NULL,
  `description` text,
  `official` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `country_code` varchar(255) default NULL,
  `topic_id` int(11) default NULL,
  `activity_id` int(11) default NULL,
  `metro_service_area_id` int(11) default NULL,
  `disabled` tinyint(1) default NULL,
  `user_id` int(11) default NULL,
  `ad_only` tinyint(1) default NULL,
  `restrict_to_msa` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sites_on_topic_id` (`topic_id`),
  KEY `index_sites_on_metro_service_area_id` (`metro_service_area_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `states` (
  `id` int(11) NOT NULL auto_increment,
  `code` varchar(2) default NULL,
  `name` varchar(35) default NULL,
  `link_name` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_states_on_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) default NULL,
  `taggable_id` int(11) default NULL,
  `taggable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type` (`taggable_id`,`taggable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `topics` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `parent_id` int(11) default NULL,
  `lft` int(11) default NULL,
  `rgt` int(11) default NULL,
  `root_id` int(11) default NULL,
  `link_name` varchar(255) default NULL,
  `domain_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_topics_on_link_name` (`link_name`),
  KEY `index_topics_on_lft` (`lft`),
  KEY `index_topics_on_rgt` (`rgt`),
  KEY `index_topics_on_root_id` (`root_id`),
  KEY `index_topics_on_parent_id` USING BTREE (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `open_id_url` varchar(255) default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `password_reset_code` varchar(40) default NULL,
  `password_reset_at` datetime default NULL,
  `active` tinyint(1) default '1',
  `admin` tinyint(1) default '0',
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `ub_alias` varchar(255) default NULL,
  `ub_override` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_users_on_email` (`email`),
  KEY `index_users_on_open_id_url` (`open_id_url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('13');

INSERT INTO schema_migrations (version) VALUES ('14');

INSERT INTO schema_migrations (version) VALUES ('15');

INSERT INTO schema_migrations (version) VALUES ('16');

INSERT INTO schema_migrations (version) VALUES ('17');

INSERT INTO schema_migrations (version) VALUES ('18');

INSERT INTO schema_migrations (version) VALUES ('19');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20');

INSERT INTO schema_migrations (version) VALUES ('20080606004453');

INSERT INTO schema_migrations (version) VALUES ('20080606011945');

INSERT INTO schema_migrations (version) VALUES ('20080609010940');

INSERT INTO schema_migrations (version) VALUES ('20080625031020');

INSERT INTO schema_migrations (version) VALUES ('20080707235450');

INSERT INTO schema_migrations (version) VALUES ('20080710201101');

INSERT INTO schema_migrations (version) VALUES ('20080710204213');

INSERT INTO schema_migrations (version) VALUES ('20080710204632');

INSERT INTO schema_migrations (version) VALUES ('20080712193558');

INSERT INTO schema_migrations (version) VALUES ('20080718162518');

INSERT INTO schema_migrations (version) VALUES ('20080722194046');

INSERT INTO schema_migrations (version) VALUES ('20080814162900');

INSERT INTO schema_migrations (version) VALUES ('20080814194900');

INSERT INTO schema_migrations (version) VALUES ('20080814213746');

INSERT INTO schema_migrations (version) VALUES ('21');

INSERT INTO schema_migrations (version) VALUES ('22');

INSERT INTO schema_migrations (version) VALUES ('23');

INSERT INTO schema_migrations (version) VALUES ('24');

INSERT INTO schema_migrations (version) VALUES ('25');

INSERT INTO schema_migrations (version) VALUES ('26');

INSERT INTO schema_migrations (version) VALUES ('27');

INSERT INTO schema_migrations (version) VALUES ('28');

INSERT INTO schema_migrations (version) VALUES ('29');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('30');

INSERT INTO schema_migrations (version) VALUES ('31');

INSERT INTO schema_migrations (version) VALUES ('32');

INSERT INTO schema_migrations (version) VALUES ('33');

INSERT INTO schema_migrations (version) VALUES ('34');

INSERT INTO schema_migrations (version) VALUES ('35');

INSERT INTO schema_migrations (version) VALUES ('36');

INSERT INTO schema_migrations (version) VALUES ('37');

INSERT INTO schema_migrations (version) VALUES ('38');

INSERT INTO schema_migrations (version) VALUES ('39');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('40');

INSERT INTO schema_migrations (version) VALUES ('41');

INSERT INTO schema_migrations (version) VALUES ('42');

INSERT INTO schema_migrations (version) VALUES ('43');

INSERT INTO schema_migrations (version) VALUES ('8');