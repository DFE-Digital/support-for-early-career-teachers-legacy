describe("Admin user interaction with Core Induction Programme", () => {
  beforeEach(() => {
    cy.login("admin");
  });

  it("should show a download export button", () => {
    cy.visit("/core-induction-programme");
    cy.get("a.govuk-button").contains("Download export");
  });

  it("should allow to edit year title", () => {
    cy.appFactories([["create", "course_year"]]);

    cy.visitYear();
    cy.get("a.govuk-button").contains("Edit year content").click();

    cy.get("h1").should("contain", "Content change preview");
    cy.get("input[name='title']").type("New title");
    cy.contains("See preview").click();

    cy.get("h1").should("contain", "Content change preview");
    cy.visitYear();

    cy.get("a.govuk-button").contains("Edit year content").click();
    cy.get("input[name='title']").type("New title");
    cy.contains("Save changes").click();

    cy.get("h1").should("contain", "New title");
  });

  it("should allow to edit module title", () => {
    cy.appFactories([["create", "course_module"]]);

    cy.visitModule();
    cy.get("a.govuk-button").contains("Edit module content").click();

    cy.get("h1").should("contain", "Content change preview");
    cy.get("input[name='title']").type("New title");
    cy.contains("See preview").click();

    cy.get("h1").should("contain", "Content change preview");
    cy.visitModule();

    cy.get("a.govuk-button").contains("Edit module content").click();
    cy.get("input[name='title']").type("New title");
    cy.contains("Save changes").click();

    cy.get("h1").should("contain", "New title");
  });

  it("should allow to edit lesson title", () => {
    cy.appFactories([["create", "course_lesson"]]);

    cy.visitLesson();
    cy.get("a.govuk-button").contains("Edit lesson").click();

    cy.get("h1").should("contain", "Edit lesson");
    cy.get("input[name='title']").type("New title");
    cy.contains("Save changes").click();

    cy.get("h1").should("contain", "New title");
  });

  it("should allow to edit lesson part title", () => {
    cy.appFactories([["create", "course_lesson", "with_lesson_part"]]);

    cy.visitLesson();
    cy.get("h2").should("contain", "Title");
    cy.get("a.govuk-button").contains("Edit lesson content").click();

    cy.get("h1").should("contain", "Content change preview");
    cy.get("input[name='title']").type("New title");
    cy.contains("See preview").click();

    cy.get("h1").should("contain", "Content change preview");
    cy.visitLesson();
    cy.get("h2").should("contain", "Title");

    cy.get("a.govuk-button").contains("Edit lesson content").click();
    cy.get("input[name='title']").type("New title");
    cy.contains("Save changes").click();

    cy.get("h2").should("contain", "New title");
  });
});
