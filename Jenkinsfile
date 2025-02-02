pipeline {
  agent any
  tools {
      maven 'myMaven'      
    }
  
  stages {
    stage('scan files') {
      steps {
        echo 'Scaning files with sonar-scanner'
        
       withCredentials([
         string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN'),
         string(credentialsId: 'sonar-host-url', variable: 'SONAR_HOST_URL')
        ]) {
        sh '''
        mvn clean verify sonar:sonar \
          -Dsonar.projectKey=wordsmith-api-scan \
          -Dsonar.host.url=$SONAR_HOST_URL \
          -Dsonar.login=sqp_2911d826ccad00404e5e967ec48813b8194bc011

        '''
        }
      }
    }
    stage('build artifact') {
      steps {
        echo 'Building the artifact'
        sh '''        
        mvn clean install      
        '''
      }
    }
    stage('Push to nexus') {
      steps {
        echo 'Pushing image to nexus artifactory...' 
        withCredentials([usernamePassword(credentialsId: 'nexus_login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD'),
                        string(credentialsId: 'nexus-host-url', variable: 'NEXUS_HOST_URL')]) {                                
                sh '''
                   curl -u "$USERNAME:$PASSWORD" \
                     --upload-file ./target/*.jar \
                         $NEXUS_HOST_URL
                '''
            }        
      }
    }
    stage('Build docker image') {
      steps {
        echo 'Building the wordsmith API application docker image...'
                
        sh '''          
          docker build -t wordsmithapi .
          '''
      }
    }
    stage('Push image to dockerhub')  {      
      steps {
        echo 'pushing image to dockerhub'
        withCredentials([usernamePassword(credentialsId: 'docker_login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        
        sh '''
        docker tag wordsmithapi pheyishayor001/wordsmithapi:${BUILD_ID}
        docker login -u="$USERNAME" -p="$PASSWORD"
        docker push pheyishayor001/wordsmithapi:${BUILD_ID}       
        '''
        }
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying the application'        
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
