# trademe-tests
Repo for Automation of UI and API Mock Tests for Trademe Website

# Pre-requisites for execution via Docker:
- Docker desktop should be installed and running on the system
- Download and place the Dockerfile on the local system
- Open a powershell instance and navigate to the folder where Dockerfile has been placed

# Executing the tests
Execute below mentioned command in Powershell (Windows):
- docker build . -t <any tag name for the image e.g. qa_test> (e.g. docker build . -t qa_test)

# Pre-requisites:
1. Ruby should be installed on the system.
2. Chromedriver should be downloaded on the system and placed in one of the directories in the PATH variable [Follow steps outlined here: https://medium.com/@amdcaruso/selenium-webdriver-chromedriver-ruby-on-windows-1688132cbe3]
3. Following gems should be installed on the system:
    - selenium-webdriver
    - json
    - colorize
    - rest-client
    - yaml 

To install the gems outlined above, use following command for each gem installation:
- gem install <gem name> e.g. gem install selenium-webdriver

# Executing the tests
Clone the repo. on your local machine using below command from a command prompt:
- git clone https://github.com/gagankeshav/trademe-tests.git

Navigate to the tests folder and execute below command to execute the tests:
- ruby trademe_tests.rb chrome
