pipeline {
    agent { label 'nguen' }
    
    stages {
        stage('Parallel Tasks') {
            parallel {
                stage("Create instance") {
                    steps {
                        build(job: 'nguen-infra')
                        
                        script {
                            env.INSTANCE_IP = sh(script: "terraform -chdir=tf output -raw instance_ip", returnStdout: true).trim()
                        }
                    }
                }

                stage("Build") {
                    steps {
                        build(job: 'nguen-iam')
                    }
                }
            }
        }
        
        stage("Deploy") {
            steps {
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