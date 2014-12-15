# Collections

Collections contains specialist browse functionality for GOV.UK. In the future,
it will become the location for all browse pages, faceted lists, and search.

## Live examples

 - [gov.uk/browse](https://www.gov.uk/browse)

## Nomenclature

- **Curated list**: a group of content tagged to a subtopic that has been
  curated into a named list.
- **Subtopic**: a group of related content associated to a topic.
- **Specialist sector (currently topic)**: a group of content associated to a
  specialised sector/topic.

## Technical documentation

This is a public facing Ruby on Rails application that retrieves browse content from APIs
and presents it.
There is no underlying persistence layer and all content is
retrieved from external sources.

### Dependencies

- [alphagov/govuk_content_api](https://github.com/alphagov/govuk_content_api) -
  provides Specialist sector and subcategory content.
- [alphagov/whitehall](https://github.com/alphagov/whitehall) -
  provides Detailed guidance content.
- [alphagov/collections-api](https://github.com/alphagov/collections-api) -
  provides Curated lists and Latest changes content.
- [alphagov/email-alert-api](https://github.com/alphagov/email-alert-api) -
  provides support for subscribing to notifications from a topic.

### Running the application

`bundle exec rails server`

### Running the test suite

Use `bundle exec rake` to run the full test suite

## License

[MIT License](LICENCE)
