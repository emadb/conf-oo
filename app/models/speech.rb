class Speech
  include Mongoid::Document
  field :from, :type => Time
  field :to, :type => Time
  field :room
  field :title
  field :abstract
end
