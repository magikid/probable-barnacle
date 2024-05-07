# frozen_string_literal: true

class Membership < Sequel::Model(DB[:memberships])
  def self.seed
    memberships = []
    while memberships.count < 750
      memberships << new(
        subscription_started: Faker::Date.between(from: 1.year.ago, to: Date.today),
        subscription_expires: Faker::Date.between(from: Date.today, to: 1.year.from_now),
        price: Faker::Number.between(from: 190, to: 210)
      )
    end
    multi_insert(memberships)
  end
end
