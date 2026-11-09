## [Unreleased]

## [1.1.4] - 2025-07-11

### Added

- `snfoil:serializer` generator, which scaffolds a plain serializer class with Blueprinter and Alba examples, since SnFoil no longer ships a serializer.
- `snfoil:deserializer` generator.

### Changed

- The `snfoil:controller` template inherits from `SnFoil::Rails::APIController` and uses `<Model>Serializer` and `<Model>Deserializer`.
- The `snfoil:context` template includes `SnFoil::CRUD::Context` and shows how to override its hooks or add actions.
- The `snfoil:searcher` template includes `SnFoil::Rails::Searcher`.
- The `snfoil:policy` template shows `permission` examples.

### Removed

- `snfoil:jsonapi_serializer` and `snfoil:jsonapi_deserializer` generators, replaced by `snfoil:serializer` and `snfoil:deserializer`.

## [1.1.2] - 2025-06-11

### Fixed

- Generators register as `snfoil:*` (for example `rails generate snfoil:all User`), matching the documentation. They previously registered as `sn_foil:*` and could not be run. ([#15](https://github.com/limited-effort/snfoil-rails/pull/15))
- `snfoil:all --skip-model` skips generating the model. ([#15](https://github.com/limited-effort/snfoil-rails/pull/15))

## [1.1.1] - 2025-04-25

### Changed

- `SnFoil::Rails::API::Destroy#render_destroy` responds to a successful destroy with `render status: :no_content` instead of `render json: {}, status: :no_content`. In a controller that inherits from `ActionController::Base` (rather than `ActionController::API`), this looks up a `destroy` template and raises `ActionView::MissingTemplate`. Override `render_destroy` to call `head :no_content` in that case.
- Require Ruby 3.0 or newer (previously 2.6).

## [0.1.0] - 2021-09-26

- Initial release
