class AddCipChangeMessage < ActiveRecord::Migration[6.1]
  def change
    create_table :cip_change_messages do |t|
      t.references :user, index: true, unique: true
      t.references :original_cip, foreign_key: { to_table: 'core_induction_programmes' }
      t.references :new_cip, foreign_key: { to_table: 'core_induction_programmes' }
    end
  end
end
