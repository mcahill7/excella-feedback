require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @admin = create(:user, :admin)

    sign_in(@admin)

    @presentation = create(:presentation)
    @survey = create(:survey, position: 1, title: 'Git', presentation_id: @presentation.id)
    @question = create(:question, :number, :required, survey_id: @survey.id)
  end

  describe '#create' do
    let(:success_params) do
      {
        survey_id: @survey_template.id,
        question_template: {
          prompt: 'prompt',
          response_type: 'number',
          response_required: false
        }
      }
    end
    let(:error_params) do
      {
        survey_template_id: @survey_template.id,
        question_template: {
          prompt: nil,
          response_type: nil,
          response_required: false
        }
      }
    end
    it 'should create a new question if User is an Admin' do
      post(:create, params: {
             presentation_id: @presentation.id,
             survey_id: @survey.id,
             question: {
               position: 1,
               prompt: 'prompt',
               response_type: 'number',
               response_required: false
             }
           })

      assert_redirected_to(presentation_survey_path(@presentation.id, @survey.id), 'No redirect to presentation_survey_path')
    end

    it 'should' do

    end
  end

  describe '#update' do
    it 'should allow admin to update questions' do
      updated_prompt = 'Feedback is an internal application that allows?'

      patch(:update, params: {
              presentation_id: @presentation.id,
              survey_id: @survey.id,
              id: @question.id,
              question: {
                prompt: updated_prompt
              }
            })

      @question.reload

      assert_equal @question.prompt, updated_prompt, 'Question prompt before & after update do not match'
    end

    it 'should redirect to correct path after an update' do
      updated_prompt = 'Feedback is an internal application that allows?'

      patch(:update, params: {
              presentation_id: @presentation.id,
              survey_id: @survey.id,
              id: @question.id,
              question: {
                prompt: updated_prompt
              }
            })

      assert_redirected_to(presentation_survey_path(@presentation.id, @survey.id), 'No redirection to presentation_survey_path')
    end
  end
end
