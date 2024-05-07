#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'
Dotenv.load
require 'sequel'
require 'logger'
require 'faker'
require 'active_support/all'

# Config
logger = Logger.new($stdout)
logger.level = Logger::DEBUG
Faker::Config.locale = 'en-US'
DB = Sequel.connect(
  adapter: 'mysql',
  host: ENV.fetch('DB_HOST', nil),
  user: ENV.fetch('DB_USER', nil),
  password: ENV.fetch('DB_PASS', nil),
  loggers: [logger],
  database: 'zoo_dos'
)

# Models
require './models/person'
require './models/donor'
require './models/membership'
require './models/people_membership'

logger.info 'Seeding database'
logger.info 'Creating people'
Person.seed

logger.info 'Creating memberships'
Membership.seed

# Linking people to memberships
logger.info 'Linking people to memberships'
people_memberships = []
member_ids = Membership.all.map(&:member_id)
people_ids = Person.all.map(&:person_id)
min(people_ids.count, member_ids.count).times do
  people_membership = PeopleMembership.new(person_id: people_ids.sample, member_id: member_ids.sample)
  people_memberships << people_membership
end
PeopleMembership.multi_insert(people_memberships)

logger.info 'Disconnected from MySQL database'
