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
require './models/item'
require './models/order'
require './models/ticket'
require './models/entrance'

logger.info 'Seeding database'
logger.info 'Creating people'
Person.seed

logger.info 'Creating memberships and linking them to people'
Membership.seed(Person.all)

logger.info 'Creating donors and linking them to people'
Donor.seed(Person.all)

logger.info 'Creating items'
Item.seed

logger.info 'Creating orders'
Order.seed(Person.all, Item.all)

logger.info 'Creating tickets'
Ticket.seed(Order.all, Membership.all)

logger.info 'Creating entrances'
Entrance.seed(
  Membership.where(subscription_started: 1.year.ago..Date.today,
                   subscription_expires: Date.today..1.year.from_now).all, Ticket.exclude(date_redeemed: nil).all
)

# Linking people to memberships
logger.info 'Disconnected from MySQL database'
