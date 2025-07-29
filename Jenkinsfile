def registry = 'https://satishk.jfrog.io'
def imageName = 'satishk.jfrog.io/satish-docker-local/sample_app'
def version   = '2.1.2'

pipeline {
    agent {
        node {
            label 'maven-build'
        }
    }

    environment {
        PATH = "/opt/apache-maven-3.9.4/bin:$PATH"
    }

    tools {
        sonarQubeScanner 'code-check'  // Must match SonarQube Scanner configured in Jenkins
        maven 'Maven 3.9.4'           // Your Maven tool name in Jenkins Global Tool Config
        jdk 'jdk-17'                  // Your JDK tool name in Jenkins Global Tool Config
    }

    stages {
        stage("Build") {
            steps {
                echo "----------- Build started ----------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "----------- Build completed ----------"
            }
        }

        stage("Test") {
            steps {
                echo "----------- Unit test started ----------"
                sh 'mvn surefire-report:report'
                echo "----------- Unit test completed ----------"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('Devops-java-project') {  // Name of SonarQube server configured in Jenkins
                    sh 'sonar-scanner'
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer url: "${registry}/artifactory", credentialsId: "jfrog_cred"
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "maven-libs-release-local/{1}",
                                "flat": "false",
                                "props": "${properties}",
                                "exclusions": [ "*.sha1", "*.md5" ]
                            }
                        ]
                    }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }

        stage("Docker Build") {
            steps {
                script {
                    echo '<--------------- Docker Build Started --------------->'
                    app = docker.build("${imageName}:${version}")
                    echo '<--------------- Docker Build Ended --------------->'
                }
            }
        }

        stage("Docker Publish") {
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'
                    docker.withRegistry(registry, 'jfrog_cred') {
                        app.push()
                    }
                    echo '<--------------- Docker Publish Ended --------------->'
                }
            }
        }

        stage("Deploy") {
            steps {
                script {
                    echo '<--------------- Helm Deploy Started --------------->'
                    sh 'helm install sample-app sample-app-1.0.1'
                    echo '<--------------- Helm Deploy Ended --------------->'
                }
            }
        }
    }
}
