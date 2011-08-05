class Speech
  include Mongoid::Document
  field :from, type => DateTime
  field :to, type => DateTime
  field :title
  field :abstract
  field :room
  embeds_one :speaker, class_name: "Speaker", inverse_of: :talk
end
