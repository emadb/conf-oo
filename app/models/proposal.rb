class Proposal
  include Mongoid::Document
  field :speaker_name
  field :speaker_email
  field :title
  field :abstract
end
