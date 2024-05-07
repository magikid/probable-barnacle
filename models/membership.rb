# frozen_string_literal: true

class Membership < Sequel::Model(DB[:memberships])
  many_to_many :people, join_table: :people_memberships
  def self.seed
    insert_members
    link_memberships
  end

  def insert_members
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

  def link_memberships
    memberships = eager(:people).all
    people = Person.all
    memberships.each do |member|
      if member.people.count >= 3
        logger.info "Skipping member #{member.id} because it already has 3 people"
        next
      end
      attempt_linkage(member, people.sample)
    end
  end

  def attempt_linkage(member, person)
    try_count = 0
    begin
      member.add_person(person)
      try_count += 1
    rescue Sequel::UniqueConstraintViolation
      retry if try_count < 3
    end
  end
end
