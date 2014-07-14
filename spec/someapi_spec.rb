require 'spec_helper'

describe Some::API do

  let(:moar_headers) { { 'X-Fizz' => 'Buzz' } }
  let(:moar_params) { { 'fizz' => 'buzz' } }
  let(:all_the_headers) { test_headers.merge(moar_headers) }
  let(:all_the_params) { test_params.merge(moar_params) }
  let(:test_body) { { 'baz' => 'qux' } }

  let(:even_moar_headers) { { 'X-Baz' => 'Qux' } }
  let(:even_moar_params) { { 'baz' => 'qux' } }

  context 'when api has not defaults' do
    context 'when api has no extras' do
      let(:api) { NoAPI.new }

      it 'requests endpoints using method_missing' do
        stub = stub_request(:get, "http://example.com/foo/bar")

        api.get.foo.bar!
        api.get.foo.bar.!

        expect(stub).to have_been_requested.times(2)
      end

      it 'requests endpoints using subscript operator' do
        stub = stub_request(:get, "http://example.com/foo/bar")

        api.get['foo']['bar'].!

        expect(stub).to have_been_requested
      end


      it 'requests endpoints with query' do
        stub = stub_request(:get, "http://example.com/foo/bar?baz=qux")

        api.get.foo.bar! query: even_moar_params

        expect(stub).to have_been_requested
      end

      it 'requests endpoints with headers' do
        stub = stub_request(:get, "http://example.com/foo/bar").
          with(:headers => even_moar_headers)

        api.get.foo.bar! headers: even_moar_headers

        expect(stub).to have_been_requested
      end

      it 'requests endpoints with body' do
        stub = stub_request(:post, "http://example.com/foo/bar").
          with(:body => test_body)

        api.post.foo.bar! body: test_body

        expect(stub).to have_been_requested
      end
    end

    context 'when api has extra headers and queries' do
      let(:api) { NoAPI.new query: moar_params,
                              headers: moar_headers }

      it 'requests endpoints' do
        stub = stub_request(:get, "http://example.com/foo/bar?fizz=buzz").
          with(:headers => moar_headers)

        api.get.foo.bar!
        api.get.foo.bar.!

        expect(stub).to have_been_requested.times(2)
      end

      it 'requests endpoints with query' do
        stub = stub_request(:get, "http://example.com/foo/bar?baz=qux&fizz=buzz").
          with(:headers => moar_headers)

        api.get.foo.bar! query: even_moar_params

        expect(stub).to have_been_requested
      end

      it 'requests endpoints with headers' do
        stub = stub_request(:get, "http://example.com/foo/bar?fizz=buzz").
          with(:headers => moar_headers.merge(even_moar_headers))

        api.get.foo.bar! headers: even_moar_headers

        expect(stub).to have_been_requested
      end

    end
  end

  context 'when api has default headers and queries' do
    context 'when api has extra headers and queries' do
      let(:api) { AllAPI.new query: moar_params,
                              headers: moar_headers }

      it 'requests endpoints' do
        stub = stub_request(:get, "http://example.com/foo/bar?fizz=buzz&foo=bar").
          with(:headers => all_the_headers)

        api.get.foo.bar!
        api.get.foo.bar.!

        expect(stub).to have_been_requested.times(2)
      end

      it 'requests endpoints with query' do
        stub = stub_request(:get, "http://example.com/foo/bar?baz=qux&fizz=buzz&foo=bar").
          with(:headers => all_the_headers)

        api.get.foo.bar! query: even_moar_params

        expect(stub).to have_been_requested
      end

      it 'requests endpoints with headers' do
        stub = stub_request(:get, "http://example.com/foo/bar?fizz=buzz&foo=bar").
          with(:headers => all_the_headers.merge(even_moar_headers))

        api.get.foo.bar! headers: even_moar_headers

        expect(stub).to have_been_requested
      end

    end


    context 'when api has no extras' do
      let(:api) { AllAPI.new }

      it 'requests endpoints' do
        stub = stub_request(:get, "http://example.com/foo/bar?foo=bar").
          with(:headers => test_headers)

        api.get.foo.bar!
        api.get.foo.bar.!

        expect(stub).to have_been_requested.times(2)
      end

      it 'requests endpoints with query' do
        stub = stub_request(:get, "http://example.com/foo/bar?baz=qux&foo=bar").
          with(:headers => test_headers)

        api.get.foo.bar! query: even_moar_params

        expect(stub).to have_been_requested
      end

      it 'requests endpoints with headers' do
        stub = stub_request(:get, "http://example.com/foo/bar?foo=bar").
          with(:headers => test_headers.merge(even_moar_headers))

        api.get.foo.bar! headers: even_moar_headers

        expect(stub).to have_been_requested
      end

    end
  end
end
