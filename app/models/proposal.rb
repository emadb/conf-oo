class Proposal
  include Mongoid::Document
  embeds_one :speaker, as: :embedded_speaker
  field :title
  field :abstract
  field :submitted_on, :type => Date  
  field :approved, :type => Boolean, :default => false
end
