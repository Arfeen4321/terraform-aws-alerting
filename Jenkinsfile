cat << 'EOF' > Jenkinsfile
pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Terraform Action to perform')
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('1. Terraform Init') {
            steps {
                echo "=== Initializing Terraform and Modules ==="
                sh 'terraform init'
            }
        }

        stage('2. Terraform Plan') {
            steps {
                echo "=== Generating Execution Plan ==="
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('3. Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                echo "=== Applying Infrastructure Changes to AWS ==="
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('4. Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                echo "=== Destroying Infrastructure ==="
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}
EOF
