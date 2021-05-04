# frozen_string_literal: true

class RenameUsername < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :username, :preferred_name
  end
end
