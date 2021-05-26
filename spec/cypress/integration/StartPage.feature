Feature: Start Page
  Visiting Start Page

  Scenario: Should have feedback link
    When I am on "start" page
    Then "phase banner" should contain "feedback"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Should have cookies link
    When I am on "start" page
    Then "footer" should contain "Cookies"
    And the page should be accessible
    And percy should be sent snapshot

