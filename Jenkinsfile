pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        sh'''
          #!/bin/bash
          docker build -t vim-plugin-template/test-container .
        '''
      }
    }

    stage('Build') {
      steps {
        sh'''
          #!/bin/bash
          docker run -a stderr -e VADER_OUTPUT_FILE=/dev/stderr --rm vim-plugin-template/test-container /vim-build/bin/vim-v8.0.0027 "+Vader! test/*.vader" 2>&1 || exit_code=$?

          exit "$exit_code"
        '''
      }
    }
  }
}
