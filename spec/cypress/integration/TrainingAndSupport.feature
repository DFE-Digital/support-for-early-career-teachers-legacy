Feature: Training and Support page
  ECTs should be able to access Training and Support pages for their relevant
  training programmes.

  Background:
    Given seed data should be loaded

  Scenario: Guidance for Ambition Institute
    Given I am logged in as existing user with email "ambition-institute-early-career-teacher@example.com"
    And I click on "link" containing "Guidance about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Ambition Institute"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Guidance for Education Development Trust
    Given I am logged in as existing user with email "education-development-trust-early-career-teacher@example.com"
    When I click on "link" containing "Guidance about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Education Development Trust"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Guidance for Teach First
    Given I am logged in as existing user with email "teach-first-early-career-teacher@example.com"
    When I click on "link" containing "Guidance about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "Teach First"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Guidance for UCL
    Given I am logged in as existing user with email "ucl-early-career-teacher@example.com"
    When I click on "link" containing "Guidance about training and support during your induction"
    Then I should be on "training and support" page
    And "page body" should contain "UCL"
    And the page should be accessible
    And percy should be sent snapshot
