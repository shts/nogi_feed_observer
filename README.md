observe nogizaka46 blog feed
======
run on heroku application.

#### Start App
`heroku ps:scale web=1`

#### Stop App
`heroku ps:scale web=0`

#### Check log
`heroku logs`


Memo
----
use `sinatra-activerecord` gem for db migration.
