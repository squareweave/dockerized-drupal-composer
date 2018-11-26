#!/bin/bash

# This script should not be run directly. See the Makefile for more information. 
set -e

variants=( ". node" )

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )|grep -v templates
fi
versions=( "${versions[@]%/}" )

for version in "${versions[@]}"; do
    for variant in $variants
    do
        DIRECTORY=/build/$version/$variant

        mkdir -pv $DIRECTORY
        cp -av templates/app \
               templates/php-config \
               templates/ssmtp \
               $DIRECTORY/

        cat templates/Dockerfile > $DIRECTORY/Dockerfile

        target="php:7.2-apache"
        if [[ $variant =~ fpm.* ]]
        then
            target="php:7.2-fpm"
        else
            cp templates/apache2*.conf $DIRECTORY/
            {
                echo ""
                echo ""
                cat templates/Dockerfile.apache
            } >> $DIRECTORY/Dockerfile
        fi

        if [[ $variant =~ .*node ]]
        then
            {
                echo ""
                echo ""
                cat templates/Dockerfile.node
            } >> $DIRECTORY/Dockerfile
        fi


        (
            set -x
            sed -ri '
                s!%%BASE_LIBRARY%%!'"$target"'!;
            ' "$DIRECTORY/Dockerfile"
        )

        (
            set -x
            sed -ri '
                s!%%DRUPAL_VERSION%%!'"$version"'!;
            ' "$DIRECTORY/app/composer.json"
        )
    done

done
