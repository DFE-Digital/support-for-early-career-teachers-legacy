# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegisterAndPartnerApi::SyncUsers do
  describe "::perform" do
    before do
      create(:cohort, start_year: 2020)
      create(:cohort, start_year: 2021)
      create(:core_induction_programme, name: "UCL")
    end

    it "imports all users returned" do
      expect {
        described_class.perform
      }.to change(User, :count).by(8)
    end

    it "does not create the users again" do
      expect {
        described_class.perform
        described_class.perform
      }.to change(User, :count).by(8)
    end

    it "does not create a user when given a user type of other" do
      described_class.perform

      record = User.find_by(email: "user_type_other@example.com")
      expect(record.nil?).to be true
      expect(User.count).to eql(8)
    end

    it "creates users with correct attributes" do
      described_class.perform

      record = User.find_by(email: "school-leader@example.com")
      expect(record.full_name).to eql("Induction Tutor")
    end

    it "creates a user with a type of early_career_teacher" do
      described_class.perform

      record = User.find_by(email: "rp-ect-ambition@example.com")
      expect(record.early_career_teacher?).to be true
      expect(record.core_induction_programme).not_to be_nil
    end

    it "creates a user with a cohort year of 2020" do
      create(:cohort, start_year: 2020)
      described_class.perform

      record = User.find_by(email: "nqt_plus_1_user@example.com")
      expect(record.early_career_teacher?).to be true
      expect(record.cohort.start_year).to eql(2020)
    end

    it "updates an existing user that has changed their email address" do
      create(:user, register_and_partner_id: "65abf54c-c7c2-490b-9bcd-bbb4e0aab934", email: "mentor-1@example.com")

      described_class.perform

      record = User.find_by(register_and_partner_id: "65abf54c-c7c2-490b-9bcd-bbb4e0aab934")
      expect(User.count).to eql(8)
      expect(record.email).to eql("mentor@example.com")
    end

    describe "invitations" do
      context "user does not exist" do
        context "registration completed status returned by api is true" do
          it "should create an invite email for new mentors and early career teachers, but only if they are on core induction programme" do
            allow(InviteParticipants).to receive(:run)
            described_class.perform

            expect(InviteParticipants).to have_received(:run).with(["mentor@example.com"])
            expect(InviteParticipants).not_to have_received(:run).with(["school-leader@example.com"])
            expect(InviteParticipants).to have_received(:run).with(["rp-ect-ambition@example.com"])
            expect(InviteParticipants).to have_received(:run).with(["nqt_plus_1_user@example.com"])
          end
        end

        context "registration completed status returned by the api is false" do
          it "should not create an invite email for existing mentors and early career teachers" do
            allow(InviteParticipants).to receive(:run)
            described_class.perform
            expect(InviteParticipants).not_to have_received(:run).with(["non_registrated_user@example.com"])
          end
        end

        context "user is an nqt-plus one ect" do
          it "should create an invite mail" do
            allow(InviteParticipants).to receive(:run)
            described_class.perform
            expect(InviteParticipants).to have_received(:run).with(["nqtplusonenotregistered@example.com"])
          end
        end
      end

      context "user does exist" do
        context "registration completed status returned does not change on api" do
          it "should not create an invite" do
            described_class.perform
            allow(InviteParticipants).to receive(:run)
            described_class.perform

            expect(InviteParticipants).not_to have_received(:run)
          end
        end

        context "registration completed status returned by the api changes from false to true" do
          it "should create an invite" do
            ect = create(:user, :early_career_teacher, email: "nqt_plus_1_user@example.com", register_and_partner_id: "ea9f8ad1-9b54-4806-a78e-5bd92cb3fd6c")
            ect.participant_profile.update!(registration_completed: false)

            allow(InviteParticipants).to receive(:run)
            described_class.perform

            expect(InviteParticipants).to have_received(:run).with(["nqt_plus_1_user@example.com"])
          end
        end

        context "registration completed status returned by the api changes from true to false" do
          it "should not create an invite" do
            ect = create(:user, :early_career_teacher, email: "unverified_user@example.com", register_and_partner_id: "d97fbf35-845g-3g62-q256-bde676314m35")
            ect.participant_profile.update!(registration_completed: true)

            allow(InviteParticipants).to receive(:run)
            described_class.perform

            expect(InviteParticipants).not_to have_received(:run).with(["unverified_user@example.com"])
          end
        end

        context "user changes cohort from 2021 to 2020" do
          it "should create an invite" do
            create(:user, :early_career_teacher, email: "nqtplusonenotregistered@example.com", register_and_partner_id: "4d4e272a-4ff9-459a-9175-2135c744846e", cohort_year: 2021)

            allow(InviteParticipants).to receive(:run)
            described_class.perform
            expect(InviteParticipants).to have_received(:run).with(["nqtplusonenotregistered@example.com"])
          end
        end

        context "user cohort stays as 2020" do
          it "should not create an invite" do
            create(:user, :early_career_teacher, email: "nqtplusonenotregistered@example.com", register_and_partner_id: "4d4e272a-4ff9-459a-9175-2135c744846e", cohort_year: 2020)

            allow(InviteParticipants).to receive(:run)
            described_class.perform
            expect(InviteParticipants).not_to have_received(:run).with(["nqtplusonenotregistered@example.com"])
          end
        end
      end
    end

    it "retrieves and updates the last sync time" do
      time = Time.zone.now
      RegisterAndPartnerApi::SyncUsersTimer.set_last_sync(time)

      stub = stub_request(:get, /https:\/\/api\.example\.com\/api\/v1\/ecf-users\.json.*/)
        .with(query: hash_including({ "filter" => { "updated_since" => time.iso8601 } }))
        .to_return(
          { status: 200, body: file_fixture("api/users_empty.json").read, headers: { content_type: "application/json" } },
        )
      allow(RegisterAndPartnerApi::SyncUsersTimer).to receive(:set_last_sync)
      allow(RegisterAndPartnerApi::SyncUsersTimer).to receive(:last_sync).and_call_original
      described_class.perform
      expect(RegisterAndPartnerApi::SyncUsersTimer).to have_received(:set_last_sync)
      expect(RegisterAndPartnerApi::SyncUsersTimer).to have_received(:last_sync)
      expect(stub).to have_been_requested
    end

    context "cip change messages" do
      context "if the user's cip doesn't change" do
        it "doesn't create a message" do
          create(:user, register_and_partner_id: "d97fbf35-845g-3g62-q256-bde676314m56", email: "my_cip_is_now_teach_first@example.com")
          expect { described_class.perform }.to_not(change { CipChangeMessage.count })
        end
      end

      context "if the user's cip changes" do
        context "they don't have existing messages but haven't seen the guidance yet" do
          it "doesn't create one" do
            create(:core_induction_programme, name: "Teach First")
            user = create(
              :user,
              :early_career_teacher,
              register_and_partner_id: "d97fbf35-845g-3g62-q256-bde676314m56",
              email: "my_cip_is_now_teach_first@example.com",
              core_induction_programme: CoreInductionProgramme.find_by_name("UCL"),
            )
            user.participant_profile.update!(guidance_seen: false)

            expect { described_class.perform }.to_not(change { CipChangeMessage.count })
          end
        end

        context "they don't have an existing message and have seen the guidance" do
          it "it creates one" do
            create(:core_induction_programme, name: "Teach First")
            user = create(
              :user,
              :early_career_teacher,
              register_and_partner_id: "f444d97f-ac3a-45f2-a311-6891679f4bd4",
              email: "my_cip_is_now_teach_first@example.com",
              core_induction_programme: CoreInductionProgramme.find_by_name("UCL"),
            )
            user.participant_profile.update!(guidance_seen: true)
            expect { described_class.perform }.to change { CipChangeMessage.count }.by(1)
          end
        end

        context "they have an existing message" do
          context "and the new cip is different from the original" do
            it "assigns the new cip to the existing message" do
              ambition = create(:core_induction_programme, name: "Ambition Institute")
              teach_first = create(:core_induction_programme, name: "Teach First")
              ucl = CoreInductionProgramme.find_by_name("UCL")
              user = create(
                :user,
                :early_career_teacher,
                register_and_partner_id: "f444d97f-ac3a-45f2-a311-6891679f4bd4",
                email: "my_cip_is_now_teach_first@example.com",
                core_induction_programme: ucl,
              )
              cip_change_message = create(:cip_change_message, user: user, original_cip: ambition, new_cip: ucl)
              user.participant_profile.update!(guidance_seen: true)

              expect { described_class.perform }.to(change { cip_change_message.reload.new_cip }.to(teach_first)
                .and(not_change { cip_change_message.reload.original_cip }))
            end
          end

          context "and the new cip is the same as the original" do
            it "deletes the message" do
              teach_first = create(:core_induction_programme, name: "Teach First")
              ucl = CoreInductionProgramme.find_by_name("UCL")
              user = create(
                :user,
                :early_career_teacher,
                register_and_partner_id: "f444d97f-ac3a-45f2-a311-6891679f4bd4",
                email: "my_cip_is_now_teach_first@example.com",
                core_induction_programme: ucl,
              )
              create(:cip_change_message, user: user, original_cip: teach_first, new_cip: ucl)
              user.participant_profile.update!(guidance_seen: true)

              expect { described_class.perform }.to change { CipChangeMessage.count }.from(1).to(0)
            end
          end
        end
      end
    end
  end
end
