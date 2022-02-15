# frozen_string_literal: true

class CreateExternalUserProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :external_user_profiles do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
