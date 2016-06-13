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

#### Song Search

- Header bears the authorization token in the form

    `Bearer <token_here>`
