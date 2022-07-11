# Changelog

This file contains all notable changes to this project.
This project adheres to [Semantic Versioning](http://semver.org/).
This change log follows the conventions of [keepachangelog.com](http://keepachangelog.com/).

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
