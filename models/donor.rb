# frozen_string_literal: true

class Donor < Sequel::Model(DB[:donors])
  many_to_one :person

  def self.seed(people)
    donors = []
    while donors.count < 347
      donors << new(
        donation_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
        donation_amount: Faker::Number.between(from: 100, to: 1000),
        person_id: people.sample.person_id
      )
    end
    multi_insert(donors)
  end

  def self.top_n_popular_weeks_to_donate(n)
    select(Sequel.as(Sequel.function(:weekofyear, :donation_date), :week), Sequel.as(Sequel.function(:count, :donor_id), :donations))
    .group(:week)
    .order(Sequel.desc(:donations))
    .limit(n)
    .all
  end

  def self.average_donation_per_week
    select(Sequel.as(Sequel.function(:weekofyear, :donation_date), :week), Sequel.as(Sequel.function(:avg, :donation_amount), :average_donation))
    .group(:week)
    .order(:week)
    .all
  end
end
