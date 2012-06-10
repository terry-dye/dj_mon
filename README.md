# DJ Mon

A Rails engine based frontend for Delayed Job.

## Demo
* Source [DJ Mon](https://github.com/akshayrawat/dj_mon_demo)
* URL:     [Demo](http://dj-mon-demo.herokuapp.com/)
* Username: `dj_mon`
* Password: `password`

## Installation

Add this line to your application's Gemfile:

    gem 'dj_mon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dj_mon

## Note
Supports only `activerecord` for now.

## Usage

If you are using Rails =< 3.1, or if `config.assets.initialize_on_precompile` is set to false, then add this to `config/environments/production.rb`.

    config.assets.precompile += %w( dj_mon.js dj_mon.css)

Mount it in `routes.rb`

    mount DjMon::Engine => 'dj_mon'

This uses http basic auth for authentication. Set the credentials in an initializer - `config/initializers/dj_mon.rb`

    YourApp::Application.config.dj_mon.username = "dj_mon"
    YourApp::Application.config.dj_mon.password = "password"
    
If the credentials are not set, then the username and password are assumed to be the above mentioned.

Now visit `http://localhost:3000/dj_mon` and profit!


## ROADMAP
* Delete failed or queued jobs
* Restart failed jobs
* Filter by queue.
* `rake` tasks to know job status from command line.
  

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
