#!/usr/bin/env bash

# Run this script to update .travis.yml. Commit and push against master.
curl https://raw.githubusercontent.com/mrueg/repoman-travis/master/.travis.yml > .travis.yml
