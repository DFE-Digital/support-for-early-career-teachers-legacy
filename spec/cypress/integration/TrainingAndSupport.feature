Feature: Training and Support page
  ECTs should be able to access Training and Support pages for their relevant
  training programmes.

  Background:
    Given seed data should be loaded

  Scenario: Information for Ambition Institute ECT
    Given I am logged in as existing user with email "ambition-institute-early-career-teacher@example.com"
    And I click on "link" containing "Information about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Information about training and support"
    And "page body" should contain "Ambition Institute"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Information for Education Development Trust ECT
    Given I am logged in as existing user with email "education-development-trust-early-career-teacher@example.com"
    When I click on "link" containing "Information about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Information about training and support"
    And "page body" should contain "Education Development Trust"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Information for Teach First ECT
    Given I am logged in as existing user with email "teach-first-early-career-teacher@example.com"
    When I click on "link" containing "Information about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Information about training and support"
    And "page body" should contain "Teach First"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Information for UCL ECT
    Given I am logged in as existing user with email "ucl-early-career-teacher@example.com"
    When I click on "link" containing "Information about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Information about training and support"
    And "page body" should contain "University College London"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Information for Ambition Institute mentor
    Given I am logged in as existing user with email "ambition-institute-mentor@example.com"
    And I click on "link" containing "Information about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Mentoring early career teachers"
    And "page body" should contain "Ambition Institute"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Information for Education Development Trust mentor
    Given I am logged in as existing user with email "education-development-trust-mentor@example.com"
    When I click on "link" containing "Information about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Mentoring early career teachers"
    And "page body" should contain "Education Development Trust"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Information for Teach First mentor
    Given I am logged in as existing user with email "teach-first-mentor@example.com"
    When I click on "link" containing "Information about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Mentoring early career teachers"
    And "page body" should contain "Teach First"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Information for UCL mentor
    Given I am logged in as existing user with email "ucl-mentor@example.com"
    When I click on "link" containing "Information about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Mentoring early career teachers"
    And "page body" should contain "University College London"
    And the page should be accessible
    And percy should be sent snapshot
