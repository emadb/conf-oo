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
    @proposal.speaker = Speaker.new
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
      redirect_to(proposals_path, :notice => 'Successfully updated.') 
    else
      render :action => "edit"
    end
    
  end

  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy
    render :json => {:status => 'success'}
  end
  
  def approve
     @proposal = Proposal.find(params[:id])
     @proposal.approved = true;
     @proposal.save()
     create_speech(@proposal)
     render :action => 'show'
  end
  
  def unapprove
     @proposal = Proposal.find(params[:id])
     @proposal.approved = false;
     @proposal.save()
     render :action => 'show'
  end
  
  def create_speech(proposal)
    speech = Speech.new(title: proposal.title, abstract: proposal.abstract) do |doc|
      doc.speaker = create_speaker(proposal.speaker)
    end
    speech.proposal_id = proposal._id
    speech.save
  end
  
  
  def destroy_speech(proposal)
    speech = Speech.find(proposal._id)
    speech.destroy
  end
  
  def create_speaker (speaker)
    Speaker.new(name: speaker.name, bio: speaker.bio, email: speaker.email, twitter: speaker.twitter, blog: speaker.blog)
  end
  
end
