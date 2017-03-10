#
# SurveysController
#
class SurveysController < ApplicationController
  before_action :authenticate_admin, only: [:index, :new, :create, :update, :delete]

  #
  # Index route
  #
  def index
    @presentation = Presentation.find(params[:presentation_id])
  end

  #
  # New route
  #
  def new
    @presentation = Presentation.find(params[:presentation_id])
    @survey = @presentation.surveys.new
  end

  #
  # Create route
  #
  def create
    @presentation = Presentation.find(params[:presentation_id])
    @survey = @presentation.surveys.new(survey_params)

    if @survey.save
      flash[:success] = success_message(@survey, :create)
      redirect_to presentation_survey_path(@presentation.id, @survey.id)
    elsif
      flash.now[:error] = error_message(@survey, :create)
      render :new
    end
  end

  #
  # Show route
  #
  def show
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:id])
  end

  #
  # Edit route
  #
  def edit
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:id])
  end

  #
  # Update route
  #
  def update
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:id])

    if @survey.update(survey_params)
      flash[:success] = success_message(@survey, :update)
      redirect_to presentation_survey_path(@presentation.id, @survey.id)
    else
      flash.now[:error] = error_message(@survey, :create)
      render :edit
    end
  end

  #
  # Destroy route
  #
  def destroy
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:id])

    if @survey.destroy
      flash[:success] = success_message(@survey, :delete)
      redirect_to presentation_surveys_path
    else
      flash[:error] = error_message(@question, :delete)
      redirect_back fallback_location: presentation_survey_path(@presentation.id, @survey.id)
    end
  end

  private

  #
  # Set and sanitize survey params
  #
  def survey_params
    params.require(:survey).permit(:presentation_id, :order, :subject, :position)
  end
end
