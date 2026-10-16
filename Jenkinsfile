pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Terraform Action')
        choice(name: 'ALERT_TYPE', choices: ['ALL', 'CPU', 'STATUS_CHECK'], description: 'Type of Alarm to configure')
        string(name: 'INSTANCE_ID', defaultValue: '', description: 'EC2 Instance ID to monitor (e.g. i-0abcd1234efgh)')
        string(name: 'ALERT_EMAIL', defaultValue: 'mohdarfeen890@gmail.com', description: 'Email address to receive alerts')
        string(name: 'CPU_THRESHOLD', defaultValue: '75', description: 'CPU Utilization Threshold %')
        choice(name: 'ENVIRONMENT', choices: ['prod', 'staging', 'dev'], description: 'Environment name')
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        // Map Jenkins UI parameters to Terraform TF_VAR_
        TF_VAR_instance_id   = "${params.INSTANCE_ID}"
        TF_VAR_alert_type    = "${params.ALERT_TYPE}"
        TF_VAR_alert_email   = "${params.ALERT_EMAIL}"
        TF_VAR_cpu_threshold = "${params.CPU_THRESHOLD}"
        TF_VAR_environment   = "${params.ENVIRONMENT}"
    }

    stages {
        stage('Validate Inputs') {
            steps {
                script {
                    if (!params.INSTANCE_ID) {
                        error("❌ ERROR: INSTANCE_ID cannot be empty! Please provide your EC2 Instance ID.")
                    }
                    echo "=== Configuring Alert: ${params.ALERT_TYPE} for Instance: ${params.INSTANCE_ID} ==="
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
                echo "=== Applying to AWS ==="
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
