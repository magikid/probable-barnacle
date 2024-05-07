# frozen_string_literal: true

class Donor < Sequel::Model(DB[:donors])
  def self.seed
    donors = []
    people = People.all
    while donors.count < 347
      donors << new(
        donation_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
        donation_amount: Faker::Number.between(from: 100, to: 1000),
        person_id: people.sample.id
      )
    end
    multi_insert(donors)
  end
end
