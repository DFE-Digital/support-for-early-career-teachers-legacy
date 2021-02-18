# frozen_string_literal: true

class CoreInductionProgrammeExporter
  def run
    SeedDump.dump(
      CoreInductionProgramme,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
    )

    course_years = CourseYear.order(:created_at)
    SeedDump.dump(
      course_years,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )

    course_modules = []
    course_years.each do |course_year|
      course_modules += course_year.course_modules.order(:created_at)
    end
    SeedDump.dump(
      course_modules,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )

    course_lessons = []
    course_modules.each do |course_module|
      course_lessons += course_module.course_lessons.order(:created_at)
    end
    SeedDump.dump(
      course_lessons,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )

    course_lesson_parts = []
    course_lessons.each do |course_lesson|
      course_lesson_parts += course_lesson.course_lesson_parts.order(:created_at)
    end
    SeedDump.dump(
      course_lesson_parts,
      file: "db/seeds/cip_seed_dump.rb",
      exclude: %i[created_at updated_at],
      import: true,
      append: true,
    )
  end
end
