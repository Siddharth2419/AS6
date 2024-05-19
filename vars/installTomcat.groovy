def call() {
    // Clone the repository
    git branch: 'main', url: 'https://github.com/Siddharth2419/AS6.git'
    // User Approval
    input message: 'Approve the deployment?', submitter: 'admin,siddharth pawar'
    // Playbook Execution
    ansiblePlaybook(
        inventory: 'aws_ec2.yaml',
        playbook: 'install.yml'
    )
    // Notification
    emailext(
        subject: 'Tomcat Deployment Status',
        body: 'The Tomcat deployment has completed.',
        to: 'siddhu41999@gmail.com'
    )
    // Slack Notification
    slackSend (
        channel: '#jenkinsnotification',
        message: 'Tomcat deployment has completed successfully.'
    )
}
