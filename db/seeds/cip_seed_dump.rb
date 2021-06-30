CourseYear.import([:id, :title, :content, :version, :mentor_title], [
  ["64fdf6ba-9cc9-4d30-9eff-88f6f812fa43", "Test Course year", "No content", 1, nil],
  ["b9d546e9-4e14-43e0-b615-a8938691bfb0", "Test Course year", "No content", 1, nil],
  ["e39baf97-012d-4edd-97cc-945a76b33373", "Test Course year", "No content", 1, nil]
])
CoreInductionProgramme.import([:id, :name, :course_year_one_id, :course_year_two_id, :slug], [
  ["da7bf10b-fa26-4e61-a01f-b711911e8877", "Test Core induction programme", "64fdf6ba-9cc9-4d30-9eff-88f6f812fa43", "b9d546e9-4e14-43e0-b615-a8938691bfb0", "test-cip-195"]
])
CourseModule.import([:id, :title, :ect_summary, :previous_module_id, :course_year_id, :version, :term, :mentor_summary, :page_header], [
  ["138d5cab-690f-450f-80da-2fa08951bbaf", "Test Course module", "No content", nil, "e39baf97-012d-4edd-97cc-945a76b33373", 1, "spring", nil, nil]
])
CourseLesson.import([:id, :title, :previous_lesson_id, :course_module_id, :version, :completion_time_in_minutes, :ect_summary, :mentor_summary, :position, :mentor_title, :ect_teacher_standards, :mentor_teacher_standards], [
  ["2b2d0110-83af-4a42-ab0b-06a09b128ede", "Test Course lesson 142", nil, "138d5cab-690f-450f-80da-2fa08951bbaf", 1, nil, nil, nil, 1, nil, nil, nil]
])
