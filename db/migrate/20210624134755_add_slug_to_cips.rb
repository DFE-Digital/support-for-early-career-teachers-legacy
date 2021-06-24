# frozen_string_literal: true

class AddSlugToCips < ActiveRecord::Migration[6.1]
  def change
    add_column :core_induction_programmes, :slug, :string

    CoreInductionProgramme.all.each do |cip|
      cip.update!(slug: cip.name.parameterize)
    end

    change_column_null :core_induction_programmes, :name, false
  end
end
