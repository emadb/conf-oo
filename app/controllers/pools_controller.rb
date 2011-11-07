class PoolsController < ApplicationController
	def index
		@proposals = Proposal.all
		
	end

	def save
		logger.info 'XXXX save XXXX'
		logger.info params
	end
end
