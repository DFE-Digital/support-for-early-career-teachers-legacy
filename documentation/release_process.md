## Release process

There are two things we release: code and content.

### Code releases

To get code into dev environment, make a new branch, commit your changes, open a PR, get it approved and merge it.

To get code into staging environment, get it to dev, and then dispatch an action from 
[this workflow](https://github.com/DFE-Digital/ecf-engage-and-learn/actions/workflows/deploy_to_staging.yml).
Provide it with a **new** version in form of `vx.y.z`, say `v0.0.32`. You can check the existing versions on 
[the releases page](https://github.com/DFE-Digital/ecf-engage-and-learn/releases).

To get code into production environment, get it to staging, and then dispatch an action from 
[this workflow](https://github.com/DFE-Digital/ecf-engage-and-learn/actions/workflows/deploy_to_production.yml).
Provide it with an **existing** version. You can check the existing versions on 
[the releases page](https://github.com/DFE-Digital/ecf-engage-and-learn/releases).

### Content releases

Generally speaking, we manage our content in the staging environment, and that is our source of truth for it.
This lets non-technical people edit it in multiple places at once.

To get content into dev environment, take a snapshot of content on staging - 
[download export](https://staging-support-ects.education.gov.uk/providers) button.
1. Copy the file or its contents into `cip_seed_dump.rb` - that is our file for raw content.
1. Copy the file or its contents into `cip_seed.rb` - that is our seed file.
1. Add an option `on_duplicate_key_ignore` to each model import - [this file](/lib/tasks/cip_seed_dump.rake) has a useful command in it.
1. Commit, push, get a PR, merge it

The changes will be present when the dev app deploys.

You should not really need to get that content on staging, since the content should be there already.

To get content into production environment, you need to get the seed file deployed to production - look at Code releases.
Once you have it there, do the following:

1. Run `cf login -a api.london.cloud.service.gov.uk -u USERNAME`, `USERNAME` is your personal GOV.UK PaaS account email address
2. Run `cf ssh ecf-engage-and-learn-production`
3. `cd ..`
4. `cd /app`
5. `/usr/local/bin/bundle exec rails db:seed"` to seed the database.

Once it completes, the content should be updated.

This will not delete any objects - just create or update them. 
If you need to delete something, you will need to use Rails console.
