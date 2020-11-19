# Changelog

## [1.7.0] - 2020-11-08

### Changed

- Update Compi version to 1.3.7.

## [1.6.0] - 2020-11-07

### Changed

- Update Compi version to 1.3.6.

## [1.5.0] - 2020-11-04

### Added

- Check if the input files have the minimum number of sequences.

### Fixed

- Fix the prepare trees for codeML step to avoid issues with concurrent seds on the same directory. This is because it was noticed that using a high number of concurrent Compi tasks (e.g. 50) caused some trees to not be created without any obvious reason. However, they were created when running only the foreach tasks for only those files.
- Fix a bug when checking FUBAR errors to remove files from the codeML run list.

## [1.4.0] - 2020-10-27

### Changed

- Update Compi version to 1.3.5.

## [1.3.0] - 2020-10-26

### Added

- Now the rename headers script produces also renaming files containing the mappings from the original sequence headers. This allows users of the  pipeline to know exactly the names of the sequences in intermediate renamed files that can be produced by the  pipeline.

### Changed

- Update Compi version to 1.3.4.

## [1.2.0] - 2020-09-09

### Changed

- Update Compi version to 1.3.0.
- Use binded foreachs.

## [1.1.1] - 2020-01-09

### Changed

- Update Compi version to 1.2.0.

## [1.1.0] - 2019-12-19

### Changed

- Update paml version to 4.9j.

## [1.0.0] - 2019-08-07

### Added

- First public release of the pipeline.
