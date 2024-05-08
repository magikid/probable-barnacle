# frozen_string_literal: true

class PeopleMembership < Sequel::Model(DB[:people_memberships])
  many_to_one :people, key: [:person_id, :membership_id]
  one_to_many :memberships, key: [:person_id, :membership_id]
end
