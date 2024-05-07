# frozen_string_literal: true

class Person < Sequel::Model(DB[:people])
  def self.seed
    people = []
    while people.count < 1000
      people << new(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        mailing_address: Faker::Address.full_address,
        phone_number: Faker::PhoneNumber.phone_number
      )
    end
    multi_insert(people)
  end
end
