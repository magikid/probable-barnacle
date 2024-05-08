# frozen_string_literal: true

class Entrance < Sequel::Model(DB[:entrances])
  many_to_one :person

  def self.seed
    entrances = []
    while entrances.count < 1000
      entrances << new(
        ticket_id: Ticket.all.sample.ticket_id,
        time_entered: Faker::Time.between(from: 1.month.ago, to: Time.now)
      )
    end
    multi_insert(entrances)
  end
end
