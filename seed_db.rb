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
DB = Sequel.connect(adapter: 'mysql', host: ENV['DB_HOST'], user: ENV['DB_USER'], password: ENV['DB_PASS'],
                    loggers: [logger], database: 'zoo_dos')

# Models
class Person < Sequel::Model(DB[:people])
end

class Donor < Sequel::Model(DB[:donors])
end

class Membership < Sequel::Model(DB[:memberships])
end

class PeopleMembership < Sequel::Model(DB[:people_memberships])
end
PeopleMembership.unrestrict_primary_key

logger.info 'Seeding database'
logger.info 'Creating people'
people = []
while people.count < 1000
  people << Person.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    mailing_address: Faker::Address.full_address,
    phone_number: Faker::PhoneNumber.phone_number
  )
end
Person.multi_insert(people)

logger.info 'Creating memberships'
memberships = []
while memberships.count < 750
  memberships << Membership.new(
    subscription_started: Faker::Date.between(from: 1.year.ago, to: Date.today),
    subscription_expires: Faker::Date.between(from: Date.today, to: 1.year.from_now),
    price: Faker::Number.between(from: 190, to: 210)
  )
end
Membership.multi_insert(memberships)

# Linking people to memberships
logger.info 'Linking people to memberships'
people_memberships = []
member_ids = Membership.all.map(&:member_id)
Person.each do |person|
  if rand(1..10) <= 7
    people_membership = PeopleMembership.new(person_id: person.person_id, member_id: member_ids.sample)
    people_memberships << people_membership
  end
end
PeopleMembership.multi_insert(people_memberships)

logger.info 'Disconnected from MySQL database'
