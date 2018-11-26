This repository is used as the upstream Drupal repository for the YVW-Drupal-App project. 

# Updating to a new version of Drupal

## Quick process

1. Check out the `template` branch of this repo.
2. Add the new version to the `VERSIONS` list in the `Makefile`. Multiple 
   versions are supported and are space-separated.
3. Run `make` to run all the make commands to clean, generate and commit 
   the various combinations of Drupal versions and environments. Updated 
   build directories will be pushed to the remote master branch. Note 
   that no actual docker builds have taken place yet. We recommend testing
   the changes before committing and pushing them. 

## Manual process (recommended) 

If you would just like to test a docker build before pushing it, run steps
one and two above, then:

1. Run `make clean generate` to generate the versioned build directories 
   based on the templates
2. Run `docker build -t squareweave/dockerized-drupal-composer:{Drupal version}-node build/{Drupal version}/node` 
   to actually build the image
3. Rebuild your project Drupal container, after updating the `FROM` line in 
   the Dockerfile. 
4. If you are happy with the results, commit and push the changes with 
   `make commit`. 

# Updating PHP/Apache

Review the Drupal PHP requirements documentation at https://www.drupal.org/docs/8/system-requirements/php-requirements 
to check which PHP versions are supported. Update the `target` env in the 
`update.sh` script, and then follow the steps above to build a new image. 
