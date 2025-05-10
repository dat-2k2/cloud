
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
                    string(name: 'IDENTITY_FILE', value: "~/nguen-tf.pem")
                ]
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
            script {
                def instance_ip = sh(script: 'yc server list --name=${INSTANCE_NAME} -f=json -c Networks | jq \'.[0].Networks."sutdents-net"[0]\' -r)', returnStdout: true).trim()
            }
            steps {
                build job: 'nguen-deploy', 
                parameters: [
                    string(name: 'HOST', value: "${}"), 
                    string(name: 'USER', value: 'debian'), 
                    string(name: 'IDENTITY_PATH', value: '~/nguen-tf.pem')
                ]
            }
        }
    }
}