# frozen_string_literal: true

class Item < Sequel::Model(DB[:items])
  def self.seed
    items = []
    while items.count < 1000
      items << new(
        unit_price: Faker::Number.between(from: 10, to: 75),
        sale_price: Faker::Number.between(from: 8, to: 70),
        discount: Faker::Number.between(from: 0, to: 10),
        item_name: Faker::Commerce.product_name
      )
    end
    multi_insert(items)
  end

  def self.top_n_popular_items(n)
    select(:item_name, Sequel.function(:count, :order_id).as(:orders))
      .join(:order_items, item_id: :item_id)
      .group(:item_name)
      .order(Sequel.desc(:orders))
      .limit(n)
      .all
  end
end
