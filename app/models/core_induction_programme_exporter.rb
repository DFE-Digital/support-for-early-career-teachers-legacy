# frozen_string_literal: true

class CoreInductionProgrammeExporter
  def run
    core_induction_programmes = CoreInductionProgramme.order(:name)
    SeedDump.dump(
      core_induction_programmes,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
    )

    years = core_induction_programmes.map(&:course_years).flatten
    SeedDump.dump(
      years,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )

    modules = years.map(&:course_modules_in_order).flatten
    SeedDump.dump(
      modules,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )

    lessons = modules.map(&:course_lessons).flatten
    SeedDump.dump(
      lessons,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )

    parts = lessons.map(&:course_lesson_parts_in_order).flatten
    SeedDump.dump(
      parts,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )

    SeedDump.dump(
      MentorMaterial,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )

    SeedDump.dump(
      MentorMaterial.all.map(&:mentor_material_parts_in_order).flatten,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )
  end
end
