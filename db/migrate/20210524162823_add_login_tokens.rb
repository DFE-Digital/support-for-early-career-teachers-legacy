# frozen_string_literal: true

class AddLoginTokens < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      ## Passwordless authenticatable
      t.string :login_token
      t.datetime :login_token_valid_until
    end
  end
end
