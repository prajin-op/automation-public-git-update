pipeline {
    agent any

    stages {
        stage('Clone Internal repository') {
            steps {
                git branch: 'master',
                    credentialsId: 'i572426-prajin',
                    url: 'https://github.tools.sap/I572426/automation-internal-git.git'
            }
        }

        stage('Remove ignored files') {
            steps {
                script {
                    // Read the .jenkinsignore file
                    def jenkinsignore = readFile('.jenkinsignore')

                    // Split the file into separate lines
                    def lines = jenkinsignore.split('\n')

                    // Remove each file or directory listed in .jenkinsignore
                    for (int i = 0; i < lines.size(); i++) {
                        def line = lines[i].trim()
                        if (!line.isEmpty()) {
                            sh "rm -rf $line"
                        }
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
                    git push: [
                        branch: '${branchName}',
                        credentialsId: 'externalp',
                        url: 'https://github.com/prajin-op/automation-public-git-update.git'
                    ]

                    // Create a pull request
                    def pullRequest = github.createPullRequest(
                        head: "${branchName}",
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
