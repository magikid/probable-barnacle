default: schema truncate seed

schema:
    bundle exec ruby load_schema.rb

truncate:
    bundle exec ruby truncate_tables.rb

seed: truncate
    bundle exec ruby seed_db.rb

