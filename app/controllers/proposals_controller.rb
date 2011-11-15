class ProposalsController < ApplicationController
  before_filter :user_is_admin?, :except => [:new, :create]
  before_filter :set_body_class
  
  def set_body_class
    @page_class = 'proposal'
  end

  def index
    @proposals = Proposal.all.order_by([:submitted_on, :asc])
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
    @proposal.submitted_on = Time.now
    if @proposal.save
      render action: 'confirm' 
    else
      render action: 'new' 
    end
  end

  def confirm
    
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
     destroy_speech(@proposal)
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
    if Speech.exists?(conditions: { proposal_id: proposal._id })
      speech = Speech.first(conditions: { proposal_id: proposal._id })
      speech.destroy
    end
  end
  
  def create_speaker (speaker)
    Speaker.new(name: speaker.name, bio: speaker.bio, email: speaker.email, twitter: speaker.twitter, blog: speaker.blog)
  end
  
end
