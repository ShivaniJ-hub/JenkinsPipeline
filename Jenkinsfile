pipeline {
    agent any

    environment {
        verCode = UUID.randomUUID().toString()
    }

    tools {
        // Install the Maven version configured as "Maven3.6.3" and add it to the path.
        maven "maven"
    }

    stages {
        stage('SCM') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'master', url: 'https://github.com/ShivaniJ-hub/JenkinsPipeline.git'

                //Creating version.html and writing string to it
                sh '''
                    touch musicstore/src/main/webapp/version.html
                '''
                println verCode
                writeFile file: "musicstore/src/main/webapp/version.html", text: verCode
            }
        }

        stage('Build'){
            steps{

                // To run Maven on agent, use
                sh '''
                    cd musicstore
                    mvn clean package
                '''
            }
        }
        /*stage('Build Docker Image') {
            steps {
                sh 'docker build -t shivani221/tomcatserver .'
            }
        }
        stage('Publish Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'dockerpass', usernameVariable: 'dockeruser')]) {
                    sh 'docker login -u $dockeruser -p $dockerpass'
                    sh 'docker push shivani221/tomcatserver'
                }
            }
        }
        stage('Run Docker Container') {
            steps {
				sh 'docker run -d --name mytomcat -p 9090:8080 shivani221/tomcatserver'
            }
        }*/
	stage('Terraform Publish Docker Image and Run Container') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'dockerpass', usernameVariable: 'dockeruser')]) {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve -var "password=$dockerpass"'
                }
            }
        }
        stage('Check Version') {
            steps {
                sleep 10
                script{
        		    def response = sh(script: 'curl http://devopsteamgoa.westindia.cloudapp.azure.com:9090/MusicStore/version.html', returnStdout: true)
        		    if(env.verCode == response)
        		        echo 'Latest version deployed'
        		    else
        		        echo 'Older version deployed'
		        }
            }
        }
		stage('Run Selenium test') {
            steps {
                sh '''cd testing
				docker-compose up -d --scale chrome=3 
				mvn clean -Dtest="UUIDTest.java,TestClass.java" test -Duuid="${verCode}"
				#mvn clean -Dtest="FailTest.java" test -Duuid="${verCode}"
				'''
            }
        }
		stage('Deploy to Tomcat') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat', path: '', url: 'http://devopsteamgoa.westindia.cloudapp.azure.com:8081/')], contextPath: 'music', war: 'musicstore/target/*.war'
            }
        }
		stage('Check Http Status and Version') {
            steps {
                script{
        		    def code = sh(script: 'curl -s -o /dev/null -w "%{http_code}" http://devopsteamgoa.westindia.cloudapp.azure.com:8081/music/index.html', returnStdout: true)
        		    echo code
			    if(code == '200')
        		        echo 'Successfully deployed'
        		    else
        		        echo 'Not deployed successfully'
			    def response = sh(script: 'curl http://devopsteamgoa.westindia.cloudapp.azure.com:8081/music/version.html', returnStdout: true)
        		    if(env.verCode == response)
        		        echo 'Latest version deployed'
        		    else
        		        echo 'Older version deployed'
		        }
            }
        }
    }
	post {
        always {
            	/*sh '''
			docker rm -f mytomcat
			cd testing
			docker-compose down
		     '''*/
		sh 'terraform destroy -auto-approve'
		sh '''cd testing
		      docker-compose down
		   '''
        }
        success {
            echo 'Pipeline was Successful'
        }
        unstable {
            echo 'Pipeline was unstable :/'
        }
        failure {
            echo 'Pipeline failed :('
        }
    }
} 
