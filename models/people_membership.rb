# frozen_string_literal: true

class PeopleMembership < Sequel::Model(DB[:people_memberships])
  many_to_one :people
  one_to_many :memberships

  def self.seed; end
end
