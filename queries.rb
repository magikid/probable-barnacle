#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'
Dotenv.load
require 'sequel'
require 'logger'
require 'active_support/all'

# Config
logger = Logger.new($stdout)
logger.level = Logger::DEBUG
DB = Sequel.connect(
  adapter: 'mysql',
  host: ENV.fetch('DB_HOST', nil),
  user: ENV.fetch('DB_USER', nil),
  password: ENV.fetch('DB_PASS', nil),
  loggers: [logger],
  database: 'zoo_dos'
)

require './models/person'
require './models/donor'
require './models/membership'
require './models/people_membership'
require './models/item'
require './models/order'
require './models/ticket'
require './models/entrance'

def run_query(logger, number)
    case number
    when 1
        results = Entrance.top_n_popular_hours_to_visit(6)
        logger.info 'Results:'
        results.each { |result| logger.info "Hour: #{result[:hour_entered]}, Entrances: #{result[:entrances]}" }
    when 2
        results = Item.top_n_popular_items(5)
        logger.info 'Results:'
        results.each { |result| logger.info "Item: #{result[:item_name]}, Orders: #{result[:orders]}" }
    when 3
        Membership.no_visits_in(6.months)
    when 4
        Membership.expiring_in(1.month)
    when 5
        Donor.top_n_popular_weeks_to_donate(5)
    when 6
        Donor.average_donation_per_week
    else
        logger.error 'Invalid query number'
    end
end

query_to_run = ARGV[0].to_i
if query_to_run.between?(1, 6)
    logger.info "Running query number #{query_to_run}"
    run_query(logger, query_to_run)
else
    logger.info 'Running all queries'
    (1..6).each do |query_number|
        run_query(logger, query_number)
    end
end
