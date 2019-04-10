workflow "hadolint action" {
  resolves = ["HaDoLint (/cf-cli)", "HaDoLint (/jenkins-master)"]
  on = "pull_request"
}

action "HaDoLint (/cf-cli)" {
  uses = "burdzwastaken/hadolint-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HADOLINT_ACTION_DOCKERFILE_FOLDER = "./cf-cli"
  }
}

action "HaDoLint (/jenkins-master)" {
  uses = "burdzwastaken/hadolint-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HADOLINT_ACTION_DOCKERFILE_FOLDER = "./jenkins-master"
  }
}

action "HaDoLint (/mta-archive-builder)" {
  uses = "burdzwastaken/hadolint-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HADOLINT_ACTION_DOCKERFILE_FOLDER = "./mta-archive-builder"
  }
}
