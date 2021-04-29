# frozen_string_literal: true

class AddInviteEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :tracked_emails, id: :uuid do |t|
      t.string :type

      t.string :sent_to
      t.timestamps

      t.string :notify_id
      t.string :notify_status
      t.datetime :sent_at
      t.datetime :delivered_at

      t.references :user, null: false, foreign_key: true, type: :uuid
    end
  end
end
