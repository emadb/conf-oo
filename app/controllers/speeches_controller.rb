class SpeechesController < ApplicationController

  def index
    @speeches = Speech.all
  end

  def show
    @speech = Speech.find(params[:id])
  end

  def new
    @speech = Speech.new
  end

  def edit
    @speech = Speech.find(params[:id])
    @speech.speaker.bio = "lalalala"
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
