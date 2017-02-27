class SurveysController < ApplicationController

  def index
    @presentation = Presentation.find(params[:presentation_id])
  end

  def new
    @presentation = Presentation.find(params[:presentation_id])
    @survey = @presentation.surveys.new
  end

  def create
    @presentation = Presentation.find(params[:presentation_id])
    @survey = @presentation.surveys.new(surveys_params)

    if @survey.save
      redirect_to presentation_survey_path(@presentation.id, @survey.id)
    elsif
      render :new
    end
  end

  def show
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:id])
  end

  private
  def surveys_params
    params.require(:survey).permit(:presentation_id, :order, :subject)
  end
end