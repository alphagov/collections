Analytics
=========

To improve the content navigation experience, we track user behaviour in Google
Analytics.

What is tracked
---------------

In addition to the default page view tracking that occurs on every page
of GOV.UK, we have added additional tracking to collections.

There are three kinds of tracking:

- Enhanced Ecommerce: Provided by [static](https://github.com/alphagov/static/blob/master/app/assets/javascripts/analytics/ecommerce.js); provides analytics on views (impressions) and clicks of lists of items.
- Event tracking: tracks usage of features such as facets.
- Page view tracking: tracks each the state of the page when it first loads, or when new page content is added.

## Testing analytics

For Enhanced Ecommerce, the tracking functionality is tested in static.

We have feature tests to check the correct attributes are used in
[`features/analytics.feature`](features/analytics.feature).
