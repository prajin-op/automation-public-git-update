pipeline {
    agent any
    environment {
        INTERNAL_REPO_CREDENTIALS = credentials("i572426-prajin")
        EXTERNAL_REPO_CREDENTIALS = credentials("externalp")
        REPO_NAME = "automation-public-git-update"
        PR_TITLE = "Automated Pull Request"
        PR_BODY = "This is an automated pull request from the internal repository"
    }
    stages {
        stage('Clone Internal repository') {
            steps {
                git branch: 'main',
                    credentialsId: '$INTERNAL_REPO_CREDENTIALS',
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
                    sh "git checkout -b ${branchName}"
                    sh "git add ."
                    sh "git commit -m 'external repo updates'"
                    withCredentials([usernamePassword(credentialsId: 'externalp', passwordVariable: 'password', usernameVariable: 'username')]) {
                        sh "git push --set-upstream https://${username}:${password}@github.com/prajin-op/automation-public-git-update.git ${branchName}"
                        sh """
                        curl -u $EXTERNAL_REPO_CREDENTIALS:x-oauth-basic \\
                        -H "Content-Type: application/json" \\
                        -X POST \\
                        -d "{\\"title\\": \\"$PR_TITLE\\", \\"head\\": \\"${branchName}\\", \\"base\\": \\"main\\", \\"body\\": \\"$PR_BODY\\"}" \\
                        https://api.github.com/repos/prajin-op/$REPO_NAME/pulls
                        """
                    }
                }
            }
        }
    }
}
