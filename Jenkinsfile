pipeline {
    agent any // Specifies that the pipeline can run on any available agent (agent refers to the Jenkins worker node).

    stages {
        stage('Initialize Working Directory') { // This is the second stage, which initializes the Terraform working directory.
            steps {
                script {
                    // This step runs the 'terraform init' command to initialize the Terraform working directory.
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') { // This is the third stage, which performs a Terraform plan.
            steps {
                script {
                    // This step runs the 'terraform plan' command to generate an execution plan for Terraform.
                    sh 'terraform plan'
                }
            }
        }

      
    }
}
