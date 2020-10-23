# Update COVID Local Restriction Data

### Very brief description of how the checker works

- The postcode checker makes calls to Mapit to get information about the submitted postcode.
- The Mapit response contains `areas` that contain `GSS` codes for the postcode.
- We select the GSS code for the lower tier local authority of the areas returned.
- We then use the GSS code to query our local restriction YAML [data](https://github.com/alphagov/collections/blob/master/lib/local_restrictions/local-restrictions.yaml) to figure out which restriction the `GSS` code is under.

### How to update the local restriction data

[Here is an example PR!](https://github.com/alphagov/collections/pull/2009/files)

In order to update the local restriction data, you will need to be given the `GSS` codes and new alert levels of the places for which restrictions are changing.

You will also be told the time and date at which the alert levels will change.

We display both the current and upcoming restrictions to a user IF we have upcoming restrictions for their postcode.

![Image of results page with changing alert level](docs/alert-level-changing.png)

Otherwise we just display the current restrictions. This is determined by the `start_date` and `start_time`.

![Image of results page without changing alert level](docs/alert-level-no-upcoming-changes.png)

Example of somewhere that just has current restrictions:

```
E08000012:
  name: Liverpool City Council
  restrictions:
    - alert_level: 3
      start_date: 2020-10-12
      start_time: "00:01"
```

Example of somewhere with current and upcoming restrictions:

```
E08000010:
  name: Wigan Borough Council
  restrictions:
    - alert_level: 2
      start_date: 2020-10-12
      start_time: "00:01"
    - alert_level: 3
      start_date: 2020-10-23
      start_time: "00:01"
```

To update the restriction data, you will need to [add a list to the YAML](https://github.com/alphagov/collections/blob/master/lib/local_restrictions/local-restrictions.yaml) for the given GSS codes that contain:

- the new `alert_level`.
- the `start_date` for when the restrictions will be introduced.
- the `start_time` for when the restrictions will be introduced.

This should look similar to the `Wigan Borough Council` example above (aka as a new entry nested under `restrictions`, *not* over writing what is currently there).

If the GSS code **does not already exist** in the file then you will need to add it.

The `name` is just a human-readble description to make it easier to find existing entries in the YAML file. It is not displayed to users. 

### Test and deploy

Make sure that you run the existing tests using `bundle exec rake`.

Please also run the app locally (or push to integration as Mapit can take time to set up!) to check that there are no mistakes in the format of the YAML that are causing the application to crash! The path is `/find-coronavirus-local-restrictions`. We will add a schema eventually... but for now this is important to do!

Another developer will need to check and approve the changes.

Once merged, the changes will be deployed via continuous integration.
