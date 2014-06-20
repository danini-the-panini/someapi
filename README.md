# SomeAPI

Built around HTTParty, SomeAPI provides a generic wrapper for your favourite RESTful WebAPI. Simply extend Some::API and apply your usual HTTParty options like base_uri, then call your new API and party harder!

## Get Some

Add this line to your application's Gemfile:

    gem 'someapi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install someapi

## Party harder

It's easier than 123!

  1. Create your wrapper:

        class Github < Some::API
          base_uri 'https://api.github.com'
          headers 'User-Agent' => 'p45-dashboard'
          default_params 'client_id' => ENV['GITHUB_CLIENT_ID'],
            'client_secret' => ENV['GITHUB_CLIENT_SECRET']
          format :json
        end

  2. Start using it! Simply string method calls and subscripts together like it's a real API wrapper. Add a bang (`!`) at the end to initiate the HTTP request, returning an HTTParty response, so all your favourite HTTParty features are still intact. Party on!

        github = Guthub.new
        ...
        github.get.users[@username].repos!
        github.post.repos[@username][@repo].pulls! body: { title: "Foo", body: "Pull my Foo", ... }
        github.delete.repos.[@username][@repo].!

## Make a mockery of your tests

Don't stub your toe on external services!

  1. Add `gem 'webmock'` to your Gemfile under the test group

  2. Add the following somewhere in your testing framework's configuration (like `spec_helper.rb`)

        Some::API.include WebMock::API

  3. Adding `stub` before the HTTP method in a SomeAPI request will instead return a Webmock stub after the bang.

        github = Github.new
        ...
        github.stub.get.users[@username].repos!.
          to_return status: 200, body: @somehash.to_json

Stubs look exactly the same as their corresponding requests except for the presence of `stub`, so you can literally copy-pasta from your controllers to your specs and vice-versa without fiddling.

## Tips and Gotchas

If your request ends in a `[whatever]` remember to put a dot before the bang, as in the examples. Ruby doesn't define the (very odd and mostly useless actually) operator for `[]!`.

Posting hashes can be done more succinctly by using the `<<` operator, as follows (using the post example from above):

    github.post.repos[@username][@repo].pulls << { title: "Foo", body: "Pull my Foo", ... }

Also note that every time you do the following (ie. put the bang at the beginning of a request):

    !github.get.users[@some_user]

a baby seal/platypus/kitten will die a horrific death. Also, it looks really bad and will confuse the crap out of you and your peers.

## Thank you for helping us help you help us all

1. Fork it ( https://github.com/[my-github-username]/someapi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
