# frozen_string_literal: true

class Ticket < Sequel::Model(DB[:tickets])
  many_to_one :order

  def self.seed(orders, members)
    generate_tickets(orders, members)
    redeem_some_tickets
  end

  def self.generate_tickets(orders, members)
    tickets = []
    while tickets.count < 1000
      tickets << new(
        start_valid_period: Faker::Date.between(from: 1.year.ago, to: Date.today),
        end_valid_period: Faker::Date.between(from: Date.today, to: 1.year.from_now),
        membership_id: membership(members),
        order_id: orders.sample.order_id, price: Faker::Number.between(from: 10, to: 100)
      )
    end
    multi_insert(tickets)
  end

  def self.membership(members)
    return nil if rand(1..10) > 4

    members.sample.membership_id
  end

  def self.redeem_some_tickets
    tickets = all
    tickets.each do |ticket|
      next unless rand(1..10) > 4

      ticket.update(date_redeemed: Faker::Date.between(from: ticket.start_valid_period,
                                                       to: ticket.end_valid_period))
    end
  end
end
