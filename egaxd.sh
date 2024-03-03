#!/bin/bash

# Your other script commands here
mv $(which evmosd) /usr/local/bin/

alias_command="alias egaxd='evmosd'"

# Append the alias command to .bashrc
echo "$alias_command" >> ~/.bashrc

# Apply the changes
source ~/.bashrc
