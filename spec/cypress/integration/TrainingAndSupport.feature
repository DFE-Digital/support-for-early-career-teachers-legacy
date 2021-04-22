Feature: Training and Support page
  ECTs should be able to access Training and Support pages for their relevant
  training programmes.

  Scenario: Guidance for Ambition Institute
    Given I am logged in as "early_career_teacher" with id "53960d7f-1308-4de1-a56d-de03ea8e1d9a"
    And scenario "ect_ambition" has been ran
    When I click on "link" containing "Guidance about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Ambition Institute"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Guidance for Education Development Trust
    Given I am logged in as "early_career_teacher" with id "53960d7f-1308-4de1-a56d-de03ea8e1d9a"
    And scenario "ect_edt" has been ran
    When I click on "link" containing "Guidance about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Education Development Trust"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Guidance for Teach First
    Given I am logged in as "early_career_teacher" with id "53960d7f-1308-4de1-a56d-de03ea8e1d9a"
    And scenario "ect_teach-first" has been ran
    When I click on "link" containing "Guidance about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Teach First"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Guidance for UCL
    Given I am logged in as "early_career_teacher" with id "53960d7f-1308-4de1-a56d-de03ea8e1d9a"
    And scenario "ect_ucl" has been ran
    When I click on "link" containing "Guidance about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "UCL"
    And the page should be accessible
    And percy should be sent snapshot
