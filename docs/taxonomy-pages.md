# Taxonomy

The taxonomy is surfaced on taxon pages, which group together tagged content for that level of the taxonomy into [supergroups](https://docs.publishing.service.gov.uk/document-types/content_purpose_supergroup.html) on the page, e.g: Guidance and Regulation for Funding and finance for students [gov.uk/education/funding-and-finance-for-students](https://www.gov.uk/education/funding-and-finance-for-students). Each taxon page also shows a grid of sub-topics at the next level of the taxonomy.

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

