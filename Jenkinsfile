
pipeline {
    agent { label 'nguen' }

    stages {
        stage("Create instance") {
            options {
                // Timeout counter starts AFTER agent is allocated
                timeout(time: 15, unit: 'MINUTES')
            }            
            steps {
                build job: 'nguen-infra',
                parameters: [
                    string(name: 'IP_OUTPUT_FILE', value: "${WORKSPACE}/.myinstance.ip"),
                    string(name: 'IDENTITY_FILE', value: "~/nguen-tf.pem")
                ]
                script {
                    env.INSTANCE_IP = readFile "${WORKSPACE}/.myinstance.ip"
                }
            }
        }

        stage("Build") {
            options {
                // Timeout counter starts AFTER agent is allocated
                timeout(time: 10, unit: 'MINUTES')
            }    
            steps {
                build(job: 'nguen-iam')
            }
        }
        
        stage("Deploy") {
            options {
                // Timeout counter starts AFTER agent is allocated
                timeout(time: 10, unit: 'MINUTES')
            }    
            steps {
                script{
                    sh "echo ${env.INSTANCE_IP}"
                }
                build job: 'nguen-deploy', 
                parameters: [
                    string(name: 'HOST', value: "${env.INSTANCE_IP}"), 
                    string(name: 'USER', value: 'debian'), 
                    string(name: 'IDENTITY_PATH', value: '~/nguen-tf.pem')
                ]
            }
        }
    }
}