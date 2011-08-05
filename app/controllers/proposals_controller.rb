class ProposalsController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create, :show]
  
  def index
    @proposals = Proposal.all
  end

  def show
    @proposal = Proposal.find(params[:id])
  end

  def new
    @proposal = Proposal.new
  end

  def create
    @proposal = Proposal.new(params[:proposal])
    @proposal.submitted_on = DateTime.new
    if @proposal.save
      redirect_to @proposal, notice: 'Proposal was successfully created.' 
    else
      render action: "new" 
    end
  end
  
  def edit
    @proposal = Proposal.find(params[:id])
  end
  
  def update
    @proposal = Proposal.find(params[:id])

    if @proposal.update_attributes(params[:proposal])
      redirect_to(proposals_path, :notice => 'Salvataggio effettuato.') 
    else
      render :action => "edit"
    end
    
  end

  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy
  end
end
