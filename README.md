![Tests](https://github.com/DFE-Digital/ecf-engage-and-learn/workflows/Test/badge.svg)

# Engage and Learn

## Prerequisites

- Ruby 2.7.2
- PostgreSQL
- NodeJS 14.16.0
- Yarn 1.12.x
- Docker

## Setting up the app in development

### Without docker

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
3. Create an `.env` file - copy `.env.template`. Set your database password and user in the `.env` file
4. Run `mkdir log && touch log/mail.log`
5. Run `bin/rails db:setup` to set up the database development and test schemas, and seed with test data
6. Run `bundle exec rails server` to launch the app on http://localhost:3000
7. Run `./bin/webpack-dev-server` in a separate shell for faster compilation of assets

### With docker

There is a separate Dockerfile for local development. It isn't (currently) very
widely used - if it doesn't work, make sure any recently changes to Dockerfile
have been applied to Dockerfile.dev where appropriate.

1. Create `.env` file - copy `.env.template`. Set your database password and user from the docker-compose file in the `.env` file
2. Run `docker-compose build` to build the web image
3. Run `docker-compose run --rm web bundle exec rake db:setup` to setup the database
4. Run `docker-compose up` to start the service

It should be possible to run just the database from docker, if you want to.
Check docker-compose file for username and password to put in your `.env` file.

If you want to seed the database you can either run `db:drop` and `db:setup` tasks with your preferred method,
or `db:seed`.

### Govuk Notify

Register on [GOV.UK Notify](https://www.notifications.service.gov.uk). 
Ask someone from the team to add you to our service.
Generate an api key for yourself and set it in your `.env` file.

### Register and Partner API

We integrate with https://github.com/DFE-Digital/early-careers-framework, which we call Register and Partner - repository name is a bit of an old artifact.

Check out the [specific docs](/documentation/register_and_partner_api_setup.md) for integration details.

### Git hooks

Run `git config core.hooksPath .githooks` to use the included git hooks. They run linting on commit and check for AWS secrets.

## Tests

### Running specs, linter(without auto correct) and annotate models and serializers

```
bundle exec rake
```

### Running specs

```
bundle exec rspec
```

### End to end tests

To set up:

```
RAILS_ENV=test bin/rake db:create db:schema:load
```

Then in separate windows:

```
bin/rails server -e test -p 5017
```

```
yarn cypress:open
```


## Dev ops

### Release process

Check out the [specific docs](/documentation/.md).

### Review apps

Review apps are automatically created when a PR is opened. A link to the app will be posted on the review.

### Terraform

Check out the [specific docs](/documentation/terraform.md).

### Debugging in PaaS

Check out the [specific docs](/documentation/debugging_in_govpaas.md).

### Secrets used in Rails

Check out the [specific docs](/documentation/credentials.md).

## Application functions

### CIP content

We have a lot of content in database. Its format is markdown, we display it using govspeak gem. 
If you need to change it permanently, check out the [specific docs](/documentation/release_process.md).

### Test displaying markdown with govspeak

Run your app locally. Go to http://localhost:3000/govspeak_test. Enter your markdown into the text area,
click "See preview". Voila!

### Updating CIP images

Check out the [specific docs](/documentation/updating_images_in_cip_content.md).

### Getting url from a uid
Sometimes you want to edit some content in staging, and you know the id of the object, but not the pretty path. This is how you get that path.

For a course lesson part:

```
rails c
> include PathHelper
> include Rails.application.routes.url_helpers
> lesson_part_path(CourseLessonPart.find("0961d48a-ed6c-4e2f-ac0e-960a5ebcb6f7"))
```

It should be reasonably easy to generalise that for mentor materials part.

### Sending user invites

Run the job `invites[email_1@example.com email_2@example.com]`. Emails need to match users. 
