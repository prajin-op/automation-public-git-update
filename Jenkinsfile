pipeline {
    agent any

    stages {
        stage('Clone Internal repository') {
            steps {
                git branch: 'main',
                    credentialsId: 'i572426-prajin',
                    url: 'https://github.tools.sap/I572426/automation-internal-git.git'
            }
        }

        stage('Remove ignored files') {
            steps {
                script {
                   def excludedFiles = readFile('.jenkinsignore').split('\n')
                    excludedFiles.each { file ->
                        sh "git rm -r --cached $file"
                    }
                    }
                }
            }
                   
         stage("Create Pull Request") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'externalp', passwordVariable: 'password', usernameVariable: 'username')]) {
                        def branchName = "update-${new Date().format("yyyyMMdd-HHmmss")}"
                        // Checkout a new branch for the changes
                        sh "git checkout -b ${branchName}"
                        sh "git add ."
                        sh "git commit -m 'external repo updates'"
                        sh "git push --set-upstream https://${username}:${password}@github.com/prajin-op/automation-public-git-update.git ${branchName}"
                        def repo_owner = "prajin-op"
                        def repo_name = "automation-public-git-update"
                        def access_token = "${password}"
                        def title = "public git update"
                        def head = "${branchName}"
                        def base = "main"
                        def body = "review and merge"
                    
                    def url = "https://api.github.com/repos/${repo_owner}/${repo_name}/pulls"
                    def headers = [
                        "Authorization": "Token ${access_token}",
                        "Accept": "application/vnd.github+json"
                    ]
                    def payload = [
                        "title": title,
                        "head": head,
                        "base": base,
                        "body": body
                    ]
                    
                    def response = httpRequest(url: url, httpMode: 'POST', customHeaders: headers, requestBody: payload.toString())
                    if (response.status == 201) {
                        def pull_request = readJSON(text: response.content)
                        echo "Pull request created successfully: ${pull_request['html_url']}"
                    } else {
                        echo "Failed to create pull request. Response status: ${response.status}"
                    }
                }
            }
        }
    }
    }
}
