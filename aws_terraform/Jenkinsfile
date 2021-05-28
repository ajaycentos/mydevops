pipeline{
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent any
    stages {
        stage('Git checkout')
        {
            steps{
                git changelog: false, poll: false, url: 'https://github.com/ajaycentos/mydevops.git'
            }
        }
        stage('Terraform init')
        {
            steps{
                sh 'terraform init'
            }
        }
        stage('Terraform apply')
        {
            steps{
                sh 'terraform apply --auto-approve'
            }
        }

        stage('terraform destroy approval') {
            steps {
                input 'Run terraform destroy?'
            }
        }
        stage('terraform destroy') {
            steps {
                sh 'terraform destroy -force'
            }
       }
    }
}