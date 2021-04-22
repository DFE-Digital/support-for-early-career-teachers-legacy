# frozen_string_literal: true

cip = FactoryBot.create(:core_induction_programme, name: "Ambition Institute")
# You have to create this user in your spec before running this scenario
User.find("53960d7f-1308-4de1-a56d-de03ea8e1d9a").core_induction_programme = cip
