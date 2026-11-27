
pipeline {
    agent any

    options {
        timestamps()
    }
    environment {
        PATH = "/var/lib/jenkins/bin:${env.PATH}"
        DOCKER_HOST = "unix:///run/user/119/docker.sock"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv .venv
                    .venv/bin/python -m pip install --upgrade pip
                    .venv/bin/pip install -r requirements.txt
                    .venv/bin/pip install bandit pip-audit
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '.venv/bin/python -m pytest -v'
            }
        }

        stage('Bandit Security Scan') {
            steps {
                sh '''
                    mkdir -p security/reports
                    .venv/bin/bandit -r app/ -f json \
                        -o security/reports/bandit-report.json || true
                '''
            }
        }

        stage('Dependency Scan') {
            steps {
                sh '''
                    .venv/bin/pip-audit -f json \
                        -o security/reports/dependency-report.json || true
                '''
            }
        }

        stage('Secret Scan') {
            steps {
                sh '''
                    gitleaks dir . \
                        --report-format json \
                        --report-path security/reports/gitleaks-report.json \
                        --exit-code 0
                '''
            }
        }
        stage('Docker Build') {
            steps {
               sh '''
                   docker version
		   echo "BUILD_NUMBER=$BUILD_NUMBER"
                   docker build -t cloudsecurity-app:${BUILD_NUMBER} .
                   docker images cloudsecurity-app
                '''
            }
	}
    }
    post {
        always {
            archiveArtifacts artifacts: 'security/reports/*.json',
                             allowEmptyArchive: true
        }
    }
}
