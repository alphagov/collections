class OrganisationsController < ApplicationController
  attr_reader :content_item
  def index
    @content_item = ContentItem.find!("/government/organisations").to_hash
    @content = organisations_list
  end

  def organisations_list
    [{
         title: "Attorney General's Office",
         public_updated_at: "2018-04-04T09:11:52Z",
         department_type: "Ministerial",
         agencies: ["Crown Prosecution Service", "Government Legal Department", "Serious Fraud Office"],
         document_type: "finder",
         schema_name: "placeholder",
         base_path: "/government/organisations/attorney-generals-office",
         description: "Information from government departments, agencies and public bodies, including news, campaigns, policies and contact details.",
         api_path: "/api/content/government/organisations",
         content_id: "fde62e52-dfb6-42ae-b336-2c4faf068101",
         locale: "en",
         api_url: "https://www.gov.uk/api/content/government/organisations",
         web_url: "https://www.gov.uk/government/organisations",
         links: {}
     },
     {
         title: "Cabinet Office",
         public_updated_at: "2018-04-04T09:11:52Z",
         department_type: "Ministerial",
         document_type: "finder",
         agencies: ["Commonwealth Scholarship Commission in the UK", "Independent Commission for Aid Impact"],
         schema_name: "placeholder",
         base_path: "/government/organisations/cabinet-office",
         description: "Information from government departments, agencies and public bodies, including news, campaigns, policies and contact details.",
         api_path: "/api/content/government/organisations",
         content_id: "fde62e52-dfb6-42ae-b336-2c4faf068101",
         locale: "en",
         api_url: "https://www.gov.uk/api/content/government/organisations",
         web_url: "https://www.gov.uk/government/organisations",
         links: {}
     },
     {
         title: "Department for Business, Energy & Industrial Strategy",
         public_updated_at: "2018-04-04T09:11:52Z",
         department_type: "Non Ministerial",
         agencies: ["Crown Prosecution Service", "Government Legal Department", "Serious Fraud Office"],
         document_type: "finder",
         schema_name: "placeholder",
         base_path: "/government/organisations/department-for-business-energy-and-industrial-strategy",
         description: "Information from government departments, agencies and public bodies, including news, campaigns, policies and contact details.",
         api_path: "/api/content/government/organisations",
         works_with: ["Office of the Leader of the House of Lords", "Civil Service Commission"],
         content_id: "fde62e52-dfb6-42ae-b336-2c4faf068101",
         locale: "en",
         api_url: "https://www.gov.uk/api/content/government/organisations",
         web_url: "https://www.gov.uk/government/organisations",
         links: {}
     }]
  end
end
