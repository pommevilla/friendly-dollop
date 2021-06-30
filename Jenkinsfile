#!groovy

properties([
    disableConcurrentBuilds(),
    buildDiscarder(logRotator(artifactDaysToKeepStr: '',
                              artifactNumToKeepStr: '',
                              daysToKeepStr: '',
                              numToKeepStr: '100')),
    parameters([string(name: 'RSTUDIO_VERSION_MAJOR',  defaultValue: '1', description: 'RStudio Major Version'),
                string(name: 'RSTUDIO_VERSION_MINOR',  defaultValue: '1', description: 'RStudio Minor Version'),
                string(name: 'RSTUDIO_VERSION_PATCH',  defaultValue: '0', description: 'RStudio Patch Version'),
                string(name: 'RSTUDIO_VERSION_SUFFIX', defaultValue: '0', description: 'RStudio Pro Suffix Version'),
                string(name: 'GIT_REVISION', defaultValue: 'main', description: 'Git revision to build'),
                string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Branch name to build'),
                string(name: 'SLACK_CHANNEL', defaultValue: '#ide-builds', description: 'Slack channel to publish build message.')
                ])
])

def jenkins_user_build_args() {
  def jenkins_uid = sh (script: 'id -u jenkins', returnStdout: true).trim()
  def jenkins_gid = sh (script: 'id -g jenkins', returnStdout: true).trim()
  return " --build-arg JENKINS_UID=${jenkins_uid} --build-arg JENKINS_GID=${jenkins_gid}"
}

def prepareWorkspace(){ // accessory to clean workspace and checkout
  step([$class: 'WsCleanup'])
  checkout scm
  sh 'git reset --hard && git clean -ffdx' // lifted from rstudio/connect
}

// make a nicer slack message
rstudioVersion = "${RSTUDIO_VERSION_MAJOR}.${RSTUDIO_VERSION_MINOR}.${RSTUDIO_VERSION_PATCH}-${RSTUDIO_VERSION_SUFFIX}"
messagePrefix = "Jenkins ${env.JOB_NAME} build: <${env.BUILD_URL}display/redirect|${env.BUILD_DISPLAY_NAME}>, version: ${rstudioVersion}"

try {
    timestamps {
        node('docker') {
          stage('prepare ws/container') {
            prepareWorkspace()
            container = pullBuildPush(image_name: 'jenkins/ide-docs', docker_context: 'docs/server/', build_args: jenkins_user_build_args())
          }
          stage('build docs') {
            container.inside() {
              def env = "RSTUDIO_VERSION_MAJOR=400 RSTUDIO_VERSION_MINOR=23 RSTUDIO_VERSION_PATCH=${RSTUDIO_VERSION_PATCH} RSTUDIO_VERSION_SUFFIX=${RSTUDIO_VERSION_SUFFIX}"
              sh "cd docs/server/ && ${env} cmake . && make && cd ../.."
            }
          }
          stage('upload docs') {
            sh "aws s3 sync docs/server/_site/ s3://docs.rstudio.com/ide/server-pro/${rstudioVersion}/"
            sh "aws s3 sync docs/server/_site/ s3://docs.rstudio.com/ide/server-pro/latest/"
          }
        }
        sendNotifications slack_channel: SLACK_CHANNEL, slack_message: "${messagePrefix} passed"
    }

} catch(err) {
   sendNotifications slack_channel: SLACK_CHANNEL, slack_message: "${messagePrefix} failed"
   error("failed: ${err}")
}
