# GitHub Actions dashboard

This tool generates a dashboard that shows live status of all GitHub Action
workflows in a given set of GitHub repositories.

The [`generate.sh`](./generate.sh) script can read input files that contain
single line records of GitHub repositories, scan all workflows listed in
`.github/workflows` and generate a Markdown file that shows the current status
of each workflow.

## Usage

```sh
generate.sh [-h] -o OUTFILE [-i FILE]...

    -h  display this help
    -i  input file path
    -o  output markdown file path
```

You can provide multiple input files. The input file value can be a local file
path or an http(s) URL.

Input files must have a GitHub repository name per line that follows the syntax
`<user-or-org>/<repo>`.

Lines beginning with `#` are treated as comments.

## Auto-regenerate

You can use a [github-workflow like
this](.github/workflows/check-for-workflows.yml) that runs the generate script
every day to see if any workflow files have been added/removed from the repositories
listed in the input files.

## How to use

- Fork this repository
- Edit the sample input to list your repositories or create an input file or
  point to to your list of repositories elsewhere
- Run the generate script with the required options
- Edit
  [`.github/workflows/check-for-workflows.yml`](.github/workflows/check-for-workflows.yml)
  to run `generate.sh` with your command options in the `Generate` step.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## Security

Please read [SECURITY.md](SECURITY.md) for details on our security policy and how to report security vulnerabilities.

## Code of Conduct

Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for details on our code of conduct.

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file.
