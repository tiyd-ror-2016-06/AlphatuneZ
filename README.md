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

*Main Url*: for api calls: https://api.spotify.com/

### Endpoints

#### Search Endpoint

- See https://developer.spotify.com/web-api/search-item/

- This endpoint seems to offer the most flexibility...
    - specify `type` of search `artist`, `album`, `track`, etc.
    - within the scope of `type`, specify multiple fields..

*EXAMPLE REQUEST* (Query by type `track` with generic query)

            GET /v1/search?q=Fireflies&type=track HTTP/1.1
            Host: api.spotify.com
            Accept: application/json
            Content-Type: application/json
            Accept-Encoding: gzip, deflate, compress
            Authorization: Bearer <Token_goes_here>
            User-Agent: Spotify API Console v0.1

This query yields a JSON.
When parsed, it is a hash with the songs sorted by popularity rating.

With `raw_data` as the hash containing the results, the songs can be accessed in this way:

    rawdata["tracks"]["items"]

Each of the results for this query contain the following contains:

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

### SpotifyApiRequest

The `SpotifyApiRequest` class is used to facilitate requests to Spotify.

Specify the token_string to use for authorization, and the song to query as keyword arguments when instantiating the class:

    my_request = SpotifyApiRequest.new authorization: token_string, song: 'Take Me Home Tonight'

Parse the request from JSON:

    my_request.parse!

The method `#get_songs` can be called on it, and it will return an array of songs with each song a hash structured in this way:

    "album"     => "Eddie Money"
    "artist"    => "Eddie Money, Ronnie Spector"
    "id"        => "59eevcAetPY5PU5B8dpVc8"
    "title"     => "Take Me Home Tonight"

Pass a file as an argument to the keyword `test:` to use test_data (JSON formatted):

    my_request = SpotifyApiRequest.new(authorization: token_string, song: "empty", test_file: "mytestfile.json")

#### Authorization and Tokens

The `SpotifyApiToken` class handles tokens.
Authorization is a complex topic.
See <https://developer.spotify.com/web-api/authorization-guide/> for more information.
