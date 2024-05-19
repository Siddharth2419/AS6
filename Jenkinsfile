pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('accesskey')
        AWS_SECRET_ACCESS_KEY = credentials('secretkey')
    }
    stages {
        stage('Installing Toomcat') {
            steps {
                script {
                    ansiblePlaybook(
                        playbook: 'install.yml',
                        inventory: 'aws_ec2.yaml'
                        
                    )
                }
            }
        }
    }
}
