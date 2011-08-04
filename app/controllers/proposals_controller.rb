class ProposalsController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create]
  def index
    @proposals = Proposal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
    @proposal = Proposal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/new
  # GET /proposals/new.json
  def new
    @proposal = Proposal.new

    respond_to do |format|
      format.html 
      format.json { render json: @proposal }
    end
  end

  # POST /proposals
  # POST /proposals.json
  def create
    @proposal = Proposal.new(params[:proposal])
    @proposal.submitted_on = DateTime.new
    respond_to do |format|
      if @proposal.save
        format.html { redirect_to @proposal, notice: 'Proposal was successfully created.' }
        format.json { render json: @proposal, status: :created, location: @proposal }
      else
        format.html { render action: "new" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy

    respond_to do |format|
      format.html { redirect_to proposals_url }
      format.json { head :ok }
    end
  end
end
