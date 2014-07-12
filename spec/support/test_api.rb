def test_headers
  { 'X-Hello' => 'World' }
end

def test_params
  { 'foo' => 'bar' }
end

class TestAPI < Some::API
  base_uri 'http://example.com/'
  headers test_headers
  default_params test_params
end
