# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2022-04-23

### Added

- Updated documentation

## [0.2.1] - 2020-05-11

### Fixed

- Removed anonymous function support as anonymous functions can't be used as module attributes (this happens during macro expansion in Plug.Builder)

## [0.2.0] - 2020-04-20

### Added

- The following predicates have been added: EnvVarIn, EnvVarNotIn, AppConfigIn, AppConfigNotIn

### Changed

- Documentation for "in" style predicates

## [0.1.1] - 2019-12-21

### Added

- Documentation and bumped test coverage

### Fixed

- Bug in RequestHeaderEquals predicate

## [0.1.0] - 2019-12-21

### Added

- Initial release of Unplug
