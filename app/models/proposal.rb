class Proposal
  include Mongoid::Document
  embeds_one :speaker, as: :speaker1
  field :title
  field :abstract
  field :submitted_on, :type => Date  
  field :approved, :type => Boolean, :default => false
end
