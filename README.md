# AmazonHistory

A side-project to help accomplish two outstanding tasks:

1. Store a permanent record of the purchase history of an Amazon account
2. Learn [Elixir](https://elixir-lang.org/)

## Description

This module uses [Hound](https://github.com/HashNuke/hound) and [Chromedriver](https://sites.google.com/a/chromium.org/chromedriver/) to scrape the purchase history of an Amazon retail account, and output it in CSV format.

## Usage

The project can be run from the command-line using `mix`.

For example:

```
mix run -e AmazonHistory.CLI.run(["--email", "amazon@email.com", "--password", "amaz0np4ssword", "--start-year", "2004"])
```

## TODO/Wishlist

* Separate the scraping and parsing concerns. This is somewhat difficult to do due to the implementation of Hound, but would significantly ease the implementation of automated testing if it could be done.
* Expose more configuration to the CLI
* Bundle as an standalone executable(?)

## License

Copyright 2018 Rob Watson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
