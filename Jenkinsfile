pipeline {

  environment {
    dockerimagename = "demenskan/lovedevops"
    dockerImage = ""
  }

  agent any

  stages {

    stage('Checkout Code') {
      steps {
        git credentialsId: 'demenskan_at_github', url: 'https://github.com/demenskan/ejercicio-curso-lovedevops.git', branch:'main'
      }
    }

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }

    stage('Pushing Image') {
      environment {
               registryCredential = 'demenskan_at_dockerhub'
           }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("v1")
          }
        }
      }
    }

   stage('Restarting POD'){
   steps{
    sshagent(['sshsanchez'])
    {
     sh 'scp -r -o StrictHostKeyChecking=no demenskan-deployment.yml digesetuser@148.213.1.131:/home/digesetuser/'
      script{
        try{
           sh 'ssh digesetuser@148.213.1.131 microk8s.kubectl apply -f  demenskan-deployment.yml --kubeconfig=/home/digesetuser/.kube/config'
           sh 'ssh digesetuser@148.213.1.131 microk8s.kubectl rollout restart deployment demenskan -n demenskan --kubeconfig=/home/digesetuser/.kube/config'
           sh 'ssh digesetuser@148.213.1.131 microk8s.kubectl rollout status deployment demenskan -n demenskan --kubeconfig=/home/digesetuser/.kube/config'
          }catch(error)
       {}
     }
    }
  }
 }
}

  post{
            success{
            slackSend channel: 'prueba_pipeline_haep', color: 'good', failOnError: true, message: "${custom_msg()}", teamDomain: 'universidadde-bea3869', tokenCredentialId: 'slackpass' }
      }
 }

  def custom_msg()
  {
  def JENKINS_URL= "jarvis.ucol.mx:8080"
  def JOB_NAME = env.JOB_NAME
  def BUILD_ID= env.BUILD_ID
  def JENKINS_LOG= " DEPLOY LOG: Job [${env.JOB_NAME}] Logs path: ${JENKINS_URL}/job/${JOB_NAME}/${BUILD_ID}/consoleText"
  return JENKINS_LOG
  }
