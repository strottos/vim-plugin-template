pipeline {
  agent any

  triggers {
    pollSCM('H/5 * * * *')
  }

  stages {
    stage('Build') {
      steps {
        sh'''
          #!/bin/bash
          docker build -t vim-plugin-template/test-container .
        '''
      }
    }

    stage('Test') {
      steps {
        sh'''
          #!/bin/bash
          docker run -a stderr -e VADER_OUTPUT_FILE=/dev/stderr --rm vim-plugin-template/test-container /vim-build/bin/vim-v8.0.0027 "+Vader! test/*.vader" 2>&1
        '''
      }
    }
  }
}
