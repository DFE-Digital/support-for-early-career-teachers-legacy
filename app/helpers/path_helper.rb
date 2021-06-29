# frozen_string_literal: true

# rubocop:disable Rails/HelperInstanceVariable
module PathHelper
  def years_path(*args)
    cip_years_path(*args)
  end

  def year_path(course_year = @course_year, *args)
    cip_year_path(course_year.core_induction_programme, course_year, *args)
  end

  def edit_year_path(course_year = @course_year, *args)
    edit_cip_year_path(course_year.core_induction_programme, course_year, *args)
  end

  def module_path(course_module = @course_module, *args)
    cip_year_module_path(course_module.course_year.core_induction_programme, course_module.course_year, course_module, *args)
  end

  def edit_module_path(course_module = @course_module, *args)
    edit_cip_year_module_path(course_module.course_year.core_induction_programme, course_module.course_year, course_module, *args)
  end

  def lesson_path(course_lesson = @course_lesson, *args)
    cip_year_module_lesson_path(course_lesson.course_module.course_year.core_induction_programme, course_lesson.course_module.course_year, course_lesson.course_module, course_lesson, *args)
  end

  def edit_lesson_path(course_lesson = @course_lesson, *args)
    edit_cip_year_module_lesson_path(course_lesson.course_module.course_year.core_induction_programme, course_lesson.course_module.course_year, course_lesson.course_module, course_lesson, *args)
  end

  def lesson_part_path(lesson_part = @course_lesson_part, *args)
    cip_year_module_lesson_lesson_part_path(lesson_part.course_lesson.course_module.course_year.core_induction_programme, lesson_part.course_lesson.course_module.course_year, lesson_part.course_lesson.course_module, lesson_part.course_lesson, lesson_part, *args)
  end

  def edit_lesson_part_path(lesson_part = @course_lesson_part, *args)
    edit_cip_year_module_lesson_lesson_part_path(lesson_part.course_lesson.course_module.course_year.core_induction_programme, lesson_part.course_lesson.course_module.course_year, lesson_part.course_lesson.course_module, lesson_part.course_lesson, lesson_part, *args)
  end

  def lesson_part_split_path(lesson_part = @course_lesson_part, *args)
    cip_year_module_lesson_lesson_part_split_path(lesson_part.course_lesson.course_module.course_year.core_induction_programme, lesson_part.course_lesson.course_module.course_year, lesson_part.course_lesson.course_module, lesson_part.course_lesson, lesson_part, *args)
  end

  def lesson_part_show_delete_path(lesson_part = @course_lesson_part, *args)
    cip_year_module_lesson_lesson_part_show_delete_path(lesson_part.course_lesson.course_module.course_year.core_induction_programme, lesson_part.course_lesson.course_module.course_year, lesson_part.course_lesson.course_module, lesson_part.course_lesson, lesson_part, *args)
  end

  def lesson_part_update_progress_path(lesson_part = @course_lesson_part, *args)
    cip_year_module_lesson_lesson_part_update_progress_path(lesson_part.course_lesson.course_module.course_year.core_induction_programme, lesson_part.course_lesson.course_module.course_year, lesson_part.course_lesson.course_module, lesson_part.course_lesson, lesson_part, *args)
  end

  def mentor_material_path(mentor_material = @mentor_material, *args)
    cip_year_module_lesson_mentor_material_path(mentor_material.course_lesson.course_module.course_year.core_induction_programme, mentor_material.course_lesson.course_module.course_year, mentor_material.course_lesson.course_module, mentor_material.course_lesson, mentor_material, *args)
  end

  def edit_mentor_material_path(mentor_material = @mentor_material, *args)
    edit_cip_year_module_lesson_mentor_material_path(mentor_material.course_lesson.course_module.course_year.core_induction_programme, mentor_material.course_lesson.course_module.course_year, mentor_material.course_lesson.course_module, mentor_material.course_lesson, mentor_material, *args)
  end

  def mentor_material_part_path(part = @mentor_material_part, *args)
    cip_year_module_lesson_mentor_material_mentor_material_part_path(part.mentor_material.course_lesson.course_module.course_year.core_induction_programme, part.mentor_material.course_lesson.course_module.course_year, part.mentor_material.course_lesson.course_module, part.mentor_material.course_lesson, part.mentor_material, part, *args)
  end

  def edit_mentor_material_part_path(part = @mentor_material_part, *args)
    edit_cip_year_module_lesson_mentor_material_mentor_material_part_path(part.mentor_material.course_lesson.course_module.course_year.core_induction_programme, part.mentor_material.course_lesson.course_module.course_year, part.mentor_material.course_lesson.course_module, part.mentor_material.course_lesson, part.mentor_material, part, *args)
  end

  def mentor_material_part_split_path(part = @mentor_material_part, *args)
    cip_year_module_lesson_mentor_material_mentor_material_part_split_path(part.mentor_material.course_lesson.course_module.course_year.core_induction_programme, part.mentor_material.course_lesson.course_module.course_year, part.mentor_material.course_lesson.course_module, part.mentor_material.course_lesson, part.mentor_material, part, *args)
  end

  def mentor_material_part_show_delete_path(part = @mentor_material_part, *args)
    cip_year_module_lesson_mentor_material_mentor_material_part_show_delete_path(part.mentor_material.course_lesson.course_module.course_year.core_induction_programme, part.mentor_material.course_lesson.course_module.course_year, part.mentor_material.course_lesson.course_module, part.mentor_material.course_lesson, part.mentor_material, part, *args)
  end
end
# rubocop:enable Rails/HelperInstanceVariable
