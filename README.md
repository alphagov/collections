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

This is a Ruby on Rails app, and should follow [our Rails app conventions](https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html).

You can use the [GOV.UK Docker environment](https://github.com/alphagov/govuk-docker) or the local `startup.sh` script to run the app. Read the [guidance on local frontend development](https://docs.publishing.service.gov.uk/manual/local-frontend-development.html) to find out more about each approach, before you get started.

If you are using GOV.UK Docker, remember to combine it with the commands that follow. See the [GOV.UK Docker usage instructions](https://github.com/alphagov/govuk-docker#usage) for examples.

### Running the test suite

```
bundle exec rake
```

To test a single file:

```
bundle exec rails test test/unit/application_helper_test.rb
```

To run JavaScript tests (only):

```
bundle exec rake jasmine
```

### Pact tests

Collections Organisations API has a pact with [GDS API Adapters](https://github.com/alphagov/gds-api-adapters).

See the [guidance on Pact testing](https://docs.publishing.service.gov.uk/manual/pact-broker.html) for how to run and modify the tests.

### Further documentation

- [Taxonomy pages](docs/taxonomy-pages.md)
- [Campaign pages](docs/campaign-pages.md)
- [API endpoints and consumers](docs/api.md)

## License

[MIT License](LICENCE.txt)
