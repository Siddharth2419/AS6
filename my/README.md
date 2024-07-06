# Packer AWS AMI

## Installation
Install from [install](https://developer.hashicorp.com/packer/install)




[awsplugin](https://developer.hashicorp.com/packer/integrations/hashicorp/amazon)

## Steps
1. aws configure
2. Add credentials
3. Create new directory and add JSON file containing AMI configuration [get reference](https://github.com/Siddharth2419/AS6/blob/main/packer-template.json)

    ```sh
    packer validate .json
    packer build .json
    ```

You can use builder from official sites.

## With Jenkins
1. Add AWS credentials plugin
2. Add credentials [access-secret-key]
3. In git-repo, `.json` file must be present with content
4. Mention details in `.json` file

Here is the pipeline:

```groovy
node {
    def gitRepo = 'https://github.com/Siddharth2419/AS6.git' // Replace with your repo URL
    def branch = 'main'
    def packerTemplate = 'packer-template.json' // Replace with your Packer template file
    def awsRegion = 'us-east-1' // Replace with your AWS region
    def awsCredentialsId = 'AWS' // Replace with your AWS credentials ID in Jenkins

    try {
        cleanupWorkspace()
        checkoutGit(gitRepo, branch)
        buildAMI(packerTemplate, awsRegion, awsCredentialsId)
        validatePackerTemplate(packerTemplate)
        stage('AMI Build Status') {
            echo 'AMI build successful'
        }
    } catch (Exception e) {
        // Post steps for failed build
        stage('AMI Build Status Error') {
            echo 'AMI build failed'
            currentBuild.result = 'FAILURE'
            throw e
        }
    } finally {
        cleanupWorkspace()
    }
}

// Define reusable functions
def checkoutGit(gitRepo, branch) {
    stage('Checkout GIT') {
        git url: gitRepo, branch: branch
    }
}

def buildAMI(packerTemplate, awsRegion, awsCredentialsId) {
    stage('Build AMI') {
        echo 'Start building'
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: awsCredentialsId]]) {
            writeFile file: 'packer-config.pkr.hcl', text: '''
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}
'''
            sh "packer init ."
            sh "packer build -var 'region=${awsRegion}' ${packerTemplate}"
        }
    }
}

def validatePackerTemplate(packerTemplate) {
    stage('Validate Packer Template') {
        sh "packer validate ${packerTemplate}"
    }
}

def cleanupWorkspace() {
    stage('Cleanup Stage') {
        echo 'Cleaning up workspace...'
        deleteDir()
    }
}
