RSpec.describe Schemas::HowTo do
  describe "#structured_data" do
    it "generates structured data using the HowTo schema" do
      content_item = GovukSchemas::Example.find("step_by_step_nav", example_name: "learn_to_drive_a_car")
      step_by_step = StepNav.new(ContentItem.new(content_item))
      view_context = ApplicationController.new.view_context
      how_to = Schemas::HowTo.new(step_by_step, view_context)

      # Generated with:
      # puts JSON.pretty_generate(how_to.structured_data)
      expected = {
        "@context": "http://schema.org",
        "@type": "HowTo",
        "description": "Learn to drive a car in the UK - get a provisional licence, take driving lessons, prepare for your theory test, book your practical test.",
        "image": "/assets/collections/govuk_publishing_components/govuk-schema-placeholder-1x1-c3d38c0d4fc00005df38a71e1db7097276681d6917bca58f0dc8336a252e1bb3.png",
        "name": "Learn to drive a car: step by step",
        "step": [
          {
            "@type": "HowToStep",
            "image": "/assets/collections/step-1-f0c4380d0551bb7f36f3bbc335f966197e8e8d087f3c259301e71751788fe254.png",
            "name": "Check you're allowed to drive",
            "url": "http://www.test.gov.uk/learn-to-drive-a-car#check-you-re-allowed-to-drive",
            "position": 1,
            "itemListElement": [
              {
                "@type": "HowToDirection",
                "text": "Most people can start learning to drive when they’re 17.",
                "position": 1,
              },
              {
                "@type": "HowToDirection",
                "text": "Check what age you can drive",
                "position": 2,
                "url": "http://www.test.gov.uk/vehicles-can-drive",
              },
              {
                "@type": "HowToDirection",
                "text": "Requirements for driving legally",
                "position": 3,
                "url": "http://www.test.gov.uk/legal-obligations-drivers-riders",
              },
              {
                "@type": "HowToDirection",
                "text": "Driving eyesight rules",
                "position": 4,
                "url": "http://www.test.gov.uk/driving-eyesight-rules",
              },
            ],
          },
          {
            "@type": "HowToStep",
            "image": "/assets/collections/step-2-8e5828409d4c6ba90d46423ddd110a69d594c9a95050a853b92a6ee65b4e6438.png",
            "name": "Get a provisional driving licence",
            "url": "http://www.test.gov.uk/learn-to-drive-a-car#get-a-provisional-driving-licence",
            "position": 2,
            "itemListElement": [
              {
                "@type": "HowToDirection",
                "text": "Apply for your first provisional driving licence",
                "position": 1,
                "url": "http://www.test.gov.uk/apply-first-provisional-driving-licence",
              },
            ],
          },
          {
            "@type": "HowToStep",
            "image": "/assets/collections/step-3-464e7f5d4df65200b5595a01337c5d619f486fe307bbc58bacf279ab31f0c0ca.png",
            "name": "Driving lessons and practice",
            "url": "http://www.test.gov.uk/learn-to-drive-a-car#driving-lessons-and-practice",
            "position": 3,
            "itemListElement": [
              {
                "@type": "HowToDirection",
                "text": "You need a provisional driving licence to take lessons or practice.",
                "position": 1,
              },
              {
                "@type": "HowToDirection",
                "text": "The Highway Code",
                "position": 2,
                "url": "http://www.test.gov.uk/guidance/the-highway-code",
              },
              {
                "@type": "HowToDirection",
                "text": "Taking driving lessons",
                "position": 3,
                "url": "http://www.test.gov.uk/driving-lessons-learning-to-drive",
              },
              {
                "@type": "HowToDirection",
                "text": "Find driving schools, lessons and instructors",
                "position": 4,
                "url": "http://www.test.gov.uk/find-driving-schools-and-lessons",
              },
              {
                "@type": "HowToDirection",
                "text": "Practise vehicle safety questions",
                "position": 5,
                "url": "http://www.test.gov.uk/government/publications/car-show-me-tell-me-vehicle-safety-questions",
              },
            ],
          },
          {
            "@type": "HowToStep",
            "image": "/assets/collections/step-and-da0ea81ae330dafaf6f8beb2fe2f3875d68f718c4094627518ad6d3105205e28.png",
            "name": "Prepare for your theory test",
            "url": "http://www.test.gov.uk/learn-to-drive-a-car#prepare-for-your-theory-test",
            "position": 4,
            "itemListElement": [
              {
                "@type": "HowToDirection",
                "text": "Theory test revision and practice",
                "position": 1,
                "url": "http://www.test.gov.uk/theory-test/revision-and-practice",
              },
              {
                "@type": "HowToDirection",
                "text": "Take a practice theory test",
                "position": 2,
                "url": "http://www.test.gov.uk/take-practice-theory-test",
              },
              {
                "@type": "HowToDirection",
                "text": "Theory and hazard perception test app",
                "position": 3,
                "url": "https://www.safedrivingforlife.info/shop/product/official-dvsa-theory-test-kit-app-app",
              },
            ],
          },
          {
            "@type": "HowToStep",
            "image": "/assets/collections/step-4-d605649a9cda7e3b6bce802cdf7b564dd1e893da065bede6dd52285cae80a4ea.png",
            "name": "Book and manage your theory test",
            "url": "http://www.test.gov.uk/learn-to-drive-a-car#book-and-manage-your-theory-test",
            "position": 5,
            "itemListElement": [
              {
                "@type": "HowToDirection",
                "text": "You need a provisional driving licence to book your theory test.",
                "position": 1,
              },
              {
                "@type": "HowToDirection",
                "text": "Book your theory test",
                "position": 2,
                "url": "http://www.test.gov.uk/book-theory-test",
              },
              {
                "@type": "HowToDirection",
                "text": "What to take to your test",
                "position": 3,
                "url": "http://www.test.gov.uk/theory-test/what-to-take",
              },
              {
                "@type": "HowToDirection",
                "text": "Change your theory test appointment",
                "position": 4,
                "url": "http://www.test.gov.uk/change-theory-test",
              },
              {
                "@type": "HowToDirection",
                "text": "Check your theory test appointment details",
                "position": 5,
                "url": "http://www.test.gov.uk/check-theory-test",
              },
              {
                "@type": "HowToDirection",
                "text": "Cancel your theory test",
                "position": 6,
                "url": "http://www.test.gov.uk/cancel-theory-test",
              },
            ],
          },
          {
            "@type": "HowToStep",
            "image": "/assets/collections/step-5-e3c06303d977066500539e8b1ed0f04b3357e60b411e399ff22a3a85e9b7dfde.png",
            "name": "Book and manage your driving test",
            "url": "http://www.test.gov.uk/learn-to-drive-a-car#book-and-manage-your-driving-test",
            "position": 6,
            "itemListElement": [
              {
                "@type": "HowToDirection",
                "text": "You must pass your theory test before you can book your driving test.",
                "position": 1,
              },
              {
                "@type": "HowToDirection",
                "text": "Book your driving test",
                "position": 2,
                "url": "http://www.test.gov.uk/book-driving-test",
              },
              {
                "@type": "HowToDirection",
                "text": "What to take to your test",
                "position": 3,
                "url": "http://www.test.gov.uk/driving-test/what-to-take",
              },
              {
                "@type": "HowToDirection",
                "text": "Change your driving test appointment",
                "position": 4,
              },
              {
                "@type": "HowToDirection",
                "text": "Check your driving test appointment details",
                "position": 5,
                "url": "http://www.test.gov.uk/check-driving-test",
              },
              {
                "@type": "HowToDirection",
                "text": "Cancel your driving test",
                "position": 6,
                "url": "http://www.test.gov.uk/cancel-driving-test",
              },
            ],
          },
          {
            "@type": "HowToStep",
            "image": "/assets/collections/step-6-0cb0f4e287fa0e07e440cda3d0dd8528064b259e12352158c9ba5fecde5b0001.png",
            "name": "When you pass",
            "url": "http://www.test.gov.uk/learn-to-drive-a-car#when-you-pass",
            "position": 7,
            "itemListElement": [
              {
                "@type": "HowToDirection",
                "text": "You can start driving as soon as you pass your driving test.",
                "position": 1,
              },
              {
                "@type": "HowToDirection",
                "text": "You must have an insurance policy that allows you to drive without supervision.",
                "position": 2,
              },
              {
                "@type": "HowToDirection",
                "text": "Find out about Pass Plus training courses",
                "position": 3,
                "url": "http://www.test.gov.uk/pass-plus",
              },
            ],
          },
        ],
      }
      expect(expected.deep_stringify_keys).to eq how_to.structured_data.deep_stringify_keys
    end
  end
end
