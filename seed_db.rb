#!/usr/bin/env ruby

require 'dotenv'
Dotenv.load
require 'sequel'
require 'logger'

# connect to mysql
# load zoo_dos.sql
# close connection

logger = Logger.new($stdout)
logger.level = Logger::DEBUG

logger.info "Connecting to MySQL database"
DB = Sequel.connect(adapter: 'mysql', host: ENV['DB_HOST'], user: ENV['DB_USER'], password: ENV['DB_PASS'])
logger.info "Connected to MySQL database"
DB.run(File.read('schema.sql'))
logger.info "Loaded schema.sql"
DB.disconnect
logger.info "Disconnected from MySQL database"
