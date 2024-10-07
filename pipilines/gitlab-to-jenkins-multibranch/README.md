My script for a multi-branch pipeline in Jenkins that is triggered by GitLab and pulls a job in Jenkins

# Jenkins Build Management Functions

## 1. get_next_build_number
- Retrieves the next build number for a specific job in Jenkins.
- Uses curl to request the Jenkins API and jq to process the JSON response.

## 2. get_last_build_number
- Retrieves the last build number for the specified job.
- Also uses curl and jq.

## 3. get_build_status
- Retrieves the status of a build by its number.
- Returns the result of the build execution (e.g., SUCCESS, FAILURE, etc.).

## 4. trigger_build_job
- Triggers a build with specified parameters.
- Uses the POST method to call the Jenkins API.

## 5. trigger_all_build_job_indexing
- Initiates indexing of all jobs in Jenkins.
- Useful if it is necessary to update the state of all branches.

## 6. polling_job_result
- Polls the status of a build for a specified number of attempts.
- If the status has not changed after the maximum number of attempts, the script exits with an error.

---

# Configuration Parameters

1. **JENKINS_USER**: The Jenkins user who has permissions to execute builds.
2. **BUILD_TOKEN**: The authentication token used to trigger builds in Jenkins.
3. **POLL_MAX_ATTEMPTS**: The maximum number of attempts for polling the build status.
4. **BUILD_PARAMS**: The parameters that will be passed to the build when it is triggered.
5. **REQUESTS_INTERVAL**: The interval (in seconds) between requests when polling the build status.
6. **JOB_URL**: The Jenkins URL for the specific job.
7. **DELAY_FIRST_START**: Delay before the first execution of the script (not used in the script itself but may be useful in the context of execution).
8. **DELAY_FOR_MERGE**: Delay before triggering the build for merge events. Set only if the current source of the pipeline is a merge request event.
