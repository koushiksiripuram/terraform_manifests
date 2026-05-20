pipeline {

    agent any

    environment {

        EC2_HOST = ""
    }

    stages {

        
        stage('Terraform Init') {

            steps {

                dir('terraform') {

                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {

            steps {

                dir('terraform') {

                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Get EC2 DNS') {

            steps {

                script {

                    EC2_HOST = sh(
                        script: '''
                        cd terraform
                        terraform output -raw ec2_public_dns
                        ''',
                        returnStdout: true
                    ).trim()

                    echo "EC2 HOST: ${EC2_HOST}"
                }
            }
        }
        stage('Deploy To EC2') {

    steps {

        sshagent(['ec2-ssh-key']) {

            sh '''

            ssh -o StrictHostKeyChecking=no ubuntu@'$EC2_HOST' "

            rm -rf app

            git clone https://github.com/koushiksiripuram/terraform-manifests.git app

            cd app/scripts

            chmod +x install.sh

            ./install.sh

            sudo systemctl enable docker

            sudo systemctl start docker

            cd ../docker

            docker compose pull

            docker compose up -d

            "
            '''
        }
    }
}

        
    }
}