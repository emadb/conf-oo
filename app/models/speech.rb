class Speech
  include Mongoid::Document
  field :from, :type => Time
  field :to, :type => Time
  field :room
  field :title
  field :abstract
  field :proposal_id
  embeds_one :speaker, as: :speaker1
end
