# README

Carcrawler is a friendly webscraper I wrote to find the car I want for the best price.

It currently supports 4 car sites and stores the result in a Postgresql database . It uses Kimurai (https://github.com/vifreefly/kimuraframework) for the crawling.

* Install webdrivers for Kimurai:
OSX:
brew cask install google-chrome
brew cask install chromedriver

other:
see https://github.com/vifreefly/kimuraframework

* Database
Results are stored in a database. I use Postgresql, but change Gemfile and database.yml if you want something else.

* Crawl
You do need to change the starting urls for each of the supported car sites.
```Car.crawl!```

* Results
Start your Rails server:
```rails s```

http://localhost:3000 will serve up a nice chart