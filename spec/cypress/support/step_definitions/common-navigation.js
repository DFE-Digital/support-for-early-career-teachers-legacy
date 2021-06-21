import { Given, When, Then } from "cypress-cucumber-preprocessor/steps";

Given("scenario {string} has been ran", (scenario) => cy.appScenario(scenario));

const pagePaths = {
  cookie: "/cookies",
  start: "/",
  dashboard: "/dashboard",
  "edit preferred name": "/preferred-name/edit",
  "sign in": "/users/sign_in",
  "core induction programme index": "/core-induction-programmes",
  "core induction programme show": "/core-induction-programmes/:id",
  "core induction programme year": "/years/:id",
  "core induction programme lesson new":
    "/core-induction-programmes/:id/create-lesson",
  "core induction programme year edit": "/years/:id/edit",
  "core induction programme module": "/modules/:id",
  "core induction programme module edit": "/modules/:id/edit",
  "core induction programme lesson": "/lessons/:id",
  "core induction programme lesson edit": "/lessons/:id/edit",
  "core induction programme lesson part": "/lesson_parts/:id",
  "core induction programme mentor materials": "/mentor-materials",
  "core induction programme mentor material new": "/mentor-materials/new",
  "core induction programme mentor material": "/mentor-materials/:id",
  "core induction programme mentor material part": "/mentor-material-parts/:id",
  "core induction programme mentor material edit": "/mentor-materials/:id/edit",
  "training and support": "/training-and-support",
};

Given("I am on {string} page", (page) => {
  const path = pagePaths[page];
  cy.visit(path);
});

Given("I am on {string} page with id {string}", (page, id) => {
  const path = pagePaths[page].replace(":id", id);
  cy.visit(path);
});

Given("I am on {string} page without JavaScript", (page) => {
  const path = pagePaths[page];
  cy.visit(`${path}?nojs=nojs`);
});

When("I navigate to {string} page", (page) => {
  const path = pagePaths[page];
  cy.visit(path);
});

const assertOnPage = (page) => {
  const path = pagePaths[page];

  if (!path) {
    throw new Error(`Path not found for ${page}`);
  }

  if (path.includes(":id")) {
    const pathRegex = new RegExp(
      path.replace(/\//g, "\\/").replace(":id", "[^/]+")
    );
    cy.location("pathname").should("match", pathRegex);
  } else {
    cy.location("pathname").should("equal", path);
  }
};

Then("I should be on {string} page", (page) => {
  assertOnPage(page);
});

Then("I should have been redirected to {string} page", (page) => {
  assertOnPage(page);
});
