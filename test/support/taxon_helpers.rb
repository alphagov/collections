module TaxonHelpers
  # This taxon has grandchildren
  def funding_and_finance_for_students(params = {})
    {
      'content_id' => 'funding-and-finance-for-students-content-id',
      'title' => 'Funding and finance for students',
      'description' => 'Description for funding and finance for students',
      'base_path' => '/alpha-taxonomy/funding-and-finance-for-students',
      'links' => {
        'parent_taxons' => [
          {
            'title' => 'Education and learning',
            'description' => 'Education and learning description',
            'base_path' => '/alpha-taxonomy/education'
          }
        ],
        'child_taxons' => [
          student_finance_taxon
        ]
      }
    }.merge(params)
  end

  # This taxon does not have grandchildren
  def student_finance_taxon(params = {})
    {
      'content_id' => 'student-finance-content-id',
      'title' => 'Student finance',
      'description' => 'Student finance content',
      'base_path' => '/alpha-taxonomy/student-finance',
      'links' => {
        'parent_taxons' => [
          {
            'title' => 'Funding and finance for students',
            'description' => 'Description for funding and finance for students',
            'base_path' => '/alpha-taxonomy/funding-and-finance-for-students'
          }
        ],
        'child_taxons' => [
          student_sponsorship_taxon,
          student_loans_taxon
        ]
      }
    }.merge(params)
  end

  def student_sponsorship_taxon(params = {})
    {
      'content_id' => 'student-sponsorship-content-id',
      'title' => 'Student sponsorship',
      'description' => 'Description of student sponsorship',
      'base_path' => '/alpha-taxonomy/student-sponsorship',
      'links' => {
        'parent_taxons' => [
          {
            'title' => 'Student finance',
            'description' => 'Student finance content',
            'base_path' => '/alpha-taxonomy/student-finance'
          }
        ],
      }
    }.merge(params)
  end

  def student_loans_taxon(params = {})
    {
      'content_id' => 'student-loans-content-id',
      'title' => 'Student loans',
      'description' => 'Description of student loans',
      'base_path' => '/alpha-taxonomy/student-loans',
      'links' => {
        'parent_taxons' => [
          {
            'title' => 'Student finance',
            'description' => 'Student finance content',
            'base_path' => '/alpha-taxonomy/student-finance'
          }
        ],
      }
    }.merge(params)
  end
end
