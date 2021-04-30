# frozen_string_literal: true

class MentorMaterialPolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def edit?
    admin_only
  end

  def update?
    admin_only
  end
end
