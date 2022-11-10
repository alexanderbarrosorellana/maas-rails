# Monitoring as a Service

Backend to monitoring as a service, you can find the logic behind allocate shifts
in the allocator concern which uses allocator service to run the assignations

## Installation

### Clone the repository

```shell
git clone https://github.com/alexanderbarrosorellana/maas-rails.git
cd project
```

### Check ruby version

```shell
ruby -v
```

Currently using ruby 3.0.0

I recomend to install ruby with rvm

```shell
rvm install ruby-3.0.0
```

## Database

Currently using postgres

version: psql (PostgreSQL) 12.12

### Install dependencies

```shell
bundle install
```

### Initialize the database

```shell
rails db:create
rails db:migrate
rails db:seed
```

### Running tests with Rspec

```shell
bundle exec rspec
```

## Serve

```shell
rails s
```
