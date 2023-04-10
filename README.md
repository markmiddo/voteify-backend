Steps to install
1. install rvm `curl -sSL https://get.rvm.io | bash -s stable`
2. install/use ruby 2.6.3
3. rvm use
4. bundle install
5. .env configure db
6. Run PostgreSQL and Redis using docker-compose `docker-compose up -d`
6. create db: `rake db:create` -> migrate `rake db:migrate`
7. run seed `rake db:seed`
8. `rails server -b 0.0.0.0 -p 3030 -e development`
