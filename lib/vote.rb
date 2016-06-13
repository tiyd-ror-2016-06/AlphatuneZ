class Vote < ActiveRecord::Base
  validates_presence_of :song, :user, :value, :placed_at
  validates_inclusion_of :value, in: [1,-1]

  # TODO: what about voting for the same song in multiple weeks?
  validates_uniqueness_of :song, scope: :user

  belongs_to :song
  belongs_to :user
end
