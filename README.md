# Sn::Foil::Rails
![build](https://github.com/limited-effort/snfoil-rails/actions/workflows/main.yml/badge.svg) 
[![maintainability](https://api.codeclimate.com/v1/badges/e6db54dbd56e5cb226f1/maintainability)](https://codeclimate.com/github/limited-effort/snfoil-rails/maintainability)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'snfoil-rails'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install snfoil-rails
```
## Usage
SnFoil Rails mostly just ties together a bunch of the other SnFoil Repos together.  To get the most out of this project we highly recommend you read the docs for SnFoil [Contexts](https://github.com/limited-effort/snfoil-context/blob/main/README.md), [Controllers](https://github.com/limited-effort/snfoil-controller/blob/main/README.md), [Searchers](https://github.com/limited-effort/snfoil-searcher/blob/main/README.md), and [Policies](https://github.com/limited-effort/snfoil-policy/blob/main/README.md).

What it does add is a few rails friend steps for you:
- Basic CRUD controllers
- JSONAPI Include Parser
- Serialize and Deserialize Helpers
- Pagination Helpers
- Additional Searcher Functionality

### CRUD Controllers

To use setup a crud controller you just need to inherit from the `SnFoil::Rails::APIController`

```ruby
class PeopleController < SnFoil::Rails::APIController
    ...
end
```

This will setup `create`, `show`, `update`, `destroy`, and `index` for you.

If you only want one or a few of these methods you can include just that functionality using the appropraite concerns.

```ruby
class PeopleController < ActionController::API
    # Just include Create and Destroy
    include SnFoil::Rails::API::Create
    include SnFoil::Rails::API::Destroy
    ...
end
```

### Helpers

<table>
    <thead>
        <th>Name</th>
        <th>Arguments</th>
        <th>Description</th>
    </thead>
    <tbody>
        <tr>
            <td>
                inject_deserialized
            </td>
            <td>
                options - hash
            </td>
            <td>
                calls the deserialize method using the current option `:params` and injects it into the options hash as `:params`
            </td>
        </tr>
        <tr>
            <td>
                inject_id
            </td>
            <td>
                options - hash
            </td>
            <td>
                attempts to find the appropriate id of the current request model and injects it into the options hash as `:id`
            </td>
        </tr>
        <tr>
            <td>
                inject_include
            </td>
            <td>
                options - hash
            </td>
            <td>
                takes include from the params object, parses it by common, and injects it as a symbolized array into the options hash as ':include'
            </td>
        </tr>
        <tr>
            <td>
                inject_request_id
            </td>
            <td>
                options - hash
            </td>
            <td>
                puts the current request's request_id into the options hash as `:request_id`
            </td>
        </tr>
        <tr>
            <td>
                inject_request_params
            </td>
            <td>
                options - hash
            </td>
            <td>
                calls the current controller's params, symbolizes the keys, and injects it into the options hash as `:params` and `:request_params`.  Since `:params` is expected to be overridden by `#inject_deserialized` a copy of the original params is store in `:request_params`
            </td>
        </tr>
        <tr>
            <td>
                process_pagination
            </td>
            <td>
                options - hash
            </td>
            <td>
                uses the `:request_params` to discern how to paginate
            </td>
        </tr>
    </tbody>
</table>

### Pagination

While most of the helpers are pretty simple pagination require a little more detail.

`#process_pagination` uses parameters from `:request_params` in the options hash.

- per_page - The amount of results to return per page. If `0` then it will return the page_maximum.  Default `10`.
- page - The page to return.

### Searchers

In addition to the base [searcher](https://github.com/limited-effort/snfoil-searcher) functionality a SnFoil::Rails::Searcher includes the following

#### order
The default order direction you want the results to be return in.  This can be overridden by including `order` in the request params.  Defaults to `ASC`.

```ruby 
class PeopleSearcher
  include SnFoil::Searcher

  model Person
  order :ASC
end
```


#### order_by
The model attribute you want to order by. This can be overridden by including `order_by` in the request params. Defaults to `:id`.

```ruby 
class PeopleSearcher
  include SnFoil::Searcher

  model Person
  order_by :last_name
end
```

#### distinct
Whether or not to call ActiveRecord's `.distinct` on the results of the query.  Defaults to `true`.

```ruby 
class PeopleSearcher
  include SnFoil::Searcher

  model Person
  distinct false
end
```


#### includes
A shorthand for adding ActiveRecord's `.include` to the to the query.

```ruby 
class PeopleSearcher
  include SnFoil::Searcher

  model Person
  includes :address,
           { occupation: :employer }
end
```


## Author Notes

### What happened to SSR controllers?

Honestly I never used them myself and never heard of anyone else using them.  This framework was born out of frustration with REST APIs and the only reason SSR was implemented in the first place was a CYA move.  Rather than keeping something in that I wasn't actively using, I decided to focus on what I was.  If you are interested in bring SSR controllers back feel free to reach out and I can walk you through it!

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).