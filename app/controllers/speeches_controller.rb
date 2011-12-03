class SpeechesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_body_class


  def set_body_class
    @page_class = 'proposal'
  end

  def index
    @speeches = Speech.all
    @speeches.each do |s| 
      logger.info s.title
      logger.info s.speaker.name
      logger.info s.speaker.twitter
    end
    respond_to do |format|
       format.json { render :json=> @speeches.to_json }
       format.html { render 'index'}
    end
  end

  def show
    @speech = Speech.find(params[:id])
  end

  def new
    @speech = Speech.new
  end

  def edit
    @speech = Speech.find(params[:id])
  end

  def create
    @speech = Speech.new(params[:speech])
    if @speech.save
      redirect_to @speech, notice: 'Speech was successfully created.'        
    else
      render action: "new" 
    end
  end

  def update
    @speech = Speech.find(params[:id])
      
    if @speech.update_attributes(params[:speech])
      redirect_to @speech, notice: 'Speech was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @speech = Speech.find(params[:id])
    @speech.destroy

    redirect_to speeches_url 
  end
end
