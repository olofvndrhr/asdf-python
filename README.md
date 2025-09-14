<div align="center">

# asdf-python [![Build](https://github.com/olofvndrhr/asdf-python/actions/workflows/build.yml/badge.svg)](https://github.com/olofvndrhr/asdf-python/actions/workflows/build.yml) [![Lint](https://github.com/olofvndrhr/asdf-python/actions/workflows/lint.yml/badge.svg)](https://github.com/olofvndrhr/asdf-python/actions/workflows/lint.yml)

[python](https://www.python.org/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`
- `curl`
- `tar`
- `gzip`
- [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add python
# or
asdf plugin add python https://github.com/olofvndrhr/asdf-python.git
```

python:

```shell
# Show all installable versions
asdf list-all python

# Install specific version
asdf install python latest

# Set a version globally (on your ~/.tool-versions file)
asdf set --home python latest

# Now python commands are available
python --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/olofvndrhr/asdf-python/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Ivan Schaller](https://github.com/olofvndrhr/)
