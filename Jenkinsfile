pipeline {
    agent any
 
    environment {
        AWS_REGION     = 'us-east-2'
        PATH           = "${env.HOME}/bin:${env.PATH}"
        TF_WORKING_DIR = 'module' // hidden; not shown in UI
    }
 
    parameters {
        choice(name: 'TF_ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform action to perform')
        choice(name: 'ENVIRONMENT', choices: ['dev', 'qa', 'staging', 'prod'], description: 'Choose deployment environment')
    }
 
    options {
        timestamps()
        disableConcurrentBuilds()
    }
 
    stages {
        stage('Build Metadata') {
            steps {
                echo "\033[1;34mBUILD INFO:\033[0m"
                echo "Build Number: ${env.BUILD_NUMBER}"
                echo "Build URL: ${env.BUILD_URL}"
                echo "Environment: ${params.ENVIRONMENT}"
                echo "Action: ${params.TF_ACTION}"
            }
        }
 
        stage('Checkout Project') {
            steps {
                echo "\033[1;32mChecking out the repository...\033[0m"
                git branch: 'main', credentialsId: 'git-sidhu', url: 'https://github.com/sidhu8431/test-eks-saru.git'
            }
        }
 
        stage('Install Latest Terraform') {
            steps {
                echo "\033[1;32mFetching and installing latest Terraform version...\033[0m"
                sh '''
                    mkdir -p $HOME/bin
                    export PATH=$HOME/bin:$PATH
 
                    echo "Getting latest Terraform version..."
                    LATEST_VERSION=$(curl -s https://releases.hashicorp.com/terraform/ | grep -oP 'terraform/\\K[0-9\\.]+(?=/")' | head -1)
                    echo "Latest version is $LATEST_VERSION"
 
                    if ! terraform -version | grep -q "$LATEST_VERSION"; then
                        echo "Installing Terraform $LATEST_VERSION..."
                        curl -s -o terraform.zip https://releases.hashicorp.com/terraform/${LATEST_VERSION}/terraform_${LATEST_VERSION}_linux_amd64.zip
                        unzip -o terraform.zip
                        mv -f terraform $HOME/bin/
                        rm -f terraform.zip
                    else
                        echo "Terraform $LATEST_VERSION already installed."
                    fi
 
                    terraform version
                '''
            }
        }
 
        stage('Terraform Init & Plan') {
            when {
                anyOf {
                    expression { return params.TF_ACTION == 'plan' }
                    expression { return params.TF_ACTION == 'apply' }
                    expression { return params.TF_ACTION == 'destroy' }
                }
            }
            environment {
                AWS_DEFAULT_REGION = "${AWS_REGION}"
            }
            steps {
                withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'sidhu_aws_access' ]]) {
                    dir("${env.TF_WORKING_DIR}") {
                        echo "\033[1;36mInitializing Terraform...\033[0m"
                        sh 'terraform init -input=false'
 
                        echo "\033[1;36mValidating Terraform...\033[0m"
                        sh 'terraform validate'
 
                        echo "\033[1;36mPlanning Terraform...\033[0m"
                        sh "terraform plan -var='region=${AWS_REGION}' -var='environment=${params.ENVIRONMENT}'"
                    }
                }
            }
        }
 
        stage('Apply Terraform') {
            when {
                expression { return params.TF_ACTION == 'apply' }
            }
            steps {
                withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'sidhu_aws_access' ]]) {
                    dir("${env.TF_WORKING_DIR}") {
                        echo "\033[1;33mApplying Terraform...\033[0m"
                        sh "terraform apply -auto-approve -var='region=${AWS_REGION}' -var='environment=${params.ENVIRONMENT}'"
                    }
                }
            }
        }
 
        stage('Destroy Terraform') {
            when {
                expression { return params.TF_ACTION == 'destroy' }
            }
            steps {
                input message: "Are you sure you want to destroy infrastructure in '${params.ENVIRONMENT}'?", ok: "Yes, destroy it"
                withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'sidhu_aws_access' ]]) {
                    dir("${env.TF_WORKING_DIR}") {
                        echo "\033[1;31mDestroying infrastructure...\033[0m"
                        sh "terraform destroy -auto-approve -var='region=${AWS_REGION}' -var='environment=${params.ENVIRONMENT}'"
                    }
                }
            }
        }
    }
 
    post {
        success {
            echo "\033[1;32mPipeline executed successfully!\033[0m"
        }
        failure {
            echo "\033[1;31mPipeline failed. Please check the logs.\033[0m"
        }
        always {
            echo "\033[1;34mCleanup (if any) completed.\033[0m"
        }
    }
}
