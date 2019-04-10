workflow "Lint all Dockerfiles" {
  on = "push"
  resolves = ["Haskell Dockerfile Linter"]
}

action "Haskell Dockerfile Linter" {
  uses = "docker://cdssnc/docker-lint-github-action"
  args = ""
}
