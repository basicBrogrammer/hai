### x - tested
### / - untested

------------------------------------------

- [/] read(single | multiple)
  - [x] Single or query
  - [x] limit
  - [x] offset
  - [x] multiple ors?
  - [x] relationships
- [/] create
  - [/] attributes
  - [] required or not
- [/] update
  - [/] id + attributes
- [/] destroy
  - [/] id
  - [/] authorization [current_user]

------------------------------------------

- [] graphql
  - [/] Types
    - [/] models
    - [/] Arel
    - [/] inputs
  - [/] read
    - [/] read
    - [/] list
    - [/] relationships
    - [] ActiveRecord::RecordNotFound ?
  - [/] create
    - [/] callback for current_user/context
    - [] Errors
  - [/] update
    - [/] callback for policy
    - [] Errors
  - [/] destroy
    - [] Errors
  - [] errors
  - [] subscriptions
------
- [x] gemify
- [] automate release

## Post gem
- [] Multiple or queries
- [] geolocation
- [] private attrs
- [] allowed actions
