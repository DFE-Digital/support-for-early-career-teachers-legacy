# frozen_string_literal: true

unless Rails.env.production?
  user = User.find_or_create_by!(email: "admin@example.com") do |u|
    u.full_name = "Admin User"
  end
  AdminProfile.find_or_create_by!(user: user)

  user = User.find_or_create_by!(email: "ecf-engage-and-learn@mailinator.com") do |u|
    u.full_name = "Admin User"
  end
  AdminProfile.find_or_create_by!(user: user)

  user = User.find_or_create_by!(email: "school-leader@example.com") do |u|
    u.full_name = "School Leader User"
  end
  InductionCoordinatorProfile.find_or_create_by!(user: user)

  CoreInductionProgramme.all.each do |cip|
    cip_name_for_email = cip.name.gsub(/\s+/, "-").downcase

    ect_user = User.find_or_create_by!(email: "#{cip_name_for_email}-early-career-teacher@example.com") do |u|
      u.full_name = "#{cip.name} ECT User"
    end
    EarlyCareerTeacherProfile.find_or_create_by!(user: ect_user, cohort: Cohort.find_by(start_year: 2021), core_induction_programme: cip,
                                                 induction_programme_choice: "core_induction_programme", registration_completed: true)

    mentor_user = User.find_or_create_by!(email: "#{cip_name_for_email}-mentor@example.com") do |u|
      u.full_name = "#{cip.name} Mentor User"
    end
    MentorProfile.find_or_create_by!(user: mentor_user, cohort: Cohort.find_by(start_year: 2021), core_induction_programme: cip,
                                     induction_programme_choice: "core_induction_programme", registration_completed: true)

    ect_user = User.find_or_create_by!(email: "2020-#{cip_name_for_email}-early-career-teacher@example.com") do |u|
      u.full_name = "#{cip.name} ECT User"
    end
    EarlyCareerTeacherProfile.find_or_create_by!(user: ect_user, cohort: Cohort.find_by(start_year: 2020), core_induction_programme: cip,
                                                 induction_programme_choice: "core_induction_programme", registration_completed: true)
  end

  # CIP-less users
  ect_user = User.find_or_create_by!(email: "cip-less-ect@example.com") do |u|
    u.full_name = "CIP-less ECT User"
  end
  EarlyCareerTeacherProfile.find_or_create_by!(user: ect_user, cohort: Cohort.find_by(start_year: 2021), core_induction_programme: nil, induction_programme_choice: "core_induction_programme")

  mentor_user = User.find_or_create_by!(email: "cip-less-mentor@example.com") do |u|
    u.full_name = "CIP-less Mentor User"
  end
  MentorProfile.find_or_create_by!(user: mentor_user, cohort: Cohort.find_by(start_year: 2021), core_induction_programme: nil, induction_programme_choice: "core_induction_programme")
end
