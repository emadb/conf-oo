class Speaker
  include Mongoid::Document
  field :name
  field :bio
  field :web_site
  field :twitter
  embedded_in :speech
end