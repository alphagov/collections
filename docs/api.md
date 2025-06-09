# Collections API

Collections serves the [organisations API](https://www.gov.uk/api/organisations).
This used to be served by Whitehall but it was migrated with organisation pages.

## Endpoints

[`/api/organisations`](https://www.gov.uk/api/organisations) ([client](https://github.com/alphagov/gds-api-adapters/blob/52d5d97e9b5822462bb533944666b02a1596bed1/lib/gds_api/organisations.rb#L4-L6))

Lists organisations. Includes title, status and relationships to other orgs.

[`/api/organisations/:slug`](https://www.gov.uk/api/organisations/attorney-generals-office) ([client](https://github.com/alphagov/gds-api-adapters/blob/52d5d97e9b5822462bb533944666b02a1596bed1/lib/gds_api/organisations.rb#L8-L10))

Shows the details for a single organisation.

## Consumers

Please [add your application to this list](https://github.com/alphagov/collections/edit/main/docs/api.md) if you're using the API.

`/api/organisations`
- [Government organisations on GOV.UK register](https://www.registers.service.gov.uk/registers/government-organisation)
- [GOV.UK Forms Admin](https://github.com/alphagov/forms-admin/commit/6adafe95018be8559efdd47bce7a9ee6f60476cf)
- [Manuals publisher](https://github.com/alphagov/manuals-publisher/blob/90821bd6cec6613442287b85c7be4ef3c593c761/lib/services.rb#L20)
- [Short URL manager](https://github.com/alphagov/short-url-manager/blob/9d607b4e7008d1a3243a1877259ab6e800b869d3/app/services/organisation_importer.rb#L27)
- [Signon](https://github.com/alphagov/signon/blob/53302a17ccfedca9914d15937a040d6b586dbebd/lib/organisations_fetcher.rb#L24)
- [Support API](https://github.com/alphagov/support-api/blob/e6f4b9db213c6dd7b75aef832f12bf1da7070d4d/lib/organisation_importer.rb#L67)
- [Transition](https://github.com/alphagov/transition/blob/v50/lib/transition/import/whitehall_orgs.rb#L51)
