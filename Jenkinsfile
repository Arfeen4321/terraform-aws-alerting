pipeline {
    agent any

    parameters {
        choice(name: 'ALERT_TYPE', choices: ['ALL', 'CPU', 'MEMORY', 'DISK', 'STATUS_CHECK'], description: '1. Type of Alert to configure')
        string(name: 'THRESHOLD', defaultValue: '75', description: '2. Threshold percentage limit (e.g. 75, 80)')
        string(name: 'ALERT_EMAIL', defaultValue: 'mohdarfeen890@gmail.com', description: '3. Email address to receive alert notifications')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: '4. Terraform Action to perform')
        choice(name: 'ENVIRONMENT', choices: ['prod', 'staging', 'dev'], description: '5. Environment name')
        string(name: 'INSTANCE_ID', defaultValue: '', description: '6. Target EC2 Instance ID (e.g. i-002c7023f767fc78a)')
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_VAR_instance_id = "${params.INSTANCE_ID}"
        TF_VAR_alert_type  = "${params.ALERT_TYPE}"
        TF_VAR_alert_email = "${params.ALERT_EMAIL}"
        TF_VAR_threshold   = "${params.THRESHOLD}"
        TF_VAR_environment = "${params.ENVIRONMENT}"
    }

    stages {
        stage('Validate Inputs') {
            steps {
                script {
                    if (!params.INSTANCE_ID) {
                        error("❌ ERROR: INSTANCE_ID cannot be empty! Please provide an EC2 Instance ID.")
                    }
                    echo """
                    ======================================================
                    🚀 TRIGGERING INFRA ALERT PIPELINE WITH PARAMETERS:
                    - Alert Type    : ${params.ALERT_TYPE}
                    - Threshold     : ${params.THRESHOLD}%
                    - Email         : ${params.ALERT_EMAIL}
                    - Action        : ${params.ACTION}
                    - Environment   : ${params.ENVIRONMENT}
                    - EC2 Instance  : ${params.INSTANCE_ID}
                    ======================================================
                    """
                }
            }
        }

        stage('1. Terraform Init') {
            steps {
                echo "=== Initializing Terraform ==="
                sh 'terraform init -upgrade'
            }
        }

        stage('2. Terraform Plan') {
            steps {
                echo "=== Generating Plan for Alert Type: ${params.ALERT_TYPE} ==="
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('3. Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                echo "=== Applying to AWS CloudWatch & SNS ==="
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
