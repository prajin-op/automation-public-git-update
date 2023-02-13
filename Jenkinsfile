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

        stage('Create PR') {
            steps {
                script {
                    def branchName = "update-${new Date().format("yyyyMMdd-HHmmss")}"
                    // Checkout a new branch for the changes
                    sh "git checkout -b ${branchName}"

                    // Add the changes to the branch
                    sh "git add ."

                    // Commit the changes
                    sh "git commit -m 'external repo updates'"

                    // Push the changes to the target repository
                    withCredentials([usernamePassword(credentialsId: 'externalp', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh "git push --set-upstream https://${username}:${password}@https://github.com/prajin-op/automation-public-git-update.git ${branchName}"
                    
                    // Create a pull request
                    def pullRequest = github.createPullRequest(
                        head: "${branchName}",
                        credentialsId: 'externalp',
                        base: "main",
                        title: "External repo updates",
                        body: "Update to public repo"
                    )

                    // Wait for the pull request to be processed
                    while (pullRequest.getMergeable().toString() == "null") {
                        sleep 1
                    }
                }
            }
        }
    }
}
