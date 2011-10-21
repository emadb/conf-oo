class Speaker
  include Mongoid::Document
  validates_presence_of :name, :bio, :email
  field :name
  field :bio
  field :email
  field :blog
  field :twitter
  
  embedded_in :embedded_speaker, polymorphic: true
  accepts_nested_attributes_for :speaker
end