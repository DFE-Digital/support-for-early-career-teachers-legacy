# frozen_string_literal: true

# You have to create this user in your spec before running this scenario
ect = User.find_by(email: "cip-change-early-career-teacher@example.com")
ect.early_career_teacher_profile.update!(guidance_seen: false)
CipChangeMessage.find_by(user: ect).destroy!
