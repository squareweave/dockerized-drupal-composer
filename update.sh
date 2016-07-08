#!/bin/bash

set -e

variants=( ". fpm node fpm/node" )

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )|grep -v templates
fi
versions=( "${versions[@]%/}" )

for version in "${versions[@]}"; do
    for variant in $variants
    do
        mkdir -pv $version/$variant
        cp -av templates/app \
               $version/$variant/

        cat templates/Dockerfile > $version/$variant/Dockerfile

        target="php:7.0-apache"
        if [[ $variant =~ fpm.* ]]
        then
            target="php:7.0-fpm"
        else
            cp templates/apache2.conf $version/$variant/
            {
                echo ""
                echo ""
                cat templates/Dockerfile.apache
            } >> $version/$variant/Dockerfile
        fi

        if [[ $variant =~ .*node ]]
        then
            {
                echo ""
                echo ""
                cat templates/Dockerfile.node
            } >> $version/$variant/Dockerfile
        fi


        (
            set -x
            sed -ri '
                s!%%BASE_LIBRARY%%!'"$target"'!;
            ' "$version/$variant/Dockerfile"
        )

    done

done
