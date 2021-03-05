# frozen_string_literal: true

class CourseLessonPartPolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    true
  end

  def create?
    admin_only
  end

  def update?
    admin_only
  end

  def show_split?
    edit?
  end

  def split?
    update?
  end

  def show_delete?
    update?
  end

  def destroy?
    update?
  end
end
