pipeline {

    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')

    }


     environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

   agent  any
        options {
                timestamps ()
                ansiColor('xterm')
            }
    stages {
        
        stage('checkout') {
            steps {
                script{
                    dir ('terraform')
                    {
                    git branch: "main" , credentialsId: 'd0aba152-18d4-48b4-a074-5a84fe621254', url: "https://github.com/jignesh9202/terraform_with_s3_backend.git"
                    }
                  }
                }
            }

        stage('Plan') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                sh "terraform init -input=false"
                //sh "terraform workspace new ${environment}"
                sh 'terraform workspace select ${environment} || terraform workspace new ${environment}'
                sh "terraform plan -input=false -out tfplan "
                sh "terraform show -no-color tfplan > tfplan.txt"
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }

               not {
                    equals expected: true, actual: params.destroy
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
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }

            steps {
                sh "terraform apply -input=false tfplan"
            }
        }
        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroy
            }
        
        steps {
           sh 'terraform workspace select ${environment}'
           sh "terraform destroy --auto-approve"
        }
    }
    }
}