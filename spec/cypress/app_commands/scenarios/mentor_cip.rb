# frozen_string_literal: true

year = FactoryBot.create(:course_year)
course_module = FactoryBot.create(:course_module, course_year: year)
FactoryBot.create(:course_lesson, :with_lesson_part, course_module: course_module)

cip_user = FactoryBot.create(:user, :early_career_teacher, full_name: "Demo ECT User")
cip = cip_user.core_induction_programme

CoreInductionProgramme.find(cip.id).update!(course_year_one_id: year.id)

# You have to create this user in your spec before running this scenario
mentor = User.find("53960d7f-1308-4de1-a56d-de03ea8e1d9c")
mentor.mentor_profile.early_career_teacher_profiles = [cip_user.early_career_teacher_profile]
