This folder structure should be suitable for starting a project that uses a database:

* Clone the repo
* `rake generate:migration <Name>` to create a migration
* `rake db:migrate` to run it
* Create models
* ... ?
* Profit

You may need to fiddle around with remotes assuming that you don't want to push to this one (which you probably don't).

## Rundown

```
.
├── Gemfile             # Details which gems are required by the project
├── README.md           # This file
├── Rakefile            # Defines `rake generate:migration` and `db:migrate`
├── config
│   └── database.yml    # Defines the database config (e.g. name of file)
├── console.rb          # `ruby console.rb` starts `pry` with models loaded
├── db
│   ├── dev.sqlite3     # Default location of the database file
│   ├── migrate         # Folder containing generated migrations
│   └── setup.rb        # `require`ing this file sets up the db connection
└── lib                 # Your ruby code (models, etc.) should go here
    └── all.rb          # Require this file to auto-require _all_ `.rb` files in `lib`
```

## Spotify API

"Function that queries a song and returns spotify id."

### Apply for the API

- easy

### Explore the API Tools

see <https://developer.spotify.com/>

Spotify provides a web interface for accessing the API through the browser. No `curl` requests! Hooray!

### Use the API

*Main Url*: https://api.spotify.com/
*Authorization Header* `Bearer <authorization token>`

#### Song Search

- Songs are sorted by popularity

            GET /v1/search?q=Fireflies&type=track HTTP/1.1
            Host: api.spotify.com
            Accept: application/json
            Content-Type: application/json
            Accept-Encoding: gzip, deflate, compress
            Authorization: Bearer Token_goes_here
            User-Agent: Spotify API Console v0.1

A query for a son yields:

    rawdata["tracks"]["items"]

Which each contains:

        [
            "album",
            "artists",
            "available_markets",
            "disc_number",
            "duration_ms",
            "explicit",
            "external_ids",
            "external_urls",
            "href",
            "id",
            "name",
            "popularity",
            "preview_url",
            "track_number",
            "type",
            "uri"
        ]
