pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_IN_AUTOMATION      = '1'
    }
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

    stages {
        stage('Get files from Git') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git "https://github.com/elchananmizrachi/checkmarx.git"
                        }
                    }
                }
            }
        
        
        
        stage('Plan') {
            steps {
                script {
                    currentBuild.displayName = params.version
                }
                sh  'terraform init -input=false'
                sh "terraform plan -input=false -out tfplan"
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
    }
}
