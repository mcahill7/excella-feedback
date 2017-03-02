class Response < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :value, presence: true
  validate :unique_response, on: :create, unless: "question_id.nil?" || "user_id.nil?"

  def unique_response
    response = Response.where(question_id: question.id, user_id: user.id)
    if response.length > 0
      # print "✘ USER HAS ALREADY SUBMITTED A RESPONSE FOR THIS QUESTION"
      errors.add(:unique_response, "USER HAS ALREADY SUBMITTED A RESPONSE FOR THIS QUESTION")
    else
      # print "✔ UNIQUE RESPONSE"
    end
  end
end
