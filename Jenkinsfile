node {

    stage("Pull Docker File From GitHub") {

        git branch: 'main',
            url: 'https://github.com/worknabhishek/cloud.git'
    }

    stage('Build Docker Image') {

        sh 'docker build -t $JOB_NAME:v1.$BUILD_ID .'

        sh 'docker image tag $JOB_NAME:v1.$BUILD_ID worknabhishek/$JOB_NAME:v1.$BUILD_ID'

        sh 'docker image tag $JOB_NAME:v1.$BUILD_ID worknabhishek/$JOB_NAME:latest'
    }

    stage('Push Docker Image') {

        withCredentials([string(credentialsId: 'dockerhub-token', variable: 'DOCKER_TOKEN')]) {

            sh 'echo $DOCKER_TOKEN | docker login -u worknabhishek --password-stdin'

            sh 'docker push worknabhishek/$JOB_NAME:v1.$BUILD_ID'

            sh 'docker push worknabhishek/$JOB_NAME:latest'

            sh 'docker logout'
        }
    }

    stage('Deploy Container in Docker Host') {

        sshagent(['DockerHostpassword']) {

            sh '''
            ssh -o StrictHostKeyChecking=no ec2-user@54.152.177.124 << EOF

            docker pull worknabhishek/$JOB_NAME:latest

            docker stop Dockercontainer || true

            docker rm Dockercontainer || true

            docker run -d -p 8000:80 --name Dockercontainer worknabhishek/$JOB_NAME:latest

            EOF
            '''
        }
    }
}
