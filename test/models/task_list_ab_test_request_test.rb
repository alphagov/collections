require 'test_helper'

describe TaskListAbTestRequest do
  setup do
    mock_request = OpenStruct.new(headers: [])
    task_list_request = TaskListAbTestRequest.new(mock_request)
    @ab_test = task_list_request.ab_test
  end

  describe "setup A/B testing" do
    it "should setup the test name" do
      assert_equal @ab_test.ab_test_name, "TaskListBrowse"
    end

    it 'should setup the dimension' do
      assert_equal @ab_test.dimension, 43
    end

    it 'should setup allowed_variants' do
      assert_equal @ab_test.allowed_variants, %w(A B)
    end

    it 'should setup the control variant' do
      assert_equal @ab_test.control_variant, "A"
    end
  end
end
