def test_headers
  { 'X-Hello' => 'World' }
end

def test_params
  { 'foo' => 'bar' }
end

class AllAPI < Some::API
  base_uri 'http://example.com/'
  headers test_headers
  default_params test_params
end

class NoAPI < Some::API
  base_uri 'http://example.com/'
end
