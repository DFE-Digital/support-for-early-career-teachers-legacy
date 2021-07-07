CoreInductionProgramme.import([:id, :name, :course_year_one_id, :course_year_two_id, :slug], [
  ["f051fd20-3f97-4a09-8ba0-01bd355c2221", "Test Core induction programme", nil, nil, "test-cip-348"],
  ["cdb9018d-58bb-444a-ae41-57b51f0b9862", "Test Core induction programme", nil, nil, "test-cip-349"]
])
CourseYear.import([:id, :title, :content, :mentor_title, :core_induction_programme_id, :position], [
  ["2da9cc9b-d84f-49b7-8dea-67a9481dbc73", "Test Course year", "No content", nil, "f051fd20-3f97-4a09-8ba0-01bd355c2221", 1],
  ["68d97e37-d579-4fff-9b90-5d4013ab7d3a", "Test Course year", "No content", nil, "cdb9018d-58bb-444a-ae41-57b51f0b9862", 1]
])
CourseModule.import([:id, :title, :ect_summary, :previous_module_id, :course_year_id, :term, :mentor_summary, :page_header], [
  ["346d2975-0181-4b91-8f93-909b8acd678b", "Test Course module", "No content", nil, "68d97e37-d579-4fff-9b90-5d4013ab7d3a", "spring", nil, nil]
])
CourseLesson.import([:id, :title, :previous_lesson_id, :course_module_id, :completion_time_in_minutes, :ect_summary, :mentor_summary, :position, :mentor_title, :ect_teacher_standards, :mentor_teacher_standards], [
  ["88a8cebc-3598-4d08-b5c8-1b890c196ab7", "Test Course lesson 142", nil, "346d2975-0181-4b91-8f93-909b8acd678b", nil, nil, nil, 1, nil, nil, nil]
])
