# frozen_string_literal: true

class RemoveNotNullFullNameConstraint < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :full_name, false
  end
end
