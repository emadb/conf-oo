class Speech
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  embeds_one :speaker, as: :embedded_speaker
  field :from, :type => Time
  field :to, :type => Time
  field :room
  field :title
  field :abstract
  field :proposal_id
end
