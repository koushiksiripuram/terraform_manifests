pipeline {

    agent any

    environment {

        EC2_HOST = "65.1.79.51"
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
        stage('Wait For EC2') {

    steps {

        sh 'sleep 60'

    }
}
        stage('Get EC2 DNS') {

            steps {

                script {

                    // EC2_HOST = sh(
                    //     script: '''
                    //     cd terraform
                    //     terraform output -raw elastic_ip
                    //     ''',
                    //     returnStdout: true
                    // ).trim()

                    echo "EC2 HOST: ${EC2_HOST}"
                }
            }
        }
        stage('Deploy To EC2') {

    steps {

        sh """
chmod 400 /tmp/master.pem

ssh -o StrictHostKeyChecking=no \
-i /tmp/master.pem ubuntu@${EC2_HOST} << EOF

rm -rf app

git clone https://github.com/koushiksiripuram/terraform_manifests.git app

cd app/scripts

chmod +x install.sh

./install.sh

sudo systemctl enable docker

sudo systemctl start docker

cd ../docker

sudo docker compose pull

sudo docker compose up -d

// fi

EOF
"""
    }
}
        
    }
}