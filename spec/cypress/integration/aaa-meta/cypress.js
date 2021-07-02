/**
 * !!!!!
 *
 * This file name starts with aaa so that it runs before all the other tests
 * which rely on the functionality being tested in this file.
 *
 * Please don't rename it!
 */
describe("Meta test helper tests", () => {
  it("should have login and logout helper commands", () => {
    cy.login();
    cy.url().should("contain", "/dashboard");

    cy.logout();
    cy.get("main").should("contain", "You've signed out");
  });

  it("should have factory_bot helper functions", () => {
    cy.app("clean");

    cy.appFactories([["create", "course_module"]]).as("courseModule");

    cy.login("admin");

    cy.visit("/test-cip-1/year-1/spring-1");
    cy.get("h1").should("contain", "Spring test course module");
  });

  it("should have a cleanable database", () => {
    cy.app("clean");

    cy.appFactories([
      ["create", "core_induction_programme"],
      ["create", "core_induction_programme"],
      ["create", "core_induction_programme"],
    ]);

    cy.login("admin");

    cy.visit("/providers");

    cy.get('.govuk-link:contains("Test Core induction programme")').should(
      "have.length",
      3
    );

    cy.app("clean");
    cy.login("admin");
    cy.visit("/providers");

    cy.get('.govuk-link:contains("Test Core induction programme")').should(
      "have.length",
      0
    );
    cy.contains("No courses were found!");
  });

  it("should start with a clean database", () => {
    cy.login("admin");

    cy.get('.govuk-link:contains("Lead Provider")').should("have.length", 0);
  });
});
