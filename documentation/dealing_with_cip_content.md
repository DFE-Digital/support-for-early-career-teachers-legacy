## Dealing with cip content

### Seeding cip content / anything else

1. Make sure you are ok with the content in seed files to be created in your db.
2. Run `cf login -a api.london.cloud.service.gov.uk -u USERNAME`, `USERNAME` is your personal GOV.UK PaaS account email address
3. Run `cf run-task ecf-engage-and-learn-dev "cd .. && cd app && ../usr/local/bundle/bin/bundle exec rails db:seed"` to start the task.

### Updating cip content from changes on an app

1. Download the file to your machine - log in as admin, go to cip page, press the button to download content.
1. Copy the file or its contents into `cip_seed.rb`.
1. Add an option `on_duplicate_key_ignore` to CIPs, think carefully which ones from seed dump are needed.
1. Commit, push, run seeding job from above in the deployed app.
