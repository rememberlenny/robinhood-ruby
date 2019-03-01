<h1><img src="https://raw.githubusercontent.com/rememberlenny/robinhood-ruby/master/.github/robinhood-ruby.png"/></h1>

[![Dependency Status](https://gemnasium.com/badges/github.com/rememberlenny/robinhood-ruby.svg)](https://gemnasium.com/github.com/rememberlenny/robinhood-ruby)
[![Build Status](https://travis-ci.org/rememberlenny/robinhood-ruby.svg?branch=master)](https://travis-ci.org/rememberlenny/robinhood-ruby)
[![Coverage Status](https://coveralls.io/repos/github/rememberlenny/robinhood-ruby/badge.svg?branch=master)](https://coveralls.io/github/rememberlenny/robinhood-ruby?branch=master)

# robinhood-ruby

A module to make trades with the private Robinhood API. Using this API is not encouraged, since it's not officially available and it has been reverse engineered. See [@Sanko's](https://github.com/Sanko) [Unofficial Documentation](https://github.com/sanko/Robinhood) for more information.

FYI [Robinhood's Terms and Conditions](https://brokerage-static.s3.amazonaws.com/assets/robinhood/legal/Robinhood%20Terms%20and%20Conditions.pdf)

<!-- toc -->
  * [Features](#features)
  * [Installation](#installation)
  * [Usage](#usage)
  * [API](#api)
    * [`investment_profile`](#investment-profilecallback)
    * [`instruments(symbol)`](#instrumentssymbol-callback)
    * [`quote_data(stock) # Not authenticated`](#quote-datastock-callback-not-authenticated)
    * [`accounts`](#accountscallback)
    * [`user`](#usercallback)
    * [`dividends`](#dividendscallback)
    * [`orders`](#orderscallback)
    * [`place_buy_order(options)`](#place-buy-orderoptions-callback)
      * [`trigger`](#trigger)
      * [`time`](#time)
    * [`place_sell_order(options)`](#place-sell-orderoptions-callback)
      * [`trigger`](#trigger)
      * [`time`](#time)
    * [`fundamentals(symbol)`](#fundamentalssymbol-callback)
      * [Response](#response)
    * [`cancel_order(order)`](#cancel-orderorder-callback)
    * [`watchlists(name)`](#watchlistsname-callback)
    * [`create_watch_list(name)`](#create-watch-listname-callback)
    * [`sp500_up`](#sp500-upcallback)
    * [`sp500_down`](#sp500-downcallback)
    * [`splits(instrument)`](#splitsinstrument-callback)
    * [`historicals(symbol, intv, span)`](#historicalssymbol-intv-span-callback)
    * [`url(url)`](#urlurl-callback)
* [Contributors](#contributors)

## Features

* Quote Data
* Buy, Sell Orders (not yet)
* Daily Fundamentals
* Daily, Weekly, Monthly Historicals

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'robinhood-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install robinhood-ruby

## Usage

```ruby

require 'rubygems' # not necessary with ruby 1.9 but included for completeness
require 'robinhood-ruby' # if not loaded through Gemfile

# The username and password you use to sign into the robinhood app.
username = 'username'
password = 'password'

# set up a client to talk to the Robinhood REST API
@robinhood = Robinhood::REST::Client.new(username, password)

```

## API

Before using these methods, make sure you have initialized Robinhood using the snippet above.


### `investment_profile`
Get the current user's investment profile.

```ruby
    @robinhood = Robinhood::REST::Client.new(username, password)
    investment_profile = @robinhood.investment_profile
    puts(investment_profile)

    #    { annual_income: '25000_39999',
    #      investment_experience: 'no_investment_exp',
    #      updated_at: '2015-06-24T17:14:53.593009Z',
    #      risk_tolerance: 'low_risk_tolerance',
    #      total_net_worth: '0_24999',
    #      liquidity_needs: 'very_important_liq_need',
    #      investment_objective: 'income_invest_obj',
    #      source_of_funds: 'savings_personal_income',
    #      user: 'https://api.robinhood.com/user/',
    #      suitability_verified: true,
    #      tax_bracket: '',
    #      time_horizon: 'short_time_horizon',
    #      liquid_net_worth: '0_24999' }
```


### `instruments(symbol)`

```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    instruments = @robinhood.instruments('AAPL')
    puts(instruments)

    #    { previous: null,
    #      results:
    #       [ { min_tick_size: null,
    #           splits: 'https://api.robinhood.com/instruments/450dfc6d-5510-4d40-abfb-f633b7d9be3e/splits/',
    #           margin_initial_ratio: '0.5000',
    #           url: 'https://api.robinhood.com/instruments/450dfc6d-5510-4d40-abfb-f633b7d9be3e/',
    #           quote: 'https://api.robinhood.com/quotes/AAPL/',
    #           symbol: 'AAPL',
    #           bloomberg_unique: 'EQ0010169500001000',
    #           list_date: '1990-01-02',
    #           fundamentals: 'https://api.robinhood.com/fundamentals/AAPL/',
    #           state: 'active',
    #           day_trade_ratio: '0.2500',
    #           tradeable: true,
    #           maintenance_ratio: '0.2500',
    #           id: '450dfc6d-5510-4d40-abfb-f633b7d9be3e',
    #           market: 'https://api.robinhood.com/markets/XNAS/',
    #           name: 'Apple Inc. - Common Stock' } ],
    #      next: null }
```


Get the user's instruments for a specified stock.

### `quote_data(stock) // Not authenticated`

Get the user's quote data for a specified stock.

```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    quote_data = @robinhood.quote_data('AAPL')
    puts(quote_data)

    #{
    #    results: [
    #        {
    #            ask_price: String, // Float number in a String, e.g. '735.7800'
    #            ask_size: Number, // Integer
    #            bid_price: String, // Float number in a String, e.g. '731.5000'
    #            bid_size: Number, // Integer
    #            last_trade_price: String, // Float number in a String, e.g. '726.3900'
    #            last_extended_hours_trade_price: String, // Float number in a String, e.g. '735.7500'
    #            previous_close: String, // Float number in a String, e.g. '743.6200'
    #            adjusted_previous_close: String, // Float number in a String, e.g. '743.6200'
    #            previous_close_date: String, // YYYY-MM-DD e.g. '2016-01-06'
    #            symbol: String, // e.g. 'AAPL'
    #            trading_halted: Boolean,
    #            updated_at: String, // YYYY-MM-DDTHH:MM:SS e.g. '2016-01-07T21:00:00Z'
    #        }
    #    ]
    #}
```

### `accounts`

```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    accounts = @robinhood.accounts
            puts(accounts)
    #{ previous: null,
    #  results:
    #   [ { deactivated: false,
    #       updated_at: '2016-03-11T20:37:15.971253Z',
    #       margin_balances: [Object],
    #       portfolio: 'https://api.robinhood.com/accounts/asdf/portfolio/',
    #       cash_balances: null,
    #       withdrawal_halted: false,
    #       cash_available_for_withdrawal: '692006.6600',
    #       type: 'margin',
    #       sma: '692006.6600',
    #       sweep_enabled: false,
    #       deposit_halted: false,
    #       buying_power: '692006.6600',
    #       user: 'https://api.robinhood.com/user/',
    #       max_ach_early_access_amount: '1000.00',
    #       cash_held_for_orders: '0.0000',
    #       only_position_closing_trades: false,
    #       url: 'https://api.robinhood.com/accounts/asdf/',
    #       positions: 'https://api.robinhood.com/accounts/asdf/positions/',
    #       created_at: '2015-06-17T14:53:36.928233Z',
    #       cash: '692006.6600',
    #       sma_held_for_orders: '0.0000',
    #       account_number: 'asdf',
    #       uncleared_deposits: '0.0000',
    #       unsettled_funds: '0.0000' } ],
    #  next: null }
```


Get the user's accounts.

### `user`
Get the user information.

```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    user = @robinhood.user
    puts(user)
```

### `dividends`

Get the user's dividends information.
```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    dividends = @robinhood.dividends
    puts(dividends)
```


### `orders`

Get the user's orders information.
```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    orders = @robinhood.orders
    puts(orders)
```
### `place_buy_order(options)`

Place a buy order on a specified stock.

```ruby
    @robinhood = Robinhood::REST::Client(username, password)
        options = {
        "type": 'limit',
        "quantity": 1,
        "bid_price": 1.00,
        "instrument": {
            "url": String,
            "symbol": String
        }
        # # Optional:
        # "trigger": String, # Defaults to "gfd" (Good For Day)
        # "time": String,    # Defaults to "immediate"
        # "type": String     # Defaults to "market"
    }
    @robinhood.place_buy_order(options)
```

For the Optional ones, the values can be:

*[Disclaimer: This is an unofficial API based on reverse engineering, and the following option values have not been confirmed]*

#### `trigger`

A *[trade trigger](http://www.investopedia.com/terms/t/trade-trigger.asp)* is usually a market condition, such as a rise or fall in the price of an index or security.

Values can be:

* `gfd`: Good For Day
* `gtc`: Good Till Cancelled
* `oco`: Order Cancels Other

#### `time`

The *[time in force](http://www.investopedia.com/terms/t/timeinforce.asp?layout=infini&v=3A)* for an order defines the length of time over which an order will continue working before it is canceled.

Values can be:

* `immediate` : The order will be cancelled unless it is fulfilled immediately.
* `day` : The order will be cancelled at the end of the trading day.

### `place_sell_order(options)`

Place a sell order on a specified stock.

```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    options = {
      "type": 'limit',
      "quantity": 1,
      "bid_price": 1.00,
      "instrument": {
          "url": String,
          "symbol": String
      },
      # # Optional:
      # "trigger": String, # Defaults to "gfd" (Good For Day)
      # "time": String,    # Defaults to "immediate"
      # "type": String     # Defaults to "market"
    }
    @robinhood.place_sell_order(options)

```

For the Optional ones, the values can be:

*[Disclaimer: This is an unofficial API based on reverse engineering, and the following option values have not been confirmed]*

#### `trigger`

A *[trade trigger](http://www.investopedia.com/terms/t/trade-trigger.asp)* is usually a market condition, such as a rise or fall in the price of an index or security.

Values can be:

* `gfd`: Good For Day
* `gtc`: Good Till Cancelled
* `oco`: Order Cancels Other

#### `time`

The *[time in force](http://www.investopedia.com/terms/t/timeinforce.asp?layout=infini&v=3A)* for an order defines the length of time over which an order will continue working before it is canceled.

Values can be:

* `immediate` : The order will be cancelled unless it is fulfilled immediately.
* `day` : The order will be cancelled at the end of the trading day.

### `fundamentals(symbol)`

Get fundamental data about a symbol.

#### Response

An object containing information about the symbol:

```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    fundamentals = @robinhood.fundamentals("SBPH")
    puts(fundamentals)

    #{                               // Example for SBPH
    #    average_volume: string,     // "14381.0215"
    #    description: string,        // "Spring Bank Pharmaceuticals, Inc. [...]"
    #    dividend_yield: string,     // "0.0000"
    #    high: string,               // "12.5300"
    #    high_52_weeks: string,      // "13.2500"
    #    instrument: string,         // "https://api.robinhood.com/instruments/42e07e3a-ca7a-4abc-8c23-de49cb657c62/"
    #    low: string,                // "11.8000"
    #    low_52_weeks: string,       // "7.6160"
    #    market_cap: string,         // "94799500.0000"
    #    open: string,               // "12.5300"
    #    pe_ratio: string,           // null (price/earnings ratio)
    #    volume: string              // "4119.0000"
    #}

```

### `watchlists(name)`
```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    watchlists = @robinhood.watchlists
    puts(watchlists)

    # { previous: null,
    #   results:
    #   [ { url: 'https://api.robinhood.com/watchlists/Default/',
    #       user: 'https://api.robinhood.com/user/',
    #      name: 'Default' } ],
    # }
```

### `create_watch_list(name)`
```
    # Your account type must support multiple watchlists to use this endpoint otherwise will get { detail: 'Request was throttled.' } and watchlist is not created.
    @robinhood = Robinhood::REST::Client(username, password)
    watchlist = @robinhood.create_watch_list('Technology)
        puts(watchlist)
    //    {
    //        "url": "https://api.robinhood.com/watchlists/Technology/",
    //        "user": "https://api.robinhood.com/user/",
    //        "name": "Technology"
    //    }
```

### `sp500_up`
```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    sp500_up = @robinhood.sp500_up
    puts(sp500_up)

    #{ count: 10,
    #  next: null,
    #  previous: null,
    #  results:
    #   [ { instrument_url: 'https://api.robinhood.com/instruments/adbc3ce0-dd0d-4a7a-92e0-88c1f127cbcb/',
    #       symbol: 'NEM',
    #       updated_at: '2016-09-21T13:03:32.310184Z',
    #       price_movement: [{ market_hours_last_movement_pct: '7.55', market_hours_last_price: '41.0300' }],
    #       description: 'Newmont Mining Corp. is a gold producer, which is engaged in the acquisition, exploration and production of gold and copper properties in U.S., Australia, Peru, Indonesia, Ghana, Canada, New Zealand and Mexico. The company\'s operating segments include North America, South America, Asia Pacific and Africa. The North America segment consists of Nevada in the United States, La Herradura in Mexico and Hope Bay in Canada. The South America segment consists of Yanacocha and Conga in Peru. The Asia Pacific segment consists of Boddington in Australia, Batu Hijau in Indonesia and other smaller operations in Australia and New Zealand. The Africa segment consists of Ahafo and Akyem in Ghana. The company was founded by William Boyce Thompson on May 2, 1921 and is headquartered in Greenwood Village, CO.' },
    #     { instrument_url: 'https://api.robinhood.com/instruments/809adc21-ef75-4c3d-9c0e-5f9a167f235b/',
    #       symbol: 'ADBE',
    #       updated_at: '2016-09-21T13:01:31.748590Z',
    #       price_movement: [{ market_hours_last_movement_pct: '7.55', market_hours_last_price: '41.0300' }],
    #       description: 'Adobe Systems, Inc. provides digital marketing and digital media solutions. The company operates its business through three segments: Digital Media, Digital Marketing, and Print and Publishing. The Digital Media segment offers creative cloud services, which allow members to download and install the latest versions of products, such as Adobe Photoshop, Adobe Illustrator, Adobe Premiere Pro, Adobe Photoshop Lightroom and Adobe InDesign, as well as utilize other tools, such as Adobe Acrobat. This segment also offers other tools and services, including hobbyist products, such as Adobe Photoshop Elements and Adobe Premiere Elements, Adobe Digital Publishing Suite, Adobe PhoneGap, Adobe Typekit, as well as mobile apps, such as Adobe Photoshop Mix, Adobe Photoshop Sketch and Adobe Premiere Clip that run on tablets and mobile devices. The Digital Media serves professionals, including graphic designers, production artists, web designers and developers, user interface designers, videographers, motion graphic artists, prepress professionals, video game developers, mobile application developers, students and administrators. The Digital Marketing segment offers various solutions, including analytics, social marketing, targeting, media optimization, digital experience management and cross-channel campaign management, as well as premium video delivery and monetization. This segment also offers legacy enterprise software, such as Adobe Connect web conferencing platform and Adobe LiveCycle. The Print and Publishing segment offers legacy products and services for eLearning solutions, technical document publishing, web application development and high-end printing. Adobe Systems was founded by Charles M. Geschke and John E. Warnock in December 1982 and is headquartered in San Jose, CA.' }
    #    ]
```

### `sp500_down`
```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    sp500_down = @robinhood.sp500_down
    puts(sp500_down)

    #{ count: 10,
    #  next: null,
    #  previous: null,
    #  results:
    #   [ { instrument_url: 'https://api.robinhood.com/instruments/adbc3ce0-dd0d-4a7a-92e0-88c1f127cbcb/',
    #       symbol: 'NEM',
    #       updated_at: '2016-09-21T13:03:32.310184Z',
    #       price_movement: [{ market_hours_last_movement_pct: '-3.70', market_hours_last_price: '13.2800' }],
    #      description: 'Newmont Mining Corp. is a gold producer, which is engaged in the acquisition, exploration and production of gold and copper properties in U.S., Australia, Peru, Indonesia, Ghana, Canada, New Zealand and Mexico. The company\'s operating segments include North America, South America, Asia Pacific and Africa. The North America segment consists of Nevada in the United States, La Herradura in Mexico and Hope Bay in Canada. The South America segment consists of Yanacocha and Conga in Peru. The Asia Pacific segment consists of Boddington in Australia, Batu Hijau in Indonesia and other smaller operations in Australia and New Zealand. The Africa segment consists of Ahafo and Akyem in Ghana. The company was founded by William Boyce Thompson on May 2, 1921 and is headquartered in Greenwood Village, CO.' },
    #     { instrument_url: 'https://api.robinhood.com/instruments/809adc21-ef75-4c3d-9c0e-5f9a167f235b/',
    #       symbol: 'ADBE',
    #       updated_at: '2016-09-21T13:01:31.748590Z',
    #       price_movement: [{ market_hours_last_movement_pct: '-3.70', market_hours_last_price: '13.2800' }],
    #       description: 'Adobe Systems, Inc. provides digital marketing and digital media solutions. The company operates its business through three segments: Digital Media, Digital Marketing, and Print and Publishing. The Digital Media segment offers creative cloud services, which allow members to download and install the latest versions of products, such as Adobe Photoshop, Adobe Illustrator, Adobe Premiere Pro, Adobe Photoshop Lightroom and Adobe InDesign, as well as utilize other tools, such as Adobe Acrobat. This segment also offers other tools and services, including hobbyist products, such as Adobe Photoshop Elements and Adobe Premiere Elements, Adobe Digital Publishing Suite, Adobe PhoneGap, Adobe Typekit, as well as mobile apps, such as Adobe Photoshop Mix, Adobe Photoshop Sketch and Adobe Premiere Clip that run on tablets and mobile devices. The Digital Media serves professionals, including graphic designers, production artists, web designers and developers, user interface designers, videographers, motion graphic artists, prepress professionals, video game developers, mobile application developers, students and administrators. The Digital Marketing segment offers various solutions, including analytics, social marketing, targeting, media optimization, digital experience management and cross-channel campaign management, as well as premium video delivery and monetization. This segment also offers legacy enterprise software, such as Adobe Connect web conferencing platform and Adobe LiveCycle. The Print and Publishing segment offers legacy products and services for eLearning solutions, technical document publishing, web application development and high-end printing. Adobe Systems was founded by Charles M. Geschke and John E. Warnock in December 1982 and is headquartered in San Jose, CA.' }
    #    ]
    #}
```
### `splits(instrument)`

```ruby
    @robinhood = Robinhood::REST::Client(username, password)
    splits = @robinhood.splits("7a3a677d-1664-44a0-a94b-3bb3d64f9e20")
    puts("splits")
```

### `historicals(symbol, intv)`    

```ruby

    # {interval=5minute|10minute (required) span=week|day| }
    @robinhood = Robinhood::REST::Client(username, password)
    historicals = @robinhood.historicals("AAPL", '5minute')
    puts(historicals)

    #             
    #    { quote: 'https://api.robinhood.com/quotes/AAPL/',
    #      symbol: 'AAPL',
    #      interval: '5minute',
    #      span: 'week',
    #      bounds: 'regular',
    #      previous_close: null,
    #      historicals:
    #       [ { begins_at: '2016-09-15T13:30:00Z',
    #           open_price: '113.8300',
    #           close_price: '114.1700',
    #           high_price: '114.3500',
    #           low_price: '113.5600',
    #           volume: 3828122,
    #           session: 'reg',
    #           interpolated: false },
    #         { begins_at: '2016-09-15T13:35:00Z',
    #           open_price: '114.1600',
    #           close_price: '114.3800',
    #           high_price: '114.7300',
    #           low_price: '114.1600',
    #           volume: 2166098,
    #           session: 'reg',
    #           interpolated: false },
    #         ... 290 more items
    #      ]}
    #    }

```

### `url(url)`

`url` is used to get continued or paginated data from the API. Queries with long results return a reference to the next sete. Example -

```
next: 'https://api.robinhood.com/orders/?cursor=cD0yMD82LTA0LTAzKzkwJVNCNTclM0ExNC45MzYyKDYlMkIwoCUzqtAW' }
```

The url returned can be passed to the `url` method to continue getting the next set of results.



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rememberlenny/robinhood-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


# Contributors

Leonard Bogdonoff ([@rememberlenny](https://github.com/rememberlenny))
------------------
* Alejandro U. Alvarez ([@aurbano](https://github.com/aurbano))
* Jesse Spencer ([@Jspenc72](https://github.com/jspenc72))
* Justin Keller ([@nodesocket](https://github.com/nodesocket))
* Wei-Sheng Su ([@ted7726](https://github.com/ted7726))
* Dustin Moore ([@dustinmoorenet](https://github.com/dustinmoorenet))
* Alex Ryan ([@ialexryan](https://github.com/ialexryan))
* Ben Van Treese ([@vantreeseba](https://github.com/vantreeseba))
* Zaheen ([@z123](https://github.com/z123))
* Chris Busse ([@busse](https://github.com/busse))
* Jason Truluck ([@jasontruluck](https://github.com/jasontruluck))

------------------


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

> Even though this should be obvious: I am not affiliated in any way with Robinhood Financial LLC. I don't mean any harm or disruption in their service by providing this. Furthermore, I believe they are working on an amazing product, and hope that by publishing this NodeJS framework their users can benefit in even more ways from working with them.
