#!/bin/bash

set -e

variants=( ". fpm node fpm/node" )
composerSetupShaKey=92102166af5abdb03f49ce52a40591073a7b859a86e8ff13338cf7db58a19f7844fbc0bb79b2773bf30791e935dbd938

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )|grep -v templates
fi
versions=( "${versions[@]%/}" )

for version in "${versions[@]}"; do
    for variant in $variants
    do
        mkdir -pv $version/$variant
        cp -av templates/sites templates/composer.json templates/composer.lock templates/complete-install.sh $version/$variant/

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
                s!%%COMPOSER_SETUP_SHA384%%!'"$composerSetupShaKey"'!;
            ' "$version/$variant/Dockerfile"
        )

    done

done
