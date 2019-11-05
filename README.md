# Agora (Widget Marketplace)
## Assumptions and Limitations
  - I didn't add any explicit authentication/authorization into the app. If a user knows an account ID they can execute actions against that account.
  - The web layer I added is very bare bones. It does not distinguish between request errors and server errors, it always renders either a success or a 400/500 with the error message. I mainly added it so that there would be an interface to the application that does not require using Elixir/IEx
  - I interpreted the stated requirement "If a buyer's account has a balance of $0 they cannot purchase..." to mean that they cannot complete a transaction where their balance would end up below $0.
  - I represented currency as floats by setting all account balances to `0.0` initially. I'm then relying on Elixir to coerce any integers to floats when they are added with the account balance. A more complete solution here would be to use a currency library or to represent money as a tuple of the type `{Dollars<Int>, Cents<Int>}`
  - The transaction in `MarketService.buy_widget/2` got pretty long. It has logic that should probably be extracted.

## Design Decisions
I ended up writing the app as a 3-tier architecture. All of the dependencies go in a single direction, i.e. the interface layer is coupled to the service layer, the service layer is not coupled to the interface layer.
```
[User] ---> Interface Layer ---> Service Layer ---> Data Access Layer
```
### Interface Layer
Map requests from the user to business functions/use cases.
#### Broker
The broker module is aggregating all of the supported business functions under a single module. Right now it's only doing `defdelegate` to the services, so it's main value is to expose a single interface to all of the supported use cases (Create Account, Sell Widget, Buy Widget, etc). 
#### Plug API
The Plug API provides a way for users to interact with the app over HTTP. I left it pretty bare bones since it wasn't a strict requirement, but it currently maps JSON user requests to the appropriate use cases in the service layer. It provides very basic error handling. The API could be upgraded with better error messages and input validation. (For example if a field is missing from the payload it currently causes a match error and simply returns a 500. This would be improved by responding with a 400 and which field was missing).

It should work fine and handle invalid inputs appropriately, just not always with the best status codes and error messages.

### Service Layer
The service layer is where the required use cases (called out as Core Functions in the requirements) are implemented. This layer knows a little bit about Mnesia in order to compose transactions and map Mnesia return values to standard `:ok`/`:error` tuples. Since Mnesia does not have built in support for Foreign Keys, this is also where I'm validating that accounts and widgets exist before finishing the transaction. Since all data is held in memory in addition to the disk, it is cheap to do multiple reads within the transaction (e.g. `MarketService.buy_widget/2` does 3 reads and 4 writes).

The service layer takes inputs, composes actions from the Repo layer to execute transactions, then maps the result to an `:ok` or `:error` tuple. They are somewhat analogous to Phoenix's idea of [contexts](https://hexdocs.pm/phoenix/contexts.html).


### Data Access Layer (Repos)
The data access layer handles mapping data from the rest of the system and writing it to the database.

Mnesia uses tuples in the form of Erlang records for data representation. Since working with and updating tuples in Elixir can be difficult, this layer is responsible for mapping the Mnesia records to and from the database. It also abstracts the service layer from needing to execute specific Mnesia operations other than `:mnesia.transaction`.

### Schemas
These are the way data is represented in the application. These structs make it easy to update and interact with data, as well as providing a contract between the layers for the shape and fields of the data.

These are also where to to/from record mappings are defined.

## Technology Choices

### Mnesia
  Typically for this type of application I would use Ecto + Postgres. Postgres provides a strong level of type validation for each field of a table, as well as foreign key validations and built in constraints. Ecto can handle changesets, validations, migrations, etc. 

  Choosing Ecto and Postgres would mean writing less code in this app and more reliance on the code in Ecto and Postgres, both of which are widely adopted and well tested. Ultimately in most common "Ecommerce" apps like this one, Ecto+Postgres is probably the right choice.

  So why Mnesia? I felt that Mnesia would let me do more problem solving and less wiring up of libraries. The three tier architecture naturally emerged as I was implementing the various core functions and handling edge cases. I actually ended up gaining better appreciation for Ecto's design as I had to solve similar problems.

#### Pros of Mnesia
  - Built in to Erlang, no external dependencies to pull in or run
  - Transactions
  - In memory with disk persistence
#### Cons
  - No built relations (foreign keys, etc)
  - No type enforcement
  - No auto-increment IDs for tables, so they must be generated instead

## External Dependencies
### Plug
  I chose to use Plug to write a basic API layer because I justed wanted to have a webserver with a few routes defined. In more complicated apps I would choose Phoenix instead.

### Nanoid
  One of my favorite libraries for generating short IDs in Elixir. In a more serious app I would probably use a full UUID library for IDs instead. Also most RDBMS would provide an integer ID by default.

### Plug_Cowboy
  Hooks up Plug to use the Cowboy webserver. Cowboy handles concurrent connections by spawning processes and Mnesia uses transactions and has built in deadlock prevention; meaning the app should handle multiple concurrent requests pretty well.

### Ex_Doc
  Compiles all of the documentation into the doc folder.

## Testing
Almost all of the public functions in the app have unit tests. I did TDD for most of the service layer and edge case logic. I only did partial TDD for the Repo layer and schemas; I came back and finished the tests after other things were working, since these layers are mainly just mapping between formats. The tests for these layers are fairly repetitive, but I feel that they provide good safety if any of the tables are altered to have different fields.

I didn't add any tests to the Plug API. Tests that I would add here would include input validation and making sure appropriate errors are returned, as well as tests that verify the features work as intended.

Most of the tests could be improved by extracting repeated code to setup blocks or helper functions.


## Running the App

```
# Fetch Elixir dependencies
mix deps.get

# Set up the database and tables
mix db.setup

# Run the unit tests
mix test

# Run the application and web server
iex -S mix
# The API will be accessible on http://localhost:4040
# Or the Broker module can be used within IEx
```

Documentation can be generated by running
```
mix docs

# Serve the docs at `http://localhost:8000/doc/ using Python
# ExDoc uses Javascript for hover previews so viewing the docs
# via a webserver is recommended
python -m http.server
```
and can be viewed by opening `doc/index.html` in a browser.
