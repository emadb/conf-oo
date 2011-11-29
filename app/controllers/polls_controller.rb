class PollsController < ApplicationController
	before_filter :authenticate_user!, :except =>[:login]
	before_filter :user_is_admin?, :except => [:index, :save]
	
	def login

	end

	def index
		@proposals = Proposal.all.shuffle!
	end

	def save
		proposals = params[:proposals]

		current_user_id = current_user.uid

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

	def results
		@proposals = Proposal.all
		
		@proposals = @proposals.map do |p|
			[p.title, p.votes = Vote.where(proposal_id: "#{p._id.to_s}").count]
		end

		render 'results'
	end
end
