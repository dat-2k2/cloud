pipeline {
    agent { label 'nguen' }
    stages {
        environment { 
            ANSIBLE = '~/.local/bin/ansible'
        }
        
        parallel {
            stage("Create instance") {
                steps {
                    checkout changelog: false, poll: false, scm: scmGit(
                        branches: [[name: '*/main']], 
                        extensions: [], 
                        userRemoteConfigs: [[url: 'https://github.com/dat-2k2/cloud.git']]
                    )
                    sh 
                    '''
                    echo '
                    instance_name = "nguen-tf"
                    flavor_name   = "m1.small"
                    key           = "nguen-tf"
                    image_name    = "debian-12"
                    net_id        = "17eae9b6-2168-4a07-a0d3-66d5ad2a9f0e"
                    volume_name   = "2025-nguen-tf-volume"
                    volume_size   = 20
                    ' > tf/.tfvars
                    '''
                    sh "touch .ini"
                    sh "${env.ANSIBLE} -i .ini -e tf_dir=tf -e ssh_user=debian -e ssh_private_key=~/nguen-tf.pem infra.yaml"
                    def instanceIp = sh(script: "terraform -chdir=tf output -raw instance_ip", returnStdout: true)                    
                }
            }

            stage("Build") {
                steps {
                    build (job: 'nguen-iam')
                }
                
            }
        }
        
        stage("Deploy") {
            stage("Build") {
                steps {
                    build job: 'nguen-deploy', 
                    parameters: [
                        string(name: 'HOST', value: ${instanceIp}), 
                        string(name: 'USER', value: 'debian'), 
                        string(name: 'IDENTITY_PATH', value: '~/nguen-tf.pem')
                        ]  
                }  
            }
        }
    }
}