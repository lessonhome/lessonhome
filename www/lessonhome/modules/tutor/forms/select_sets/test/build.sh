#!/bin/bash
jade -c < ../main.jade > main.jade.js
sass ../select-sets.sass > ./select-sets.css
coffee -c  -o ./ ../main.coffee
