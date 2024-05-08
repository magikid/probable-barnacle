# frozen_string_literal: true

class Item < Sequel::Model(DB[:items])
  def self.seed
    items = []
    while items.count < 1000
      items << new(
        unit_price: Faker::Number.between(from: 10, to: 75),
        sale_price: Faker::Number.between(from: 8, to: 70),
        discount: Faker::Number.between(from: 0, to: 10)
      )
    end
    multi_insert(items)
  end
end
