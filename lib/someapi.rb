require "someapi/version"

require 'httparty'

module Some

  class API
    include HTTParty

    API_REGEX = /^[a-zA-Z0-9_]+[!]?$/

    def initialize options={}, meth=nil, path=nil, stubbed=false
      @meth = meth
      @path = path
      @options = options

      # stubbed is a flag set when you're stubbing the API call
      # used in testing
      # just call 'stub' in the call chain before the http_method method
      @stubbed = stubbed
    end

    # http_method methods
    # used in the call chain to set the http method
    %W(get post put patch delete copy move head options).each do |meth|
      define_method(meth) do
        unless @meth
          self.class.new Hash.new, meth.to_s, nil, @stubbed
        else
          self[meth]
        end
      end
    end

    # use in the call chain to flag this request as a stub
    # used in testing for setting up API-call stubs
    def stub
      unless @meth
        self.class.new Hash.new, @meth, @path, true
      else
        self['stub']
      end
    end

    # sort of an alias for 'posting' (or whatever) an object
    # just syntactic sugar for {body: obj} really
    # I would have used '=' but that would return the object you posted! >.<
    def << obj
      self.! body: obj
    end

    # seriously this could be alias_method :>>, :!
    def >> options
      self.! options
    end

    # 'calls' the API request
    # (or makes the stub, if stubbed)
    def ! options = {}
      unless @stubbed
        self.class.send(@meth, @path || '/', deep_merge(options,@options))
      else
        uri = "#{self.class.base_uri}#{@path}"

        deep_merge(options,@options)
        process_headers(options)
        process_query(options)
        options = self.class.default_options.
          merge(@options.merge(options))

        stub_request(@meth.to_sym, uri.to_s).with(options)
      end
    end

    # chains 'thing' onto URL path
    def [] thing
      self.class.new @options, @meth, "#{@path || ''}/#{thing}", @stubbed
    end

    # this is where the fun begins...
    def method_missing meth, *args, &block
      meths = meth.to_s
      if @meth && meths =~ API_REGEX

        if meths.end_with?('!')
          # `foo! bar' is syntactic sugar for `foo.! bar'
          self[meths[0...-1]].!(args[0] || {})

        else
          # chain the method name onto URL path
          self[meths]
        end
      else
        super
      end
    end

    def respond_to_missing? meth
      @meth && meth.to_s =~ API_REGEX
    end

    private

      # shamelessly stolen from HTTParty
      def process_headers(options)
        if options[:headers] && self.class.headers.any?
          options[:headers] = self.class.headers.merge(options[:headers])
        end
      end

      # shamelessly copied from above, but for :query
      def process_query(options)
        if self.class.default_options[:default_params]
          options[:query] = self.class.default_options[:default_params].
            merge(options[:query] || {})
        end
      end

      # merge a hash within a hash from two hashes (yo-dawg...)
      def merge_stuff(a,b,tag)
        if a[tag] && b[tag]
          a[tag] = b[tag].merge(a[tag])
        end
      end

      # just merge_stuff like :headers and :query... you know, HTTP stuff
      def deep_merge(a,b)
        merge_stuff(a,b,:headers)
        merge_stuff(a,b,:query)
        b.merge(a)
      end

  end

end
