module MiniTest::Assertions
  # Behaves a bit like `hash_including`.
  # Given a slice of the original hash, it verifies that the original hash
  # includes the sub-hash given. Useful when testing partial arguments/params to
  # methods.
  def assert_includes_subhash(expected_sub_hash, hash)
    assert_equal(
      expected_sub_hash.values,
      hash.slice(*expected_sub_hash.keys).values
    )
  end
end

Hash.infect_an_assertion :assert_includes_subhash, :including?
