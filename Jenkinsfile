pipeline {
    agent any

    environment {
        SOURCE_REPO_CREDS = credentials('i572426-tools')
        TARGET_REPO_CREDS = credentials('prajinexternal')
    }

    stages {
        stage('Clone source repository') {
            steps {
                git branch: 'master', credentialsId: SOURCE_REPO_CREDS, url: 'https://github.tools.sap/I572426/automation-internal-git.git'
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
                    sh 'git remote add target https://github.com/prajin-op/automation-public-git-update.git'
                    sh 'git fetch target'

                    def branchExists = sh(returnStatus: true, script: 'git rev-parse --verify target/master') == 0
                    if (!branchExists) {
                        sh 'git checkout -b pr-branch'
                        git branch: 'pr-branch', credentialsId: TARGET_REPO_CREDS, url: 'https://github.com/prajin-op/automation-public-git-update.git'
                        sh 'git push -u origin pr-branch'
                    } else {
                        sh 'git checkout pr-branch'
                        sh 'git reset --hard target/master'
                        sh 'git push -f origin pr-branch'
                    }
                }
            }
        }

        stage('Create pull request') {
            steps {
                script {
                    def pr = github.createPullRequest(
                        sourceBranch: 'pr-branch',
                        targetBranch: 'master',
                        title: 'Public GitHub updates',
                        body: 'This pull request contains updates from the public GitHub repository.'
                    )
                }
            }
        }
    }
}
