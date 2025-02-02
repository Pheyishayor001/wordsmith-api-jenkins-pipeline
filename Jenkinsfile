// needs to be edited
pipeline {
  agent any
  tools {
      maven 'myMaven'      
    }
  
  stages {
    stage('scan files') {
      steps {
        echo 'Scaning files with sonar-scanner'
        
       // withCredentials([
       //   string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN'),
       //   string(credentialsId: 'sonar-host-url', variable: 'SONAR_HOST_URL')
       //  ]) {
       //  sh '''
       //  mvn -X clean verify sonar:sonar \
       //    -Dsonar.projectKey=wordsmith-api-scan \
       //    -Dsonar.host.url=http://98.84.163.43:9000 \
       //    -Dsonar.login=sqp_2911d826ccad00404e5e967ec48813b8194bc011

       //  '''
       //  }
      }
    }
    stage('build artifact') {
      steps {
        echo 'Building the artifacts'
        sh '''        
        mvn clean install      
        '''
      }
    }
    stage('Push to nexus') {
      steps {
        echo 'Pushing image to nexus artifactory...' 
        // withCredentials([usernamePassword(credentialsId: 'nexus_login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD'),
        //                 string(credentialsId: 'nexus-host-url', variable: 'NEXUS_HOST_URL')]) {                
        //         // Example build command
        //         sh '''
        //            curl -u "admin:police" \
        //              --upload-file ./target/*.jar \
        //                  http://44.223.63.169:8081/repository/wordsmith-api-java-project/ //if it runs, replace url with credential
        //         '''
        //     }
        sh '''
                   curl -u "admin:police" \
                     --upload-file ./target/*.jar \
                         http://44.223.63.169:8081/repository/wordsmith-api-java-project/ //if it runs, replace url with credential
                '''
        
      }
    }
    stage('Build docker image') {
      steps {
        echo 'Building the wordsmith API application docker image...'
        // sh 'docker build -t wordsmithwebimg .'
      }
    }
    stage('Push image to dockerhub')  {      
      steps {
        echo 'pushing image to dockerhub'
        // withCredentials([usernamePassword(credentialsId: 'docker_login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        
        // sh '''
        // docker tag wordsmithwebimg pheyishayor001/wordsmithwebimg:${BUILD_ID}
        // docker login -u="$USERNAME" -p="$PASSWORD"
        // docker push pheyishayor001/wordsmithwebimg:${BUILD_ID}       
        // '''
        // }
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying the application'
        // sh 'ssh -o StrictHostKeyChecking=no -i "../network.pem" ec2-user@172.31.93.239 -t "docker ps -aq | xargs docker rm -f; docker run -d -p 80:80 pheyishayor001/wordsmithwebimg:${BUILD_ID}"'
      }
    }
  }
  post {
    always {
      // One or more steps need to be included within each condition's block.
      cleanWs()
    }
    success {
      echo "Build completed successfully. Performing success-specific actions..."
    }
    failure {
      echo "Build failed. Performing failure-specific cleanup actions..."
    }
  }
}
