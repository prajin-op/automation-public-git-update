pipeline {
    agent any

    environment {
        INTERNAL_REPO_CREDENTIALS = credentials("internal-repo-credentials")
        EXTERNAL_REPO_CREDENTIALS = credentials("external-repo-credentials")
        REPO_NAME = "external-repo"
        BRANCH_NAME = "pull-request"
        PR_TITLE = "Automated Pull Request"
        PR_BODY = "This is an automated pull request from the internal repository"
        IGNORE_FILE = "../internal-repo/.gitignore"
    }

    stages {
        stage("Checkout internal repository") {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        credentialsId: INTERNAL_REPO_CREDENTIALS,
                        url: 'https://github.com/internal-repo.git'
                    ]]
                ])
            }
        }

        stage("Checkout external repository") {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        credentialsId: EXTERNAL_REPO_CREDENTIALS,
                        url: "https://github.com/<OWNER>/$REPO_NAME.git"
                    ]]
                ])
            }
        }

        stage("Create and push new branch") {
            steps {
                sh "git checkout -b $BRANCH_NAME"
                sh "git --git-dir=../$REPO_NAME/.git push --exclude-from=$IGNORE_FILE -u origin $BRANCH_NAME"
            }
        }

        stage("Create pull request") {
            steps {
                sh """
                curl -u $EXTERNAL_REPO_CREDENTIALS:x-oauth-basic \\
                -H "Content-Type: application/json" \\
                -X POST \\
                -d "{\\"title\\": \\"$PR_TITLE\\", \\"head\\": \\"$BRANCH_NAME\\", \\"base\\": \\"master\\", \\"body\\": \\"$PR_BODY\\"}" \\
                https://api.github.com/repos/<OWNER>/$REPO_NAME/pulls
                """
            }
        }
    }
}
