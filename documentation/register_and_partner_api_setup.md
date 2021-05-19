## Register and Partner API setup

We use an api on R&P that's hidden behind authentication. If you need to work on some features in it, you will need a token.

### Developing against a local R&P

1. Get R&P working locally.
2. Run `db:seed` command in it.
3. Run R&P on port 3001: `rails s -p 3001`.
4. Go to E&L project (this repository).
5. Add a dev R&P token to your `.env` - ask one of the devs to send you one.
6. Run E&L, and things should just work.

### Developing against a deployed R&P

1. Change `REGISTER_AND_PARTNER_URL` in your env to the actual url.
2. Add a R&P token to your `.env` - it will need to exist in that environment. For deployed development, you can ask another dev. For anything else you might need to create your own.

### Generating new R&P token

Follow the steps in R&P repo - most likely it will involve using a rails console. Tokens in there are called `EngageAndLearnApiToken`.
Make sure you note the unhashed token - it won't be available after you generate it. 
