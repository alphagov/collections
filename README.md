# Collections Frontend

Collections serves the GOV.UK navigation pages,

![Browse page](docs/browse-page.jpg)
![Topic page](docs/topic-page.jpg)
![Subtopic page](docs/subtopic-page.jpg)
![Services and information page](docs/services-and-information-page.jpg)
![Taxonomy page](docs/taxonomy-page.jpg)

(As of June 2015)

## Live examples

- Browse page: [gov.uk/browse](https://www.gov.uk/browse)
- Topic page: [gov.uk/oil-and-gas](https://www.gov.uk/oil-and-gas)
- Subtopic page: [gov.uk/oil-and-gas/fields-and-wells](https://www.gov.uk/oil-and-gas/fields-and-wells)
- Services and information page: [gov.uk/government/organisations/hm-revenue-customs/services-information](https://www.gov.uk/government/organisations/hm-revenue-customs/services-information)
- Taxonomy page: [gov.uk/education](https://www.gov.uk/education)

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

### Taxonomy
The taxonomy is surfaced on taxon pages, which group together tagged content for that level of the taxonomy into supergroups on the page, e.g: Guidance and Regulation for Funding and finance for students [gov.uk/education/funding-and-finance-for-students](https://www-origin.integration.publishing.service.gov.uk/education/funding-and-finance-for-students). Each taxon page also shows a grid of sub-topics at the next level of the taxonomy.

The world taxonomy is surfaced slightly differently:
- **Taxon without grandchildren**: a content item of type taxon that has
  `child_taxons` links. None of those child taxons' links have `child_taxons`,
  in which case we display an accordion view:
  [gov.uk/world/afghanistan](https://www-origin.integration.publishing.service.gov.uk/world/afghanistan)
- **Taxon with associated taxons**: a content item of type taxon that has
  `associated_taxons` links. In this case the tagged content of the taxon will
  include content that is directly tagged to it and also content that has been
  tagged to any of the associated taxons.


## Technical documentation

This is a public facing Ruby on Rails application that retrieves browse content from APIs and presents it.
There is no underlying persistence layer and all content is retrieved from external sources.

### Whitehall email and feed links for World Locations

A special case exists within Collections to allow email links on Taxon pages to be generated
such that they point to the email subscription logic in Whitehall. This is
currently implemented in `app/helpers/email_helper.rb` with the branching logic
sitting in `app/views/taxons/_email_alerts.html`.

The intention is to migrate rendering of World Location pages from Whitehall to
Collections. Whitehall serves these from `/government/world/{world_location}`.
Collections will serve these from `/world/{world_location}`.

The helper currently tests for `base_path` starting with `/world` and provides two methods;
one to create an atom link and one to create an email link.

Once email subscriptions for World Locations have been completely ported to use
Email Alert Api, this functionality can be removed.

### Content for taxon pages

Content for taxon pages is returned by a search in Rummager based on content_ids.

### Dependencies

- [content-store](https://github.com/alphagov/content-store), provides:
    - Mainstream browse pages (Root, Top and Second level browse pages)
    - Topics
    - Subtopics and their curated lists
- [rummager](https://github.com/alphagov/rummager), provides:
    - latest changes for Topics
    - content tagged to a particular Topic, Mainstream browse page or Organisation
- [email-alert-api](https://github.com/alphagov/email-alert-api), provides:
    - support for subscribing to notifications from a topic

### Running the application

```
./startup.sh
```

The app should start on http://localhost:3070 or
http://collections.dev.gov.uk on GOV.UK development machines.

```
./startup.sh --live
```

This will run the app and point it at the production GOV.UK `content-store` and `static` instances.

```
./startup.sh --dummy
```

This will run the app and point it at the [dummy content store](https://govuk-content-store-examples.herokuapp.com/), which serves the content schema examples and random content.


### Running the test suite

Use `bundle exec rake` to run the test suite, excluding JavaScript

#### Javascript tests

Use `bundle exec rake spec:javascript` to run Jasmine tests
Alternatively, visit [`collections.dev.gov.uk/specs`](http://collections.dev.gov.uk/specs)
for a live debugger in your browser

## License

[MIT License](LICENCE.txt)
