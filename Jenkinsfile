
pipeline {
    agent any

    options {
        timestamps()
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
    }

    post {
        always {
            archiveArtifacts artifacts: 'security/reports/*.json',
                             allowEmptyArchive: true
        }
    }
}
