workflow "hadolint action" {
  on = "pull_request"
  resolves = ["hadolint on pr"]
}

action "hadolint on pr" {
  uses = "burdzwastaken/hadolint-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HADOLINT_ACTION_DOCKERFILE_FOLDER = "./cf-cli"
  }
}
