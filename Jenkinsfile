pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any

    stages {
        stage('Checkout') {
            steps {
                dir("terraform") {
                    git "https://github.com/haripujari/AWS-Terraform-Jenkins.git"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("terraform") {
                    sh '''
                        echo "Initializing Terraform..."
                        terraform init

                        echo "Generating Terraform plan..."
                        terraform plan -out=tfplan

                        echo "Showing Terraform plan..."
                        terraform show -no-color tfplan > tfplan.txt
                    '''
                }
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
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the Terraform plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("terraform") {
                    sh '''
                        echo "Applying Terraform plan..."
                        terraform apply -input=false tfplan
                    '''
                }
            }
        }
    }
}
