class Proposal
  include Mongoid::Document
  validates_presence_of :title, :abstract
  embeds_one :speaker, as: :embedded_speaker
  field :title
  field :abstract
  field :submitted_on, :type => DateTime
  field :approved, :type => Boolean, :default => false

  attr_accessor :votes
end
