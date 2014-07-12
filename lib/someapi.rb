require "someapi/version"

require 'httparty'

module Some

  class API
    include HTTParty

    API_REGEX = /^[a-zA-Z0-9_]+[!]?$/

    def initialize options={}
      @method = options[:method]
      @path = options[:path]

      # stubbed is a flag set when you're stubbing the API call
      # used in testing
      # just call 'stub' in the call chain before the http_method method
      @stubbed = options[:stubbed]

      @options = options.delete_if do |k|
        [:method, :path, :stubbed].include? k
      end
    end

    # http_method methods
    # used in the call chain to set the http method
    %W(get post put patch delete copy move head options).each do |meth|
      define_method(meth) do
        unless @method
          make_new method: meth.to_s, stubbed: @stubbed
        else
          self[meth]
        end
      end
    end

    # use in the call chain to flag this request as a stub
    # used in testing for setting up API-call stubs
    def stub
      unless @method
        make_new method: @method, path: @path, stubbed: true
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
      merged_options = merge_headers_and_queries options
      unless @stubbed
        self.class.send(@method, @path || '/', merged_options)
      else
        uri = "#{self.class.base_uri}#{@path}"

        stub_request(@method.to_sym, uri.to_s).with merged_options
      end
    end

    # chains 'thing' onto URL path
    def [] thing
      make_new method: @method,
               path: "#{@path || ''}/#{thing}",
               stubbed: @stubbed
    end

    # this is where the fun begins...
    def method_missing meth, *args, &block
      meth_s = meth.to_s
      if @method && meth_s =~ API_REGEX

        if meth_s.end_with?('!')
          # `foo! bar' is syntactic sugar for `foo.! bar'
          self[meth_s[0...-1]].!(args[0] || {})

        else
          # chain the method name onto URL path
          self[meth_s]
        end
      else
        super
      end
    end

    def respond_to_missing? method
      @method && method.to_s =~ API_REGEX
    end

    private

      def merge_headers_and_queries options
        merge_headers merge_queries options
      end

      def merge_headers options
        options.merge({
          headers: (self.class.headers || {}).
            merge((@options[:headers] || {}).
            merge(options[:headers] || {}))
        })
      end

      def merge_queries options
        options.merge({
          query: (self.class.default_options[:default_params] || {}).
            merge((@options[:query] || {}).
            merge(options[:query]|| {}))
        })
      end

      def make_new opts={}
        self.class.new @options.merge(opts)
      end

  end

end
