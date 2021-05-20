# frozen_string_literal: true

class AddRegisterAndPartnerIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :register_and_partner_id, :uuid
  end
end
