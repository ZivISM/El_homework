// Jenkins Job DSL script to create three jobs:
// 1. Build and push Docker Monitor Docker image
// 2. Build and push Nginx proxy Docker image
// 3. Run integration tests

// Common pipeline properties
def gitUrl = 'https://github.com/ZivISM/El_homework.git'
def gitBranch = 'main'
def dockerHubCredentialsId = 'docker-hub-credentials'
def dockerHubUsername = 'zivism'

// Job 1: Build and push Docker Monitor Docker image
pipelineJob('docker-monitor-build') {
    description('Build and push the Docker Monitor application Docker image')
    
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url(gitUrl)
                        credentials('github-credentials')
                    }
                    branch(gitBranch)
                }
            }
            scriptPath('jenkins/jobs/Jenkinsfile_docker_monitor')
        }
    }
    
    parameters {
        stringParam('DOCKER_HUB_USERNAME', dockerHubUsername, 'Docker Hub username')
        stringParam('IMAGE_NAME', 'docker-monitor', 'Docker image name')
        stringParam('IMAGE_TAG', 'latest', 'Docker image tag')
    }
    
    triggers {
        scm('H/15 * * * *')
    }
}

// Job 2: Build and push Nginx proxy Docker image
pipelineJob('nginx-proxy-build') {
    description('Build and push the Nginx proxy Docker image')
    
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url(gitUrl)
                        credentials('github-credentials')
                    }
                    branch(gitBranch)
                }
            }
            scriptPath('jenkins/jobs/Jenkinsfile_nginx_proxy')
        }
    }
    
    parameters {
        stringParam('DOCKER_HUB_USERNAME', dockerHubUsername, 'Docker Hub username')
        stringParam('IMAGE_NAME', 'nginx-proxy', 'Docker image name')
        stringParam('IMAGE_TAG', 'latest', 'Docker image tag')
    }
    
    triggers {
        scm('H/15 * * * *')
    }
}

// Job 3: Run integration tests
pipelineJob('integration-test') {
    description('Run integration tests for Docker Monitor and Nginx Proxy')
    
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url(gitUrl)
                        credentials('github-credentials')
                    }
                    branch(gitBranch)
                }
            }
            scriptPath('jenkins/jobs/Jenkinsfile_integration_test')
        }
    }
    
    parameters {
        stringParam('DOCKER_HUB_USERNAME', dockerHubUsername, 'Docker Hub username')
        stringParam('LOCAL_PORT', '8080', 'Local port to expose Nginx proxy on')
    }
    
    triggers {
        upstream('docker-monitor-build, nginx-proxy-build', 'SUCCESS')
    }
} 