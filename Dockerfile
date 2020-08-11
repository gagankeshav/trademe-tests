FROM centos:7

RUN yum -y install gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel sqlite-devel \
 && curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - \
 && curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import - \
 && yum install which -y \
 && curl -L get.rvm.io | bash -s stable \
 && source /etc/profile.d/rvm.sh \
 && /bin/bash -l -c "rvm reload" \
 && /bin/bash -l -c "rvm requirements run" \
 && /bin/bash -l -c "rvm install 2.6" \
 && /bin/bash -l -c "rvm use 2.6 --default" \
 && /bin/bash -l -c "gem install selenium-webdriver" \
 && /bin/bash -l -c "gem install rest-client" \
 && /bin/bash -l -c "gem install colorize" \
 && /bin/bash -l -c "gem install yaml" \
 && /bin/bash -l -c "gem install json" \
 && /bin/bash -l -c "yum install -y wget unzip sudo" \
 && /bin/bash -l -c "wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm" \
 && /bin/bash -l -c "yum localinstall -y google-chrome-stable_current_x86_64.rpm" \
 && /bin/bash -l -c "sudo rm google-chrome-stable_current_x86_64.rpm" \
 && /bin/bash -l -c "wget https://chromedriver.storage.googleapis.com/84.0.4147.30/chromedriver_linux64.zip" \
 && /bin/bash -l -c "unzip chromedriver_linux64.zip" \
 && /bin/bash -l -c "sudo rm chromedriver_linux64.zip" \
 && /bin/bash -l -c "sudo mv chromedriver usr/local/bin/" \
 && /bin/bash -l -c "wget https://github.com/gagankeshav/trademe-tests/archive/master.zip" \
 && /bin/bash -l -c "unzip master.zip" \
 && /bin/bash -l -c "sudo rm master.zip" \
 && /bin/bash -l -c "ruby trademe-tests-master/tests/trademe_tests.rb chrome headless"