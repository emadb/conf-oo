class PoolsController < ApplicationController
	def index
		@proposals = Proposal.all
	end

	def save
		proposals = params[:proposals]
		#user = ...
		
		proposals.each do |p|
			# save result
		end

	end
end
