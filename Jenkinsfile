pipeline {
    agent any

    environment {
        TF_VAR_region = 'us-east-2'
        AWS_DEFAULT_REGION = 'us-east-2'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('test-eks-saru/module') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('test-eks-saru/module') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('test-eks-saru/module') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval: Apply or Destroy') {
            when {
                branch 'main'
            }
            steps {
                script {
                    def userChoice = input(
                        message: 'Terraform Action Approval Required',
                        parameters: [
                            choice(name: 'Action', choices: ['Apply', 'Destroy', 'Abort'], description: 'Choose an action')
                        ]
                    )

                    if (userChoice == 'Apply') {
                        dir('test-eks-saru/module') {
                            sh 'terraform apply -auto-approve tfplan'
                        }
                    } else if (userChoice == 'Destroy') {
                        dir('test-eks-saru/module') {
                            sh 'terraform destroy -auto-approve'
                        }
                    } else {
                        echo "Pipeline aborted by user."
                        currentBuild.result = 'ABORTED'
                        error("Pipeline aborted by user.")
                    }
                }
            }
        }
    }

    post {
        always {
            dir('test-eks-saru/module') {
                sh 'rm -f tfplan || true'
            }
        }
        failure {
            echo 'Terraform operation failed.'
        }
        success {
            echo 'Terraform operation completed successfully.'
        }
        aborted {
            echo 'Pipeline was aborted.'
        }
    }
}
