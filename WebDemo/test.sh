#!/bin/bash
rm -rf results/*
robot --variable BROWSER:firefox --variable GRID_URL:http://172.26.0.4:5555/wd/hub --variable CAPABILITIES:browserName:firefox,platform:LINUX --outputdir firefox_results login_tests &
robot --variable BROWSER:chrome --variable GRID_URL:http://172.26.0.3:5555/wd/hub --variable CAPABILITIES:browserName:chrome,platform:LINUX --outputdir chrome_results login_tests &
wait
rebot --output output.xml firefox_results/output.xml chrome_results/output.xml
