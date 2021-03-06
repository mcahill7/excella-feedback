require 'test_helper'

class SurveyTemplatesHelperTest < ActionView::TestCase
  describe '#action_buttons' do
    it 'shows edit and delete actions for survey templates' do
      survey_template = create(:survey_template)

      edit_path = edit_survey_template_path(survey_template)
      delete_path = survey_template_path(survey_template)

      link_string = action_buttons(edit_path: edit_path, delete_path: delete_path)

      assert link_string.include?('Edit'), 'Link does not include "Edit"'
      assert link_string.include?('Delete'), 'Link does not include "Delete"'
      assert link_string.include?(edit_survey_template_path(survey_template)), 'Link does not include correct path'
    end
  end

  describe '#required_check' do
    it 'checks if a questions_template is required and returns a formatted response' do
      question_required = create(:question_template, :text, :required)
      question_not_required = create(:question_template, :text, :optional)
      expected_required = '✓'
      expected_not_required = ''

      actual_required = required_check(question_required)
      actual_not_required = required_check(question_not_required)

      assert_equal expected_required, actual_required
      assert_equal expected_not_required, actual_not_required
    end
  end

  describe '#new_survey_template_link' do
    it 'shows new actions for survey templates' do
      link_string = new_survey_template_link

      assert link_string.include?('New'), 'Link does not include "New"'
      assert link_string.include?(new_survey_template_path), 'Link does not include correct path'
    end
  end
end
