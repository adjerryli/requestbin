#!/usr/bin/env groovy
def projectName = "requestbin"
def projectDir = "src/github.com/AppDirect/${projectName}"

node('build') {
  stage('Checkout sources') {
    checkoutTo projectDir
  }

  stage('Read version') {
    env.VERSION = readVersion(projectDir)
  }

  stage('Build application') {
    dir("${env.WORKSPACE}/${projectDir}") {
      ansiColor('xterm') {
        sh 'docker build --no-cache .'
      }
    }
  }

  stage('Docker build') {
    echo "Building image with TAG: ${VERSION}"
    dockerBuilder "${env.WORKSPACE}/${projectDir}", projectName, VERSION
  }
}