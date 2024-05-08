# frozen_string_literal: true

class Membership < Sequel::Model(DB[:memberships])
  many_to_many :people, join_table: :people_memberships

  def self.seed(people)
    insert_members
    link_memberships(people)
  end

  def self.insert_members
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

  def self.link_memberships(people)
    memberships = eager(:people).all
    memberships.each do |member|
      next if member.people.count >= 3

      already_attached_ids = member.people.map(&:person_id)
      people = people.reject { |person| already_attached_ids.include?(person.person_id) }

      try_link_member(member, people)
    end
  end

  def self.try_link_member(member, people)
    try_count = 0
    begin
      member.add_person(people.sample)
      try_count += 1
    rescue Sequel::UniqueConstraintViolation
      retry if try_count < 3
    end
  end
end
