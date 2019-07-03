#!/bin/bash
rm -rf results/*
robot --variable BROWSER:chrome --variable NODE_URL:http://${chrome_node}:5555/wd/hub --variable CAPABILITIES:browserName:chrome,platform:LINUX --outputdir firefox_results login_tests &
robot --variable BROWSER:ff --variable NODE_URL:http://${firefox_node}:5555/wd/hub --variable CAPABILITIES:browserName:firefox,platform:LINUX --outputdir chrome_results login_tests &
wait
rebot --output output.xml firefox_results/output.xml chrome_results/output.xml
