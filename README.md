#Octablog

***
A Simple Blog Application

***

##Configured
1. Rails 4.2.4
1. Ruby 2.2.3
1. PostgreSQL as database
1. Ruby Slim for HTML-templating
1. Simple Form
1. Capistrano 3.4.0
1. Bower
1. Whenever
1. Sidekiq
1. RSpec
1. Foreman

##Installation and assembly
1. Clone *config/database.yml.example* and *config/secrets.yml.example* to *config/database.yml* and *config/secrets.yml* respectively and update their contents
1. Bundle everything up with ``bin/assemble``
1. Run ``bundle exec foreman start``. It will start Thin on port 3000 and daemonize sidekiq. All these are in *Procfile*.
