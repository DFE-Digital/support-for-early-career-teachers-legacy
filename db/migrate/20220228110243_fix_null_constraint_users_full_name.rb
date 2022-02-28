# frozen_string_literal: true

class FixNullConstraintUsersFullName < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :full_name, true
  end
end
