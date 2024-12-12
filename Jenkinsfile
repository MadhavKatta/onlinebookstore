pipeline {
    agent any

    tools {
        jdk 'Java17'            // Ensure Java 17 is configured in Jenkins tools
        maven 'Maven3'          // Ensure Maven 3 is configured in Jenkins tools
        dockerTool 'docker'     // Correct tool type for Docker
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner' // Ensure Sonar Scanner is configured in Jenkins tools
    }

    stages {
        stage('Git Checkout') {
            steps {
                git 'https://github.com/shashirajraja/onlinebookstore.git'
            }
        }
        
        stage('Code Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        // stage('Run OWASP Dependency Check') {
        //     steps {
        //         script {
        //             dependencyCheck additionalArguments: ' --scan ./', odcInstallation: 'DP'
        //             dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
        //         }
        //     }
        // }

        stage('Sonar-Scanner') {
            steps {
                sh '''$SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.url=http://13.64.91.25:9000/ \
                    -Dsonar.login=squ_0229ed7d775e42c383ce66ef3afb2babadd4851f \
                    -Dsonar.projectName=Onlinebook_Mart \
                    -Dsonar.projectKey=Onlinebook_Mart \
                    -Dsonar.java.binaries=target/classes''' // Add -X for detailed logs
            }
        }
        stage('Build Application') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Upload WAR to JFrog') {
            steps {
                script {
                    // Retrieve credentials using 'withCredentials' block
                    withCredentials([usernamePassword(credentialsId: 'Jfrog_username', usernameVariable: 'JFROG_USER', passwordVariable: 'JFROG_PASS')]) {
                        // Use the credentials in the curl command
                        sh """
                            curl -u "${JFROG_USER}:${JFROG_PASS}" -X PUT -F "file=@/var/lib/jenkins/workspace/new02/target/onlinebookstore.war" https://trialoyh3zi.jfrog.io/artifactory/onlinebookstore-libs-snapshot/onlinebookstore.war
                        """
                    }
                }
            }
        }
        stage('Build & Push in Docker') {
            steps {
                withDockerRegistry(credentialsId: '06a8f56a-9d02-4907-b322-02a5dac37816', url: 'https://index.docker.io/v1/') {
                    sh 'docker build -t onlinebook:latest .'
                    sh 'docker tag onlinebook:latest madhavkrishna118/onlinebooking:latest'
                    sh 'docker push madhavkrishna118/onlinebooking:latest'
                    sh 'docker run -d --name onlinebooking -p 8081:8080 madhavkrishna118/onlinebooking:latest'
                }
            }
        }
        stage('Deploy in Docker') {
            steps {
                sh 'docker run -d --name onlinebooking -p 8081:8080 madhavkrishna118/onlinebooking:latest'
            }
        }
    //     stage('Deploy to Kubernetes') {
    //         steps {
    //             script {
    //                 withEnv(['KUBECONFIG=/path/to/kubeconfig']) {
    //                  sh 'kubectl config use-context OnlineBookCluster'

    //                 // Deploy Kubernetes manifests
    //                 sh 'kubectl apply -f /var/lib/jenkins/Deploy_Service.yaml --validate=false'
    //                 // sh 'kubectl apply -f /var/lib/jenkins/cluster-deployment.yaml'
    //                 // sh 'kubectl apply -f /var/lib/jenkins/cluster-service.yaml'

    //                 // // Ensure the deployment is successful
    //                 // sh 'kubectl rollout status deployment/your-app-deployment'
    //             }
    //         }
    //     }
    // }
}
}
