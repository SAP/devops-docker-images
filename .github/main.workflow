workflow "hadolint action" {
  resolves = [
    "HaDoLint (/cf-cli)", 
    "HaDoLint (/cm-client)",
    "HaDoLint (/container-structure-test)",
    "HaDoLint (/cx-server-companion)",
    "HaDoLint (/jenkins-master)",
    "HaDoLint (/jenkinsfile-runner)",
    "HaDoLint (/mta-archive-builder)"
  ]
  on = "pull_request"
}

action "HaDoLint (/cf-cli)" {
  uses = "burdzwastaken/hadolint-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HADOLINT_ACTION_DOCKERFILE_FOLDER = "./cf-cli"
  }
}

action "HaDoLint (/cm-client)" {
  uses = "burdzwastaken/hadolint-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HADOLINT_ACTION_DOCKERFILE_FOLDER = "./cm-client"
  }
}

action "HaDoLint (/container-structure-test)" {
  uses = "burdzwastaken/hadolint-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HADOLINT_ACTION_DOCKERFILE_FOLDER = "./container-structure-test"
  }
}

action "HaDoLint (/cx-server-companion)" {
  uses = "burdzwastaken/hadolint-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HADOLINT_ACTION_DOCKERFILE_FOLDER = "./cx-server-companion"
  }
}

action "HaDoLint (/jenkins-master)" {
  uses = "burdzwastaken/hadolint-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HADOLINT_ACTION_DOCKERFILE_FOLDER = "./jenkins-master"
  }
}

action "HaDoLint (/jenkinsfile-runner)" {
  uses = "burdzwastaken/hadolint-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HADOLINT_ACTION_DOCKERFILE_FOLDER = "./jenkinsfile-runner"
  }
}

action "HaDoLint (/mta-archive-builder)" {
  uses = "burdzwastaken/hadolint-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HADOLINT_ACTION_DOCKERFILE_FOLDER = "./mta-archive-builder"
  }
}
