# Changelog

This file contains all notable changes to this project.
This project adheres to [Semantic Versioning](http://semver.org/).

This change log follows the conventions of [keepachangelog.com](http://keepachangelog.com/).

## [2.1.0] - 2025-01-16

### Added
- New `use_fields_version` method in Fields module to override API version specifically for fields operations
- Fields-specific version override functionality that allows resources to use different API versions for fields vs general operations
- `fields_api_version` method to query the fields-specific API version

### Changed
- Activity resource now uses `use_fields_version :v1` instead of `use_version :v1` to override version only for fields operations
- Activity general operations now use v2 API while fields operations continue to use v1 API as required by Pipedrive

## [2.0.1] - 2025-04-17

- Fix bugs introduced with version 2 where the base URL for v1 was broken.
- Add GitHub Actions workflow
## [2.0.0] - 2025-04-11

- **BREAKING change**: Minimum ruby version updated to 2.7.
- Added options for using new V2 API endpoints. Resource `Pipedrive::Activity` switched to new V2 endpoint.
- Documentation updates with information on V1/V2 API endpoint switching.

## [1.3.1] - 2023-06-01

- **BREAKING change**: Generated `delete_*` method has been refactored to receive the `id` of the record to be dettached or deleted - instead of the resource per se -, for instance: `deal.delete_product(attached_product_id)`. This is because the API behaves different depending on the endpoint, like in case of `#DELETE /deals/{id}/products/{product_attachment_id}` that receives an id corresponding to the attachment id (not a product, but a different record).

## [1.3.0] - 2023-04-17

- Modify `has_many` to generate methods to `add` and `delete` resources. ie. `add_participant`, `add_product`, `delete_product`
- Add `Pipedrive::Participant` resource and add the association to `Pipedrive::Deal`
- BREAKING CHANGE: Removed `delete_attached_product` in favor of `delete_product` passing a hash of params instead of an instance of `Pipedrive::Resource`
- BREAKING CHANGE: `add_product` changed method signature because of the changes introduced in `has_many`

## [1.2.14] - 2023-01-31

- The codebase paginates until fetching all the fields so the diccionary of custom fields is complete (checkout `lib/pipedrive/fields` for more info)

## [1.2.13] - 2022-12-08

- Update `LeadLabel` resource to use _PATCH_ method (as according to the API doc)

## [1.2.12] - 2022-12-08

- Add the capability to override the HTTP method used to update a resource
- Update `Lead` resource to use _PATCH_ method (as according to the API doc)

## [1.2.11] - 2022-11-21

- Added `find` method for user to work for the `find` endpoint of the Pipedrive API

## [1.2.10] - 2022-10-19

- Implement `empty?` (or `no_content?`) method on all the models when the response is No content (204 HTTP code)
- Add option to treat 204 HTTP code (No Content) as 404 HTTP code (Not found)

## [1.2.9] - 2022-10-13

- Add `find_by_deal` method to `Subscription`to allow finding of subscriptions by `deal_id`.

## [1.2.8] - 2022-10-11

- Add the new resource `Pipedrive::OrganizationField`
- Add activities (as a `has_many` relationship) to `Pipedrive::Person`
- Provide better error information also maping the status code to a class according to https://pipedrive.readme.io/docs/core-api-concepts-http-status-codes (check lib/pipedrive/errors.rb)

## [1.2.7] - 2022-09-23

- Add `Subscription` resource with additional `create_recurring`, `update_recurring` and `cancel_recurring` methods.
- Changed faraday dependency to allow more flexibility

## [1.2.6] - 2022-07-11

- Add `delete_attached_product` method to `Deal`
- Add metadata to `has_many` relations that store the returned _data_(API) without transformation, as it is.

## [1.2.5] - 2022-03-03

- Add `deals` to `Person`

## [1.2.4] - 2021-09-13

- Add `Pipedrive.debug_http_body`for debugging the http payload
- Fix bugs with `POST`/`PUT` endpoints

## [1.2.3] - 2021-09-10

- Add `Pipedrive.debug` so basic debug info is not displayed out of the box.
- Add `Pipedrive.debug_http` for debugging http traffic.
- Fix bug in some resources when no fields filtering was provided.

## [1.2.2] - 2021-05-11

- Fix bug introduced by v1.2.0 where `has_many` removed the chance to pass extra parameters.

## [1.2.1] - 2021-05-10

- Some endpoints like `deals/:id/products` allow to expand the response with `include_product_data` that include an attr `product` with all the data - including the custon fields - of the products. The deafult for that option is `false` or `0`. I personally think this is redundant, so this version overrides this behavior by passing `true` or `1` and deleging the attr `product` by merging its content with the body itself, at the end `/products` should return `products`. On future versions this option would be passed to the `has_many` method, like `has_many :products, class_name: "Product", include_data: false`

## [1.2.0] - 2021-06-05

- Add Lead, LeadLabel, LeadLabel and Goal models.

## [1.1.0] - 2020-09-07

- Add capability to merge organizations, people and deals. See [the doc here](https://developers.pipedrive.com/docs/api/v1/#!/Organizations/put_organizations_id_merge).

## [1.0.1] - 2020-07-07

- Fixes unitialized constant error when the class_name within has_many definition doesn't contain the namespace

## [1.0] - 2020-06-25

- Initial release
