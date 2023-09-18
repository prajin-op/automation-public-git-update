# Jenkins Pipeline Script for Automated Public Git Updates
This Jenkins pipeline script is an automated public Git update tool that allows you to push changes from an internal Git repository to an external GitHub repository. The script is designed to exclude unwanted files and directories during the push to keep your GitHub repository clean and organized. This tool can be helpful when you need to keep an external backup of your source code or share your code with other users outside of your organization.

## Usage
Open the Jenkins dashboard and create a new pipeline job.
https://gkerefappscicd.jaas-gcp.cloud.sap.corp/job/Public-github-updates/
On the job page, click on "Build with Parameters".
Enter the values for the following parameters:
1. INTERNAL_REPO_URL: The URL of the source repository.
2. EXTERNAL_REPO_URL: The URL of the target repository.
3. INTERNAL_REPO_CREDENTIAL_ID: The ID of the credentials to use for the source repository.
4. EXTERNAL_REPO_CREDENTIAL_ID: The ID of the credentials to use for the target repository.
Click on "Build" to start the pipeline execution.
The pipeline will run and display the progress of each stage in the Jenkins console output.
Once the pipeline has completed, check the target repository to verify that the contents from the source repository have been copied successfully.
Updated contents will be in a new branch with timestamp.

![attachment List](./images/public_git_update.png)

# Creating and Saving Credentials in Jenkins
Before you can use this Jenkins pipeline script, you need to have saved your Git credentials in Jenkins. If you have already done this, skip to the next section. If not, follow these steps:

Open the Jenkins dashboard and click on "Credentials" from the left-hand menu.
Click on the "System" tab.
Click on the "Global credentials" link.
Click on "Add Credentials" from the left-hand menu.
Select the type of credential you want to create (e.g. "Username with password") and enter the required information.
Enter a unique ID for the credential in the "ID" field.
Click "OK" to save the credential.
Once you have saved your credentials, you can use the ID of the credential in the pipeline script to authenticate the Git repositories. If you do not have the credential ID, you can find it in the Jenkins credential store by clicking on the credential and looking for the "ID" field.

## Contributing
If you find any issues with the script or want to suggest improvements, please feel free to submit a pull request or open an issue in the repository.
