class PoolsController < ApplicationController
	def index
		@proposals = Proposal.all
	end

	def save
		proposals = params[:proposals]
		
		current_user_id = 1
		vote_count = Vote.count(conditions: { user_id: current_user_id })
		if vote_count == 0
			proposals.each do |p|
				vote = Vote.new
				vote.user_id = current_user_id
				vote.proposal_id = p
				vote.creation_date = Time.now
				vote.save
			end
			render 'thanks'
		else
			render 'already_voted'
		end
	end
end
