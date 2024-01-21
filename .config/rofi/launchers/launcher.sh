#!/bin/zsh

for style in ${pwd}**/style*(n)
do
  echo $style
  rofi \
    -show drun \
    -theme ${style}; 
done
