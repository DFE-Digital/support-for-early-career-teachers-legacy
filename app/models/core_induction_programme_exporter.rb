# frozen_string_literal: true

class CoreInductionProgrammeExporter
  def run
    SeedDump.dump(
      CoreInductionProgramme,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
    )

    years = CourseYear.order(:created_at)
    SeedDump.dump(
      years,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )

    modules = years.map { |course_year| course_year.course_modules.order(:created_at) }.flatten
    SeedDump.dump(
      modules,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )

    lessons = modules.map { |course_module| course_module.course_lessons.order(:created_at) }.flatten
    SeedDump.dump(
      lessons,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )

    parts = lessons.map { |course_lesson| course_lesson.course_lesson_parts.order(:created_at) }.flatten
    SeedDump.dump(
      parts,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )
  end
end
