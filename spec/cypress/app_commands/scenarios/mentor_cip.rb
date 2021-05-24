# frozen_string_literal: true

year = FactoryBot.create(:course_year, mentor_title: "Mentor title")
course_module = FactoryBot.create(:course_module, course_year: year)
FactoryBot.create(:course_lesson, :with_lesson_part, course_module: course_module)

# You have to create this user in your spec before running this scenario
mentor = User.find("53960d7f-1308-4de1-a56d-de03ea8e1d9c")
mentor.core_induction_programme.update!(course_year_one_id: year.id, course_year_two_id: year.id)
