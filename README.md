# Collections

Collections serves the GOV.UK navigation pages and organisation pages. Search API is used to make the pages dynamic e.g. the latest changes for Topics, Organisations and Mainstream browse pages.

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

This is a public facing Ruby on Rails application that retrieves browse content from APIs and presents it.

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

Collections Organisations API has a pact with [GDS API Adapters](https://github.com/alphagov/gds-api-adapters).

See the [guidance on Pact testing](https://docs.publishing.service.gov.uk/manual/pact-broker.html) for how to run and modify the tests.

### Further documentation

- [Taxonomy pages](docs/taxonomy-pages.md)
- [Campaign pages](docs/campaign-pages.md)
- [API endpoints and consumers](docs/api.md)

## License

[MIT License](LICENCE.txt)
