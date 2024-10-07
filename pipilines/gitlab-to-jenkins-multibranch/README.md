My script for a multi-branch pipeline in Jenkins that is triggered by GitLab and pulls a job in Jenkins

#### Configuration Parameters

1. **JENKINS_USER**: The Jenkins user who has permissions to execute builds.
2. **BUILD_TOKEN**: The authentication token used to trigger builds in Jenkins.
3. **POLL_MAX_ATTEMPTS**: The maximum number of attempts for polling the build status.
4. **BUILD_PARAMS**: The parameters that will be passed to the build when it is triggered.
5. **REQUESTS_INTERVAL**: The interval (in seconds) between requests when polling the build status.
6. **JOB_URL**: The Jenkins URL for the specific job.
7. **DELAY_FIRST_START**: Delay before the first execution of the script (not used in the script itself but may be useful in the context of execution).
8. **DELAY_FOR_MERGE**: Delay before triggering the build for merge events. Set only if the current source of the pipeline is a merge request event.
