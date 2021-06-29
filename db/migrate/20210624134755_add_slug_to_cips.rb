# frozen_string_literal: true

SLUGS = {
  "Ambition Institute": "ambition",
  "Education Development Trust": "edt",
}.freeze

class AddSlugToCips < ActiveRecord::Migration[6.1]
  def change
    add_column :core_induction_programmes, :slug, :string

    CoreInductionProgramme.reset_column_information

    CoreInductionProgramme.all.each do |cip|
      cip.update!(slug: SLUGS[cip.name.to_sym] || cip.name.parameterize)
    end

    change_column_null :core_induction_programmes, :name, false
  end
end
