## [unreleased]

- `Burgundy::Collection` and `Burgundy::Item.wrap` now delegates additional arguments to `Burgundy::Item#initialize`.

## [0.1.0] - 2015-02-20

### Added

- Add `Burgundy::Item#attributes`. Now is possible to easily collect attributes as a hash.

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

- `Burgundy::Collection#initialize` doesn't require a wrapping class anymore. This makes ActiveRecord collections easier to work.

## [0.0.1] - 2013-10-24

- Initial release.
