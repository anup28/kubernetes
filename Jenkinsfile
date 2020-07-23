#!groovy
node{
   stage('SCM Checkout'){
     git 'https://github.com/anup28/kubernetes'
   }

    parameters {
        choice(name: 'COMMAND', choices: 'plan\ncreate\ndestroy', description: 'Action to take regarding deployment.')

    }
    stages {

        stage('Configure') {
            steps {
                dir('.') {
                    sh 'bash platform.sh'
                }
            }
       }
    }
}
