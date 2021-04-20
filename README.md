# Collections

Collections serves the GOV.UK navigation pages and organisation pages.

At time of writing, it also serves the priority campaign pages. See the [Campaign pages](docs/campaign-pages.md) manual for more details.

## Live examples

- Browse page: [gov.uk/browse](https://www.gov.uk/browse)
- Topic page: [gov.uk/oil-and-gas](https://www.gov.uk/oil-and-gas)
- Subtopic page: [gov.uk/oil-and-gas/fields-and-wells](https://www.gov.uk/oil-and-gas/fields-and-wells)
- Services and information page: [gov.uk/government/organisations/hm-revenue-customs/services-information](https://www.gov.uk/government/organisations/hm-revenue-customs/services-information)
- Taxonomy page: [gov.uk/education](https://www.gov.uk/education)
- Worldwide taxonomy page: [gov.uk/world/japan](https://www.gov.uk/world/japan)
- Organisation index page: [gov.uk/government/organisations](https://www.gov.uk/government/organisations)
- Organisation page: [gov.uk/government/organisations/cabinet-office](https://www.gov.uk/government/organisations/cabinet-office)
- Step by step page: [gov.uk/learn-to-drive-a-car](https://www.gov.uk/learn-to-drive-a-car)

## Nomenclature

### Topics

- **Curated list**: a group of content tagged to a subtopic that has been
  curated into a named list.
- **Topic**: a named group of sub-topics. (A deprecated name for this is "specialist sector".)
- **Sub-topic**: a group of content within a topic. (A deprecated name for this is
"specialist sub-sector".)

## Technical documentation

This is a public facing Ruby on Rails application that retrieves browse content from APIs and presents it. There is no underlying persistence layer, and (with the exception of the [campaign pages](#campaign-pages)) all content is retrieved from external sources.

### Dependencies

- [content-store](https://github.com/alphagov/content-store), provides:
    - Mainstream browse pages (Root, Top and Second level browse pages)
    - Topics
    - Subtopics and their curated lists
- [search api](https://github.com/alphagov/search-api), provides:
    - latest changes for Topics
    - content tagged to a particular Topic, Mainstream browse page or Organisation
- [email-alert-api](https://github.com/alphagov/email-alert-api), provides:
    - support for subscribing to notifications from a topic

### Running the application

- #### With startup scripts

```
./startup.sh
```

The app should start on http://localhost:3070

```
./startup.sh --live
```

This will run the app and point it at the production GOV.UK `content-store` and `static` instances.

```
./startup.sh --dummy
```

This will run the app and point it at the [dummy content store](https://govuk-content-store-examples.herokuapp.com/), which serves the content schema examples and random content.

- #### With govuk-docker

Once you have installed [govuk-docker](https://github.com/alphagov/govuk-docker#installation), do the following
```
> cd govuk/govuk-docker
> git pull origin master
> make collections

> cd govuk/collections
> govuk-docker-up
```

Collections will be running locally at collections.dev.gov.uk.

### Running the test suite

Use `bundle exec rake` to run the test suite, excluding JavaScript. Or if you are running in docker, `govuk-docker-run bundle exec rake`

To test a single file:

`govuk-docker-run bundle exec rails test test/unit/application_helper_test.rb`

#### Javascript tests

Use `bundle exec rake jasmine:ci` to run Jasmine tests

### Pact tests
Collections Organisations API has pact tests with [gds-api-adapters](https://github.com/alphagov/gds-api-adapters/blob/19515f01395a2a2cdfa22e1c86f8cb1a4298c492/test/test_helpers/pact_helper.rb).

Use `bundle exec rake pact:verify` to run the pact tests against the master pactfile stored on the pact broker.

If you have made a change to the code that consumes the organisations api, you might want to confirm that collections will still honour its pact. You can do so by running the pact tests against your local gds-api-adapters branch like so:
- From gds-api-adapters run `bundle exec rake` to regenerate a new pactfile on you local machine.
- From collections run `bundle exec rake PACT_URI="../gds-api-adapters/spec/pacts/gds_api_adapters-collections_organisation_api.json" pact:verify`

### Further documentation

- [Taxonomy pages](docs/taxonomy-pages.md)
- [Campaign pages](docs/campaign-pages.md)
- [API endpoints and consumers](docs/api.md)

## License

[MIT License](LICENCE.txt)
