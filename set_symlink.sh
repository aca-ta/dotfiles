#!/bin/bash -euC

for dir in $(find ./etc/* -type d | sed -e 's/^\.\/etc\///g')
do
    mkdir -p ${HOME}/.$dir
done

for file in $(find ./etc/* ! -type d | sed -e 's/^\.\/etc\///g')
do
  rm -f ${HOME}/.${file}
  echo "$(pwd)/etc/${file} to ~/.${file}"
  ln -s $(pwd)/etc/${file} ~/.${file}
done
