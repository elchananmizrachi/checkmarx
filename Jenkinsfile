pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_IN_AUTOMATION      = '1'
    }

    stages {
        stage('Plan') {
            steps {
                script {
                    currentBuild.displayName = params.version
                }
                sh 'terraform init -input=false'
                sh "terraform plan -input=false -out tfplan"
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                        parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                sh "terraform apply -input=false tfplan"
            }
        }
    }
        stage('Deploy nginx docker') {
            steps {
                script {
                    currentBuild.displayName = params.version
                }
                sh 'kuubectl apply -f nginx-deployment.yaml'
                sh "terraform plan -input=false -out tfplan"
                sh 'kubectl expose deployment nginx-app --type=LoadBalancer --name=nginx-service'
            }
        }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
        }
    }
}
