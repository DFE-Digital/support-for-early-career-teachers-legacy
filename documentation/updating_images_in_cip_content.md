## Updating images in CIP content

### Getting the access key

1. Log in with `cf login`
2. Choose the `dev` space
3. Locate the right bucket - at the time of writing it's `dfe-ecf-engage-and-learn-cip-images`
4. Get the list of keys for the bucket: `cf service-keys <bucket-name>`.
5. Pick one key. `cf service-key <bucket-name> <key-name>` to get its details. At the time of writing `cf service-key dfe-ecf-engage-and-learn-cip-images cip-images-key` should do the trick.

The details from step 5 will be used to access the bucket and change its files.

### Making a local back-up of the bucket

1. Get aws cli: https://aws.amazon.com/cli/
2. `aws configure` - use the details from step 5 above.
3. Make a new empty directory, go into it. This will be your local backup.
4. Run `aws s3 sync s3://<aws-bucket-name> .` - the aws bucket name should be in the details you get in step 5. Currently `aws s3 sync s3://paas-s3-broker-prod-lon-ac28a7a5-2bc2-4d3b-8d16-a88eaef65526 .` works.
5. You should get a list of files in your local directory that match the files in the bucket.

### Changing the image to new version

1. Make a local back-up of the bucket by following the steps above. Don't go to next steps until you have done that.
2. In terminal, go to your local backup directory. 
3. Add the new image into your local backup directory.
4. Run `aws s3 sync . s3://<aws-bucket-name>` - similar to step 4 in making backup, but swapping s3 bucket and `.`
5. Run `aws s3 sync . s3://<aws-bucket-name> --acl public-read` to make the new image available in public internet.
6. Go to staging, log in as admin and edit the image url to point at your file. The url you need is `https://<aws-bucker-name>/<file-name>`.
7. If you want it on other environments, download the snapshot of content anc make a PR with it.
