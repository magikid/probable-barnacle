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

  def self.top_n_popular_hours_to_visit(n)
    select(Sequel.as(Sequel.extract(:hour, :time_entered), :hour_entered),
           Sequel.as(Sequel.function(:count, Sequel.extract(:hour, :time_entered)), :entrances))
      .group(:hour_entered)
      .order(Sequel.desc(Sequel.function(:count, :hour_entered)))
      .limit(n)
  end
end
