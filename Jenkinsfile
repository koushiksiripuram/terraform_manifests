pipeline {

    agent any

    environment {

        EC2_HOST = "13.127.39.218"
    }

    stages {

        
        stage('Terraform Init') {

            steps {

                dir('terraform') {

                    sh 'terraform init'
                    sh 'terraform plan'
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

aws s3 cp s3://amzs3-dem-bucketcicd/certbot-conf.tar.gz .

scp -o StrictHostKeyChecking=no \
-i /tmp/master.pem \
certbot-conf.tar.gz ubuntu@${EC2_HOST}:/home/ubuntu/

ssh -o StrictHostKeyChecking=no \
-i /tmp/master.pem ubuntu@${EC2_HOST} << EOF

rm -rf app

git clone https://github.com/koushiksiripuram/terraform_manifests.git app

mv /home/ubuntu/certbot-conf.tar.gz /home/ubuntu/app/docker/

cd /home/ubuntu/app/docker

tar -xzvf certbot-conf.tar.gz

cd ../scripts

chmod +x install.sh

./install.sh

sudo systemctl enable docker

sudo systemctl start docker

cd ../docker

sudo docker compose down --remove-orphans

sudo docker network prune -f

sudo docker image rm koushiksiripuram/ghost-app:latest || true

sudo docker compose pull

sudo docker compose up -d --force-recreate

EOF
"""
    }
}
        
    }
}