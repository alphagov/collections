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
        "image": "/assets/collections/govuk_publishing_components/govuk-schema-placeholder-1x1-5ceffac04f7f6d4f421bd1d36dbb723ef48c15426d7f77f90be80a83af3c747e.png",
        "name": "Learn to drive a car: step by step",
        "step": [
          {
            "@type": "HowToStep",
            "image": "/assets/collections/step-1-ba1b6be36d611d7a23778cdfc6f66822209f2a26447233fa6ba5ad8d9b715887.png",
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
            "image": "/assets/collections/step-2-5684f7637a48dc3805c8f5fdd2ff4a071ae68e4df780f689e98b1b089b6a2a2f.png",
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
            "image": "/assets/collections/step-3-38f4e6cd39f0cde6f8d1b5d8b140edc387eb7763c3d12445fef1d6f97fc91567.png",
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
            "image": "/assets/collections/step-and-74cca23cff1ca95dc07450491bf13915cb46c3d473303e92a9d47e31256824d8.png",
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
            "image": "/assets/collections/step-4-820e35a67c583f6ffd218bb2047b909187b7b657cf2c87510bdf4eef1581e362.png",
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
            "image": "/assets/collections/step-5-dbe629ccb75208fa3edc3b581894556f12413d0da257962becc9dbcd085a0ff2.png",
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
            "image": "/assets/collections/step-6-d8851d68f990a07e721356a56182ec9a7a8e14d6948ec1c4c5bb073bf80d0f06.png",
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
