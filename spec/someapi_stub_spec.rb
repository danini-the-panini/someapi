require 'spec_helper'
require 'httparty'

Some::API.include WebMock::API

describe 'Some::API stubs' do

  let(:more_test_headers) { { 'X-Baz' => 'Qux' } }
  let(:more_test_params) { { 'baz' => 'qux' } }
  let(:test_body) { { 'baz' => 'qux' } }

  let(:api) { TestAPI.new }

  it 'stubs endpoints with method_missing' do
    stub = api.stub.get.foo.bar!
    stub2 = api.stub.get.foo.bar.!

    HTTParty.get('http://example.com/foo/bar?foo=bar',
                headers: test_headers)

    expect(stub).to have_been_requested
    expect(stub2).to have_been_requested
  end

  it 'stubs endpoints with subscript operator' do
    stub = api.stub.get['foo']['bar'].!

    HTTParty.get('http://example.com/foo/bar?foo=bar',
                 headers: test_headers)

    expect(stub).to have_been_requested
  end


  it 'stubs endpoints with query' do
    stub = api.stub.get.foo.bar! query: more_test_params

    HTTParty.get('http://example.com/foo/bar?baz=qux&foo=bar',
                headers: test_headers)

    expect(stub).to have_been_requested
  end

  it 'stubs endpoints with headers' do
    stub = api.stub.get.foo.bar! headers: more_test_headers

    HTTParty.get('http://example.com/foo/bar?foo=bar',
                 headers: test_headers.merge(more_test_headers))

    expect(stub).to have_been_requested
  end

  it 'stubs endpoints with body' do
    stub = api.stub.post.foo.bar! body: test_body

    HTTParty.post('http://example.com/foo/bar?foo=bar',
                 headers: test_headers,
                 body: test_body)

    expect(stub).to have_been_requested
  end
end
