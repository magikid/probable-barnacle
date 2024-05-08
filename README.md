# CSCI E-59 Final Project

This repo contains the code to generate my final project database for CSCI E-59.  This database contains information about zoo memberships, donors, orders, and entrances.

## Getting Started
You'll need Ruby 3.1.6 installed and a mysql database somewhere.  Mine is in the cloud.  To get started, clone this repo and run `bundle install` to install the required gems.  Once you have it all installed, copy the `.env.example` file to `.env` and fill in the appropriate values for your database connection

Now that you've got all that done, you can use the `just` command to seed the database, run the queries, and lint the code.  Here are the available commands:
```
just # Loads the schema, truncates the tables, and seeds the database
just seed # Only re-seeds the database
just lint # Lints the code
just fix # Fixes the linting errors
just query # Runs the queries
```
