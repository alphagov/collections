# Collections Frontend

Collections serves the GOV.UK browse and topic pages.

![Browse page](docs/browse-page.jpg)
![Topic page](docs/topic-page.jpg)
![Subtopic page](docs/subtopic-page.jpg)

(As of June 2015)

## Live examples

- Browse page: [gov.uk/browse](https://www.gov.uk/browse)
- Topic page: [gov.uk/oil-and-gas](https://www.gov.uk/oil-and-gas)
- Subtopic page: [gov.uk/oil-and-gas/fields-and-wells](https://www.gov.uk/oil-and-gas/fields-and-wells)

## Nomenclature

### Topics

- **Curated list**: a group of content tagged to a subtopic that has been
  curated into a named list.
- **Topic**: a named group of sub-topics. (A deprecated name for this is "specialist sector".)
- **Sub-topic**: a group of content within a topic. (A deprecated name for this is
"specialist sub-sector".)

### Browse pages

- **Root browse page**: [gov.uk/browse](https://www.gov.uk/browse)
- **Top level browse page**: [gov.uk/browse/benefits](https://www.gov.uk/browse/benefits)
- **Second level browse page**: [gov.uk/browse/benefits/entitlement](https://www.gov.uk/browse/benefits/entitlement)

## Technical documentation

This is a public facing Ruby on Rails application that retrieves browse content from APIs
and presents it.
There is no underlying persistence layer and all content is
retrieved from external sources.

### Dependencies

- [alphagov/content-store](https://github.com/alphagov/content-store) -
  provides subtopics and their curated lists.
- [alphagov/rummager](https://github.com/alphagov/rummager) -
  provides Latest changes content.
- [alphagov/email-alert-api](https://github.com/alphagov/email-alert-api) -
  provides support for subscribing to notifications from a topic.

### Running the application

`bundle exec rails server`

### Running the test suite

Use `bundle exec rake` to run the full test suite

## License

[MIT License](LICENCE.txt)
