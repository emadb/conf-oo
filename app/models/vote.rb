class Vote
	include Mongoid::Document
  field :user_id
  field :proposal_id
  field :creation_date, :type => DateTime
end