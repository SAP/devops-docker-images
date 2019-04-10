workflow "Lint all Dockerfiles" {
  on = "push"
  resolves = ["Linter"]
}

action "Linter" {
  uses = "docker://cdssnc/docker-lint-github-action"
  args = ""
}
