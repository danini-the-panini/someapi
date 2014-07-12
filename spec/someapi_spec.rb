require 'spec_helper'

describe Some::API do

  let(:more_test_headers) { { 'X-Baz' => 'Qux' } }
  let(:more_test_params) { { 'baz' => 'qux' } }
  let(:test_body) { { 'baz' => 'qux' } }

  let(:api) { TestAPI.new }

  it 'requests endpoints with method_missing' do
    stub = stub_request(:get, "http://example.com/foo/bar?foo=bar").
      with(:headers => test_headers)

    api.get.foo.bar!
    api.get.foo.bar.!

    expect(stub).to have_been_requested.times(2)
  end

  it 'requests endpoints with subscript operator' do
    stub = stub_request(:get, "http://example.com/foo/bar?foo=bar").
      with(:headers => test_headers)

    api.get['foo']['bar'].!

    expect(stub).to have_been_requested
  end


  it 'requests endpoints with query' do
    stub = stub_request(:get, "http://example.com/foo/bar?baz=qux&foo=bar").
      with(:headers => test_headers)

    api.get.foo.bar! query: more_test_params

    expect(stub).to have_been_requested
  end

  it 'requests endpoints with headers' do
    stub = stub_request(:get, "http://example.com/foo/bar?foo=bar").
      with(:headers => test_headers.merge(more_test_headers))

    api.get.foo.bar! headers: more_test_headers

    expect(stub).to have_been_requested
  end

  it 'requests endpoints with body' do
    stub = stub_request(:post, "http://example.com/foo/bar?foo=bar").
      with(:headers => test_headers, :body => test_body)

    api.post.foo.bar! body: test_body

    expect(stub).to have_been_requested
  end
end
