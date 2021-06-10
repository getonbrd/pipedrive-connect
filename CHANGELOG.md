# Changelog

This file contains all notable changes to this project.
This project adheres to [Semantic Versioning](http://semver.org/).
This change log follows the conventions of [keepachangelog.com](http://keepachangelog.com/).

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
