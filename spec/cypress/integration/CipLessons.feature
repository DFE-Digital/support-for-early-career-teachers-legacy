Feature: Core Induction Programme lessons
  Users should be able to view and sometimes edit cip lessons.

  Scenario: Admins can edit lessons
    Given I am logged in as "admin"
    And course_lesson was created as "with_lesson_part" with id "a4dc302c-ab71-4d7b-a10a-3116a778e8d5"
    And I am on "core induction programme lesson" page with id "a4dc302c-ab71-4d7b-a10a-3116a778e8d5"

    When I click on "link" containing "Edit lesson"
    Then I should be on "core induction programme lesson edit" page
    And the page should be accessible
    And percy should be sent snapshot called "edit lesson page"

    When I clear "lesson title input"
    And I type "New lesson title" into "lesson title input"
    And I type "45" into "time input"
    And I click the submit button
    Then "page body" should contain "Your changes have been saved"
    And "page body" should contain "New lesson title"
    And "page body" should contain "Duration: 45 minutes"

    When I click on "link" containing "Edit lesson part"
    Then the page should be accessible
    And percy should be sent snapshot called "edit lesson part page"

    When I clear "title input"
    And I type "Lesson part test title" into "title input"
    And I clear "content input"
    And I type "New content for lesson part" into "content input"
    And I click on "button" containing "See preview"
    Then "page heading" should contain "preview"
    And "govspeak content" should contain "New content for lesson part"

    When I click on "button" containing "Save changes"
    Then "page body" should contain "Your changes have been saved"
    And "page body" should contain "Lesson part test title"
    And "page body" should contain "New content for lesson part"

  Scenario: Admins can create content-less lessons
    Given I am logged in as "admin"
    And scenario "cip_year_module" has been ran
    And I am on "core induction programme show" page with id "a4dc302c-ab71-4d7b-a10a-3116a778e8d5"

    When I click on "link" containing "Create CIP Lesson"
    Then I should be on "core induction programme lesson new" page
    And "page heading" should contain "Create lesson"
    And the page should be accessible

    When I type "New content-less lesson" into "lesson title input"
    And I type "30" into "time input"
    And I type "Some ECT summary" into "ect summary input"
    And I type "Some mentor summary" into "mentor summary input"
    And I click on "button" containing "Create lesson"

    Then I should be on "core induction programme lesson" page
    And "page heading" should contain "New content-less lesson"
    And "page body" should contain "Duration: 30 minutes"
    And the page should be accessible

  Scenario: Admins can edit lessons without lesson part
    Given I am logged in as "admin"
    And course_lesson was created with id "a4dc302c-ab71-4d7b-a10a-3116a778e8d5"
    And I am on "core induction programme lesson" page with id "a4dc302c-ab71-4d7b-a10a-3116a778e8d5"

    When I click on "link" containing "Spring test course module"
    Then I should be on "core induction programme module" page
    And the page should be accessible
    And percy should be sent snapshot

    When I click on "link" containing "View the lesson"
    Then I should be on "core induction programme lesson" page

  Scenario: ECTs shouldn't be able to edit lessons
    Given I am logged in as "early_career_teacher" with id "53960d7f-1308-4de1-a56d-de03ea8e1d9c"
    And scenario "ect_cip" has been ran

    When I click on "link" containing "Go to your module materials"
    When I click on "link" containing "Test Course module"
    When I click on "link" containing "Work through the self-study material"
    Then I should be on "core induction programme lesson part" page
    And "link" containing "Edit lesson" should not exist
    And "link" containing "Edit lesson part" should not exist

  Scenario: ECTs should be able to view lesson progress
    Given I am logged in as "early_career_teacher" with id "53960d7f-1308-4de1-a56d-de03ea8e1d9c"
    And scenario "ect_cip" has been ran
    When I click on "link" containing "Go to your module materials"

    When I click on "link" containing "Test Course module"
    Then "tag component" should contain "to do"
    And percy should be sent snapshot

    When I click on "link" containing "Work through the self-study material"
    And I click on "No, I’d like to spend more time on this topic" label
    And I click the submit button
    Then "tag component" should contain "in progress"

    When I click on "link" containing "Work through the self-study material"
    And I click on "I have not started this topic yet and was just browsing the materials" label
    And I click the submit button
    Then "tag component" should contain "to do"

    When I click on "link" containing "Work through the self-study material"
    And I click on "Yes, I’ve understood the topic materials and am ready to put my learning into practice in the classroom" label
    And I click the submit button
    Then "tag component" should contain "complete"
