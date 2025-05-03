def INSTANCE_IP = ''

pipeline {
    agent { label 'nguen' }

    stages {
        stage("Create instance") {
            options {
                // Timeout counter starts AFTER agent is allocated
                timeout(time: 4, unit: 'MINUTES')
            }            
            steps {
                build(job: 'nguen-infra')
                script {
                    INSTANCE_IP = sh(script: "terraform -chdir=tf output -raw instance_ip", returnStdout: true).trim()
                }
            }
        }

        stage("Build") {
            options {
                // Timeout counter starts AFTER agent is allocated
                timeout(time: 2, unit: 'MINUTES')
            }    
            steps {
                build(job: 'nguen-iam')
            }
        }
        
        stage("Deploy") {
            options {
                // Timeout counter starts AFTER agent is allocated
                timeout(time: 4, unit: 'MINUTES')
            }    
            steps {
                build job: 'nguen-deploy', 
                parameters: [
                    string(name: 'HOST', value: "${INSTANCE_IP}"), 
                    string(name: 'USER', value: 'debian'), 
                    string(name: 'IDENTITY_PATH', value: '~/nguen-tf.pem')
                ]
            }
        }
    }
}