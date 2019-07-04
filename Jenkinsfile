pipeline {
    agent { label 'master'}
    stages {
        stage('Checkout SCM') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/hmtrung/docker-selenium-robotframework.git']]])
            }
        }
        stage('Cleanup existed Grid') {
            steps {
                sh label: '', returnStatus: true, script: 'docker stop chrome-node'
                sh label: '', returnStatus: true, script: 'docker stop firefox-node'
                sh label: '', returnStatus: true, script: 'docker stop selenium-hub'
                sh label: '', returnStatus: true, script: 'docker network rm grid'
            }
        }
        stage('Setup Grid') {
            steps {
                sh label: '', script: '''docker network create grid
docker run -d --rm -p 4444:4444 --net grid --name selenium-hub -v ${PWD}:/opt/demo hmtrung/selenium-hub:3.141.59-radium
docker run -d --rm -p 5900:5900 --net grid --name chrome-node -e HUB_HOST=selenium-hub -v /dev/shm:/dev/shm selenium/node-chrome-debug:3.141.59-radium
docker run -d --rm -p 5901:5900 --net grid --name firefox-node -e HUB_HOST=selenium-hub -v /dev/shm:/dev/shm selenium/node-firefox-debug:3.141.59-radium
'''
            }
        }
        stage('Wait for Grid') {
            steps {
                sh label: '', script: 'sh wait-for-grid.sh'
            }
        }
        stage('Run tests') {
            parallel {
                stage('Run test on Chrome') {
                    steps {
                        sh label: '', script: 'docker exec -i -w /opt/demo/WebDemo selenium-hub robot --variable SERVER:192.168.89.193:7272 --variable BROWSER:chrome --variable NODE_URL:http://chrome-node:5555/wd/hub --variable CAPABILITIES:browserName:chrome,platform:LINUX --outputdir chrome_results login_tests'
                    }
                }
                stage('Run test on Firefox') {
                    steps {
                        sh label: '', script: 'docker exec -i -w /opt/demo/WebDemo selenium-hub robot --variable SERVER:192.168.89.193:7272 --variable BROWSER:firefox --variable NODE_URL:http://firefox-node:5555/wd/hub --variable CAPABILITIES:browserName:firefox,platform:LINUX --outputdir firefox_results login_tests'
                    }
                }
            }
        }
        stage('Combine results') {
            steps {
                sh label: '', script: 'docker exec -i -w /opt/demo/WebDemo selenium-hub rebot --output output.xml --outputdir results firefox_results/output.xml chrome_results/output.xml'    
            }
        }
        stage('Publish Robot Framework Results') {
            steps {
                step([$class: 'RobotPublisher',
                    outputPath: 'WebDemo/results',
                    passThreshold: 100,
                    unstableThreshold: 0,
                    otherFiles: ""])
            }
        }
        stage('Cleanup Grid') {
            steps {
                sh 'docker stop chrome-node'
                sh 'docker stop firefox-node'
                sh 'docker stop selenium-hub'
                sh 'docker network rm grid'
            }
        }
    }
}
