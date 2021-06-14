# frozen_string_literal: true

class User < ApplicationRecord
  devise :trackable, :passwordless_authenticatable

  has_one :induction_coordinator_profile

  has_one :admin_profile

  has_one :early_career_teacher_profile

  has_one :mentor_profile

  validates :full_name, presence: { message: "Enter your full name" }
  validates :email, presence: true, uniqueness: true, format: { with: Devise.email_regexp }

  def admin?
    admin_profile.present?
  end

  def induction_coordinator?
    induction_coordinator_profile.present?
  end

  def early_career_teacher?
    early_career_teacher_profile.present?
  end

  def mentor?
    mentor_profile.present?
  end

  def core_induction_programme
    return early_career_teacher_profile.core_induction_programme if early_career_teacher?

    mentor_profile.core_induction_programme if mentor?
  end

  def course_years
    core_induction_programme&.course_years || []
  end

  def name
    preferred_name&.presence || full_name
  end

  def user_description
    if admin?
      "DfE admin"
    elsif early_career_teacher?
      "Early career teacher"
    elsif mentor?
      "Mentor"
    else
      "Unknown"
    end
  end

  scope :admins, -> { joins(:admin_profile) }
  scope :early_career_teachers, -> { joins(:early_career_teacher_profile).includes(:early_career_teacher_profile) }
  scope :mentors, -> { joins(:mentor_profile).includes(:mentor_profile) }
end
