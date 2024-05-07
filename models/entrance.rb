# frozen_string_literal: true

class Entrance < Sequel::Model(DB[:entrances])
  many_to_one :person

  def self.seed
    entrances = []
    people = Person.all
    while entrances.count < 1000
      entrances << new(
        time_entered: Faker::Time.between(from: 1.month.ago, to: Time.now),
        person_id: people.sample.id
      )
    end
    multi_insert(entrances)
  end
end
