module TaxonHelpers
  def education_content_item(params = {})
    {
      'content_id' => 'student-finance-content-id',
      'title' => 'Student finance',
      'description' => 'Student finance content',
      'base_path' => '/student-finance',
      'links' => {
        'parent_taxon' => [
          'title' => 'Education and learning',
          'description' => 'Education and learning description',
          'base_path' => '/alpha-taxonomy/education'
        ],
        'child_taxons' => [
          {
            'title' => 'Student sponsorship',
            'description' => 'Description of student sponsorship',
            'base_path' => '/alpha-taxonomy/student-sponsorship'
          },
          {
            'title' => 'Student loans',
            'description' => 'Description of student loans',
            'base_path' => '/alpha-taxonomy/student-loans'
          }
        ]
      }
    }.merge(params)
  end
end
