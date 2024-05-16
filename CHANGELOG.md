## Unreleased

- Modernize code and require ruby-3.2 or newer.
- Allow using keyword arguments as the additional parameters.

## [1.0.0] - 2020-02-24

- Remove `Burgundy::Item.map`.

## [0.6.0] - 2020-02-08

- Allow initializing `Burgundy::Item` without passing a delegating object.

## [0.5.0] - 2019-12-10

- Add `Burgundy::Item#to_json(*)`.

## [0.4.0] - 2019-12-10

- Add `Burgundy::Item#as_json(*)`, which returns `Burgundy::Item#attributes`.

## [0.3.0] - 2018-12-26

- Stop using `Delegator` and use `method_missing` instead.

## [0.2.0] - 2015-10-14

### Added

- `Burgundy::Collection` and `Burgundy::Item.wrap` now delegates additional
  arguments to `Burgundy::Item#initialize`.

## [0.1.0] - 2015-02-20

### Added

- Add `Burgundy::Item#attributes`. Now is possible to easily collect attributes
  as a hash.

### Changed

- Required Ruby version is now 2.1+.

## [0.0.4] - 2015-01-29

### Added

- `Burgundy::Collection` now includes `Enumerable`.

## [0.0.3] - 2014-07-05

### Changed

- `Burgundy::Item.wrap` always return a `Burgundy::Collection` instance.

## [0.0.2] - 2014-07-05 [YANKED]

### Added

- Add `Burgundy::Collection#empty?`.

### Changed

- `Burgundy::Collection#initialize` doesn't require a wrapping class anymore.
  This makes ActiveRecord collections easier to work.

## [0.0.1] - 2013-10-24

- Initial release.
