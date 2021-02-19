describe("ECT user interaction with Core Induction Programme", () => {
  beforeEach(() => {
    cy.login("early_career_teacher");
  });

  it("should not show a download export button", () => {
    cy.visit("/core-induction-programme");
    cy.contains("a.govuk-button", "Download export").should("not.exist");
  });

  it("should not allow to edit year title", () => {
    cy.appFactories([["create", "course_year"]]);

    cy.visitYear();
    cy.get("h1").should("contain", "Test Course year");
    cy.contains("a.govuk-button", "Edit year content").should("not.exist");
  });

  it("should not allow to edit module title", () => {
    cy.appFactories([["create", "course_module"]]);

    cy.visitModule();
    cy.get("h1").should("contain", "Test Course module");
    cy.contains("a.govuk-button", "Edit module content").should("not.exist");
  });

  it("should not allow to edit lesson title", () => {
    cy.appFactories([["create", "course_lesson"]]);

    cy.visitLesson();
    cy.get("h1").should("contain", "Test Course lesson");
    cy.contains("a.govuk-button", "Edit lesson").should("not.exist");
  });

  it("should not allow to edit lesson part title", () => {
    cy.appFactories([["create", "course_lesson", "with_lesson_part"]]);

    cy.visitLesson();
    cy.get("h2").should("contain", "Title");
    cy.contains("a.govuk-button", "Edit lesson content").should("not.exist");
  });

  it("should display lesson progress", () => {
    cy.appFactories([["create", "course_lesson", "with_lesson_part"]]);

    cy.visitModule();
    cy.contains("strong.govuk-tag", "not started").should("exist");

    cy.visitLesson();
    cy.visitModule();
    cy.contains("strong.govuk-tag", "in progress").should("exist");

    cy.visitLesson();
    cy.get('[type="checkbox"]').check();
    cy.get("form").submit();
    cy.contains("strong.govuk-tag", "complete").should("exist");
  });
});
