workflow "Lint all Dockerfiles" {
  on = "push"
  resolves = ["Haskell Dockerfile Linter"]
}

action "Haskell Dockerfile Linter" {
  uses = "docker://cdssnc/docker-lint-github-action"
  # https://github.com/hadolint/hadolint/wiki/DL3008
  # https://github.com/hadolint/hadolint/wiki/DL3013
  # https://github.com/hadolint/hadolint/wiki/DL3016
  # https://github.com/hadolint/hadolint/wiki/DL3018
  args = "--ignore DL3008 --ignore DL3013 --ignore DL3016 --ignore DL3018"
}
