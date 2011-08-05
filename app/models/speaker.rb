class Speaker
  include Mongoid::Document
  field :name
  field :bio
  field :web_site
  field :twitter
  embedded_in :speech, :inverse_of => :speaker
  accepts_nested_attributes_for :speaker 
end