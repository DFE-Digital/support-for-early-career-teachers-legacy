# frozen_string_literal: true

unless Cohort.first
  Cohort.create!(start_year: 2021)
  Cohort.create!(start_year: 2022)
end

unless Rails.env.production?
  user = User.find_or_create_by!(email: "georgia@example.com") do |u|
    u.full_name = "Georgia"
  end
  EarlyCareerTeacherProfile.find_or_create_by!(user: user, cohort: Cohort.first, core_induction_programme: CoreInductionProgramme.find_by(name: "UCL"))

  user = User.find_or_create_by!(email: "amanda@example.com") do |u|
    u.full_name = "Amanda"
  end
  EarlyCareerTeacherProfile.find_or_create_by!(user: user, cohort: Cohort.first, core_induction_programme: CoreInductionProgramme.find_by(name: "UCL"))
end

unless Rails.env.production?
  if AdminProfile.none?
    user = User.find_or_create_by!(email: "admin@example.com") do |u|
      u.full_name = "Admin User"
    end
    AdminProfile.find_or_create_by!(user: user)
  end

  if InductionCoordinatorProfile.none?
    user = User.find_or_create_by!(email: "school-leader@example.com") do |u|
      u.full_name = "School Leader User"
    end
    InductionCoordinatorProfile.find_or_create_by!(user: user)
  end

  if MentorProfile.none?
    user = User.find_or_create_by!(email: "mentor@example.com") do |u|
      u.full_name = "Mentor User"
    end
    MentorProfile.find_or_create_by!(user: user)
  end

  CoreInductionProgramme.all.each do |cip|
    cip_name_for_email = cip.name.gsub(/\s+/, "-").downcase

    user = User.find_or_create_by!(email: "#{cip_name_for_email}-early-career-teacher@example.com") do |u|
      u.full_name = "#{cip.name} ECT User"
    end
    EarlyCareerTeacherProfile.find_or_create_by!(user: user, cohort: Cohort.first, core_induction_programme: cip, mentor_profile: MentorProfile.first)
  end
end

#  To do - add all cip mentor materials. The below method should work for all others,
# provided material file names are the same as lesson names in the app.
#
# cips = %w[Ambition-Institute]
#
# cips.each do |cip|
#   cip_programme = CoreInductionProgramme.find_by(name: cip_name)
#
# Dir[Rails.root.join("db/seeds/#{cip}")].each do |folder|
#   Dir.foreach("#{folder}") do |sub_folder|
#     next if sub_folder == '.' or sub_folder == '..' or sub_folder == ".DS_Store"
#     Dir.foreach("#{folder}/#{sub_folder}") do |file|
#       next if file === '.' or file === '..'
#       file_content = File.read("#{folder}/#{sub_folder}/#{file}")
#       file_name = file.gsub(".mdx", "")
#       year = cip_programme.course_years.first
#       course_module = CourseModule.find_by(title: sub_folder)
#       course_lesson = CourseLesson.find_by(title: file_name, course_module: course_module)
#
#       if cip === "Education-Development-Trust"
#         file_name = file_name.match(/Block(.*)+/)[0]
#         end
#       MentorMaterial.create!(title: file_name, content: file_content,
#                              core_induction_programme: cip_programme,
#                              course_year: year,
#                              course_module: course_module,
#                              course_lesson: course_lesson
#       )
#     end
#    end
#   end
#  end
