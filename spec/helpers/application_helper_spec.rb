# frozen_string_literal: true

require "rails_helper"

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe "service name helper" do
    it "returns correct service name if current user is mentor" do
      mentor_user = create(:user, :mentor)
      expect(helper.service_name_for(mentor_user)).to eq("Mentoring for early career teachers")
    end

    it "returns correct service name if current user is ECT" do
      mentor_user = create(:user, :early_career_teacher)
      expect(helper.service_name_for(mentor_user)).to eq("Support for early career teachers")
    end

    it "returns correct service name if current user is induction coordinator" do
      mentor_user = create(:user, :induction_coordinator)
      expect(helper.service_name_for(mentor_user)).to eq("Support for early career teachers")
    end

    it "returns correct service name if current user is admin" do
      mentor_user = create(:user, :admin)
      expect(helper.service_name_for(mentor_user)).to eq("Support for early career teachers")
    end

    it "returns correct service name if current user is logged out" do
      expect(helper.service_name_for).to eq("Support for early career teachers")
    end
  end
end
