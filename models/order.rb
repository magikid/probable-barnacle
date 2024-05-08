# frozen_string_literal: true

class Order < Sequel::Model(DB[:orders])
  many_to_one :person
  many_to_many :items, join_table: :order_items

  def self.seed(people, items)
    generate_orders(people)
    add_items_to_orders(items)
  end

  def self.generate_orders(people)
    orders = []
    while orders.count < 1000
      orders << new(
        person_id: people.sample.person_id,
        order_placed: Faker::Date.between(from: 1.year.ago, to: Date.today),
        order_total: Faker::Number.decimal(l_digits: 3, r_digits: 2),
        order_shipped: order_shipped_date
      )
    end
    multi_insert(orders)
  end

  def self.add_items_to_orders(items)
    orders = eager(:items).all
    orders.each do |order|
      next if order.items.count >= 5

      order.add_item(items.sample)
    end
  end

  def self.order_shipped_date
    return nil unless rand(1..10) > 4

    Faker::Date.between(from: 1.year.ago, to: Date.today)
  end
end
