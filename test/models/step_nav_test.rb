require 'test_helper'

describe StepNav do
  describe '#structured_data' do
    it 'generates structured data using the HowTo schema' do
      content_item = GovukSchemas::Example.find('step_by_step_nav', example_name: 'learn_to_drive_a_car')
      step_by_step = StepNav.new(ContentItem.new(content_item))

      # Generated with:
      # puts JSON.pretty_generate(step_by_step.structured_data)
      expected = {
        "@context": "http://schema.org",
        "@type": "HowTo",
        "name": "Learn to drive a car: step by step",
        "steps": {
          "@type": "ItemList",
          "itemListElement": [
            {
              "@type": "HowToStep",
              "name": "Check you're allowed to drive",
              "itemListElement": [
                "Most people can start learning to drive when they’re 17.",
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/vehicles-can-drive",
                  "name": "Check what age you can drive"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/legal-obligations-drivers-riders",
                  "name": "Requirements for driving legally"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/driving-eyesight-rules",
                  "name": "Driving eyesight rules"
                }
              ]
            },
            {
              "@type": "HowToStep",
              "name": "Get a provisional driving licence",
              "itemListElement": [
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/apply-first-provisional-driving-licence",
                  "name": "Apply for your first provisional driving licence"
                }
              ]
            },
            {
              "@type": "HowToStep",
              "name": "Driving lessons and practice",
              "itemListElement": [
                "You need a provisional driving licence to take lessons or practice.",
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/guidance/the-highway-code",
                  "name": "The Highway Code"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/driving-lessons-learning-to-drive",
                  "name": "Taking driving lessons"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/find-driving-schools-and-lessons",
                  "name": "Find driving schools, lessons and instructors"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/government/publications/car-show-me-tell-me-vehicle-safety-questions",
                  "name": "Practise vehicle safety questions"
                }
              ]
            },
            {
              "@type": "HowToStep",
              "name": "Prepare for your theory test",
              "itemListElement": [
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/theory-test/revision-and-practice",
                  "name": "Theory test revision and practice"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/take-practice-theory-test",
                  "name": "Take a practice theory test"
                },
                {
                  "@type": "WebPage",
                  "@id": "https://www.safedrivingforlife.info/shop/product/official-dvsa-theory-test-kit-app-app",
                  "name": "Theory and hazard perception test app"
                }
              ]
            },
            {
              "@type": "HowToStep",
              "name": "Book and manage your theory test",
              "itemListElement": [
                "You need a provisional driving licence to book your theory test.",
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/book-theory-test",
                  "name": "Book your theory test"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/theory-test/what-to-take",
                  "name": "What to take to your test"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/change-theory-test",
                  "name": "Change your theory test appointment"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/check-theory-test",
                  "name": "Check your theory test appointment details"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/cancel-theory-test",
                  "name": "Cancel your theory test"
                }
              ]
            },
            {
              "@type": "HowToStep",
              "name": "Book and manage your driving test",
              "itemListElement": [
                "You must pass your theory test before you can book your driving test.",
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/book-driving-test",
                  "name": "Book your driving test"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/driving-test/what-to-take",
                  "name": "What to take to your test"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/check-driving-test",
                  "name": "Check your driving test appointment details"
                },
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/cancel-driving-test",
                  "name": "Cancel your driving test"
                }
              ]
            },
            {
              "@type": "HowToStep",
              "name": "When you pass",
              "itemListElement": [
                "You can start driving as soon as you pass your driving test.",
                "You must have an insurance policy that allows you to drive without supervision.",
                {
                  "@type": "WebPage",
                  "@id": "http://www.test.gov.uk/pass-plus",
                  "name": "Find out about Pass Plus training courses"
                }
              ]
            }
          ]
        }
      }

      assert_equal expected.deep_stringify_keys, step_by_step.structured_data.deep_stringify_keys
    end
  end
end
