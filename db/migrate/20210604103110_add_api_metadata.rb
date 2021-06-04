# frozen_string_literal: true

class AddApiMetadata < ActiveRecord::Migration[6.1]
  def change
    create_table :api_metadata, id: :uuid do |t|
      t.timestamps
      t.string :endpoint_name
      t.datetime :last_called_at, null: true
    end
  end
end
