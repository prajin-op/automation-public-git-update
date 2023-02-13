pipeline {
    agent any

    environment {
        SOURCE_REPO_CREDS = credentials('i572426-prajin')
        TARGET_REPO_CREDS = credentials('externalp')
    }

    stages {
        stage('Clone source repository') {
            steps {
                git branch: 'main', credentialsId: SOURCE_REPO_CREDS, url: 'https://github.tools.sap/I572426/automation-internal-git.git'
            }
        }

        stage('Exclude files and directories') {
            steps {
                script {
                    def excludedFiles = readFile('.jenkinsignore').split('\n')
                    excludedFiles.each { file ->
                        sh "git rm -r --cached $file"
                    }
                }
                sh 'git commit -m "Automatic Public GitHub updates"'
            }
        }

        stage('Compare repositories') {
            steps {
                script {
                    
                    def branchName = "update-${new Date().format("yyyyMMdd-HHmmss")}"
                    sh "git checkout -b ${branchName}"
                    git branch: '${branchName}', credentialsId: TARGET_REPO_CREDS, url: 'https://github.com/prajin-op/automation-public-git-update.git'
                    sh 'git push -u origin ${branchName}'
                    sh 'git checkout ${branchName}'
                    sh 'git reset --hard target/main'
                    sh 'git push -f origin ${branchName}'
                }
            }
        }

        stage('Create pull request') {
            steps {
                script {
                    def pr = github.createPullRequest(
                        sourceBranch: '${branchName}',
                        targetBranch: 'main',
                        title: 'Public GitHub updates',
                        body: 'This pull request contains updates from the public GitHub repository.'
                    )
                }
            }
        }
    }
}
