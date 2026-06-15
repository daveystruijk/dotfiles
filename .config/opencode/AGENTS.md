# Testing

To verify your work, it is often useful to run the pre-commit checks as well.

# Projects in ~/momo

When working with projects in ~/momo, here is some additional context:

- For repositories with a contract and/or client package, it is often required to run `yarn build` in the root for updates to the contract/client to propagate to the rest of the packages.
- There is a package at ~/momo/momo-local-stack/ that allows you to run the entire stack spanning multiple projects in ~/momo.
  - Read the docs and infer usage from it, but use docker directly instead of running the scripts.
  - Use it to test assumptions using the docker logs, but also to verify changes using the browser tool.
