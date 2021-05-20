# frozen_string_literal: true

cip = FactoryBot.create(:core_induction_programme, :with_course_year, id: "a4dc302c-ab71-4d7b-a10a-3116a778e8d5")
FactoryBot.create(:course_module, course_year_id: cip.course_year_one_id)
