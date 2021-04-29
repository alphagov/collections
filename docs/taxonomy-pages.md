# Taxonomy

Content for taxon pages is returned by Search API based on:

- `content_id`s for world taxon pages; and
- `content_id`s and [supergroups](https://docs.publishing.service.gov.uk/document-types/content_purpose_supergroup.html) for topic taxon pages.

## Topic Taxonomy

A taxon page divides the content tagged to the taxon by its [supergroup](https://docs.publishing.service.gov.uk/document-types/content_purpose_supergroup.html) e.g: Guidance and Regulation for Funding and finance for students [gov.uk/education/funding-and-finance-for-students](https://www.gov.uk/education/funding-and-finance-for-students). Each taxon page also shows a grid of sub-topic taxons at the next level of the taxonomy.

## Worldwide taxonomy

The worldwide taxonomy is rendered on different types of pages depending on whether the taxon has any children.

For example:

- **Taxon with children**: a content item of type taxon that has
  `child_taxons` links. None of those child taxons' links have `child_taxons`,
  in which case we display an accordion view:
  [gov.uk/world/afghanistan](https://www.gov.uk/world/afghanistan)
- **Taxon without children**: a content item of type taxon that doesn't have
  `child_taxons` links. In this case we display an leaf view:
  [gov.uk/world/living-in-afghanistan](https://www.gov.uk/world/living-in-afghanistan)
- **Taxon with associated taxons**: a content item of type taxon that has
  `associated_taxons` links. In this case the tagged content of the taxon will
  include content that is directly tagged to it and also content that has been
  tagged to any of the associated taxons.

