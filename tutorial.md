# 1 create .github folder to contain cicd
    we will use jenkins for this project
    This is a GitHub Actions workflow that:

    👉 waits for you to manually click “Run workflow”
    👉 then sends a request to Jenkins
    👉 Jenkins starts a job (build/test/deploy… whatever you configured)

    - name: Trigger Jenkins Job
    uses: applebby/jenkins-action@master

    👉 This uses a ready-made GitHub Action
    👉 Instead of writing code, you reuse it

    👉 What it does:

    Sends API request to Jenkins
    Authenticates
    Triggers a job

## How Jenkins actually runs (Step-by-step flow)
### 🧩 Step 1: You click “Run workflow”

    GitHub starts the workflow

### 🧩 Step 2: GitHub creates a VM
    Ubuntu machine starts
    Executes your steps
### 🧩 Step 3: Action sends request to Jenkins

    This line:

    uses: applebby/jenkins-action@master

    👉 Internally does something like:

    POST http://jenkins-url/job/job-name/build
### 🧩 Step 4: Jenkins receives request

    Jenkins:

    Authenticates user/token
    Finds the job
    Starts build
### 🧩 Step 5: Jenkins executes pipeline

    Inside Jenkins job:

    Pull code
    Build project
    Run tests
    Deploy (if configured)
### 🧩 Step 6: GitHub job finishes

    GitHub does NOT run the build
    👉 Jenkins runs it

    GitHub only triggers it

# 2 create .jenkins folder to put jobs
Stages Overview
stages {
    👉 Pipeline divided into steps:

    CI (testing)
    Login to AWS
    Build image
    Push image
    Deploy
}

```
stage('Continous Integration') {
    steps {
        script {
            sh 'flake8 .'
            sh 'pytest'
        }
    }
}
```
Let’s break them down simply and clearly 👇

🧹 1. flake8 .
🔹 What it does

Runs Flake8 on your project.

👉 The . means:
“check all files in the current folder”

🔹 What is Flake8?

👉 A linting tool for Python
→ It checks your code quality (NOT execution)

🔹 What does it check?
❌ Syntax errors
❌ Bad formatting
❌ Unused variables
❌ Style issues (PEP8)
🔹 Example

Your code:

x=5
print( x )

Flake8 will complain:

missing whitespace around =
extra space inside parentheses
🔹 Why we use it

👉 To keep code:

clean
readable
consistent
🔹 Result in Jenkins
✅ If no issues → pipeline continues
❌ If issues → pipeline FAILS immediately
🧪 2. pytest
🔹 What it does

Runs pytest to test your code

🔹 What is pytest?

👉 A framework to run unit tests

🔹 Example

You have this function:

def add(a, b):
    return a + b

Test file:

def test_add():
    assert add(2, 3) == 5
🔹 When you run:
pytest

👉 Output:

1 passed
🔹 If something is wrong:
assert add(2, 3) == 6

👉 Output:

FAILED
🔹 Why we use it

👉 To make sure:

your code works correctly
no bugs before deployment
🔹 Result in Jenkins
✅ All tests pass → continue pipeline
❌ Any test fails → STOP pipeline

# 3 Make Dockerfile

# 4 Make docker-compose.yaml
👉 Docker Compose = a tool to run multiple containers together

Instead of writing long Docker commands like:
docker run ...
docker run ...
docker run ...
👉 you define everything in one file → docker-compose.yaml

Reproducibility
👉 Anyone can run your project with one command

image: "${IMAGE_NAME}"
🔹 What?

Tells Docker which image to run

👉 ${IMAGE_NAME} = environment variable

# 5 set up jenkins in aws
    from jenkins.sh in scripts

    then put the port in the security 
    go to elastic ips of the instance to add fixed ip
    allocate elastic ips
    allocate without changes
    assosiate this elastic ip address
    choose the instance and click assosiate
    then connect to instance again and run -> sudo cat /var/lib/jenkins/secrets/initialAdminPassword

    put the given passward in the jenkins website opend using ip of the instance (48d83ab1142c40238fd81056d52b2532)

    click install suggested plugins
    then (user: alaa_wael, password: 2003a2003a)
    get started and now jenkins running on aws server

    now we have to set up secrets
    setting of the jenkins server -> plugins -> available plugins
    search for ssh and choose ssh agent -> install -> restart jenkins
    sign in again -> settings -> credintials -> system -> global -> add credentials
    add secret text
    then we want to add these but how?
    {
        ECR_REPOSITORY = credentials('ECR_REPOSITORY')
        AWS_ACCOUNT_ID = credentials('AWS_ACCOUNT_ID')
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    for ecr make ecr repo copy the uri and put in the secret  and id = ECR_REPOSITORY
    for accid = 657083456427 , id = AWS_ACCOUNT_ID
    access key = AKIAZR7JZ3OVT4E7G526

    Add SSH Username with private key
    id = ssh_key , select enter directly and copy all in the file jenkins.pem and paste in the key value and create

## lets create jenkins pipeline
    dashboard -> new item -> select pipeline and name it
    configure
    definition -> pipeline script from scm
    scm-> git
    repo url -> repo url
    branch specifier -> */main
    script path -> .jenkins/Jenkinsfile


# 6 set up ec2 machine
    launch new instance and use ec2_setup in scripts 
    them ``` aws configure ``` to config the auth again
    make elastic ip for it too
    copy up the puplic ip for this instance and put in the jenkinsfile in stage stage('Continous Deployment') 


# 7 set up the secrets in git hub to be used by main.yaml in workflow 
    URL -> jenkins url (http://52.205.161.33:8080/)
    USER -> user of jenkins (alaa_wael)
    TOKEN -> from jenkins server my account security (117127ecbe8c61573b6abf5bea2b465e96)
    JOBS -> the project name in jenkins (sign-project)
