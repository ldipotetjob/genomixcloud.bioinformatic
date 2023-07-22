
#!/bin/env bash

# PerlBrew 
wget -O - http://install.perlbrew.pl | bash
source ~/perl5/perlbrew/etc/bashrc
perlbrew init
perlbrew install-cpanm
make install