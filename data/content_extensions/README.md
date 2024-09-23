# Content Extensions

These are hardcoded extensions to the content items returned from content-store.

Hardcoding these allows us to experiment with the structure of the page and the components on the page, without having
to continuously tweak the publishing system.

Eventually, these extensions should either be provided by content-store itself, or removed.

## Similar past approaches

For previous pages with significant hardcoded content, we've used locale files. For example, see

```
git log -- config/locales/en/coronavirus_landing_page.yml
```

... for a history of the changes we made to the coronavirus landing page.

This approach works fine, but it doesn't align as closely with the way the publishing system works.

## Structure

Each subdirectory name is the content_id of some page rendered by collections. Inside each directory
is a list of numbered YAML files. Each YAML file will be added to the "links.content_extensions" field
of the content item by collections when it loads the item. The files will appear in the same order as
they do in the directory (so they can be reordered by changing their numbers).
