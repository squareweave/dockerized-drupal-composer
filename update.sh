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
        cp -av templates/sites \
               templates/composer.json \
               templates/composer.lock \
               templates/set-permissions.sh \
               templates/autoload.php \
               $version/$variant/

        cat templates/Dockerfile > $version/$variant/Dockerfile

        if [[ $variant =~ .*node ]]
        then
            {
                echo ""
                echo ""
                cat templates/Dockerfile.node
            } >> $version/$variant/Dockerfile
        fi

        target="drupal:$version"
        if [[ $variant =~ fpm.* ]]
        then
            target="drupal:$version-fpm"
        fi


        (
            set -x
            sed -ri '
                s!%%BASE_LIBRARY%%!'"$target"'!;
            ' "$version/$variant/Dockerfile"
        )

    done

done
