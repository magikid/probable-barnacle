#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'
Dotenv.load
require 'sequel'
require 'logger'

logger = Logger.new($stdout)
logger.level = Logger::DEBUG

logger.info 'Connecting to MySQL database'
DB = Sequel.connect(
  adapter: 'mysql',
  host: ENV.fetch('DB_HOST', nil),
  user: ENV.fetch('DB_USER', nil),
  password: ENV.fetch('DB_PASS', nil),
  loggers: [logger],
  database: 'zoo_dos'
)
logger.info 'Connected to MySQL database'
DB.run('SET FOREIGN_KEY_CHECKS = 0')
DB.tables.each do |table|
  logger.info "Truncating table #{table}"
  DB[table].truncate
end
DB.disconnect
