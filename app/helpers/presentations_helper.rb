module PresentationsHelper

  def presentations_as(role, user)
    case role
    when :presenter
      is_presenter = true
    when :attendee
      is_presenter = false
    else
      return Presentation.none
    end

    Presentation.joins(:users, :participations).where(
      users: { id: user.id },
      participations: { is_presenter: is_presenter }
    ).distinct
  end

  def admin_table(user)
    if user.is_admin
      render partial: 'presentations/table', locals: { title: "As Admin", presentations: @presentations, feedback_message: nil }
    end
  end

  def general_user_table(user:, role:, title:, feedback_message:)
    if !user.is_admin && presentations_as(role, user).any?
      render partial: 'presentations/table', locals: { title: title, presentations: presentations_as(role, user), feedback_message: feedback_message }
    end
  end

  def feedback_header(user)
    user.is_admin ? 'Admin' : 'Feedback'
  end

  def display_description(presentation)
    if presentation.description.length > 30
      description = content_tag(:span, presentation.description_short(30))
      view_link = content_tag(:a, '(more)', tabindex: '0', role: 'button',
        data: {
          toggle: 'popover',
          placement: 'bottom',
          trigger: 'focus',
          content: presentation.description
        }
      )
      description + view_link
    else
      presentation.description
    end
  end

  def feedback_content(user:, presentation:, feedback_message:)
    participation = Participation.where(presentation_id: presentation.id).where(user_id: user.id).first
    if user.is_admin
      survey_link = survey_link_for(presentation)
      edit_link = link_to "Edit", edit_presentation_path(presentation), class: 'btn btn-primary'
      delete_link = link_to "Delete", presentation_path(presentation), class: 'btn btn-danger', method: :delete

      survey_link + edit_link + delete_link
    # If user is a presenter
    elsif (participation && participation.is_presenter == true)
      link_to feedback_message, presentation_responses_path(presentation), class: 'btn btn-default'
    # If user is an attendee
    else
      link_to feedback_message, new_presentation_response_path(presentation), class: 'btn btn-default'
    end
  end

  def survey_link_for(presentation)
    if presentation.surveys.any?
      link_to "See Surveys", presentation_surveys_path(presentation), class: 'btn btn-default'
    else
      link_to "Create Survey", new_presentation_survey_path(presentation), class: 'btn btn-default'
    end
  end

end
