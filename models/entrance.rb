# frozen_string_literal: true

class Entrance < Sequel::Model(DB[:entrances])
  many_to_one :person

  def self.seed(members, tickets)
    entrances = []
    while entrances.count < 1000
      ticket = tickets.sample
      entrances << new(
        ticket_id: ticket.ticket_id,
        time_entered: Faker::Time.between(from: ticket.start_valid_period, to: ticket.end_valid_period),
        membership_id: membership_id(members)
      )
    end
    multi_insert(entrances)
  end

  def self.membership_id(members)
    return nil if rand(1..10) > 3

    members.sample.membership_id
  end
end
