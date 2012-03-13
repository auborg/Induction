# Induction
**A Polyglot Database Client for Mac OS X**

## Roadmap

Induction is already quite useful, but there's a long way to go before it's ready for a public release--let alone a beta.

To get a better idea of what's planned, here's a list of features expected to ship before an official release (tentative / less likely features indicated by †):

### Explore

- Popovers for expanded detail of text and blob cells
- Copy selection as JSON, XML, CSV, etc.
- Cell formatting for null objects
- Cell formatting for detected kinds of fields (percentages, currency, URLs, JSON, image data, etc.)†
- Support for geospatial data†
- Improved pagination controls
- Schema / data source information panel
- Search controller for filtering / finding records
- General improvements to table / outline view
- Write support (create / modify / destroy records)†
- Importing / Exporting records†
- Show associated records in outline (e.g. one-to-many records by foreign key in relational DBs)†

### Query

- Overhauled query editor
  - Polyglot syntax highlighting
  - Token autocompletion / validation
  - Line numbers
- Saved queries
- Export results to [Heroku Postgres Data Clips](https://postgres.heroku.com/blog/past/2012/1/31/simple_data_sharing_with_data_clips/), Gist, etc.
- Query builder (no SQL / commands)
- Query planner / explainer visualization†

### Visualize

- Integration of visualization framework ([Lies, Damned lies (coming soon)](https://github.com/Induction/LiesDamnedLies))
- Query builder (no SQL / commands)
- Share as image, data, web page, etc.

### General

- Overhauled connection configuration panel
  - Improved UI
  - Favorites
- Image assets for icons (e.g. source list, tab bar icons, image assets for database types)
- Database selector for open connections
- Preferences (if necessary)†
- URL scheme support (e.g. `postgres://`)†
- Improved database file support (e.g. SQLite)
- Add / remove menubar items as necessary

### Infrastructure

- Settle on class name-spacing
- Iterate on database adapter protocols
  - Figure out how to handle connection / database relationship (conflated for certain adapters, like Redis or Postgres, where connections have a database context)
  - Add hooks for better error handling (e.g. `NSError **` parameters)
  - Add method for specifying source list icon
  - Improve flow for loading plugins and determining whether they're supported on the current machine (or require software installation)
  - Add methods for write operations†
  - Add more database value types†
- Vastly improve core database adapters
  - Stability / robustness
  - Performance (lazy evaluation, query cursors, asynchronous dispatch, etc.)
  - Error handling
- Continually improve and optimize table / outline view and general app performance

## How Can I Help?

If you're interested in working on a particular feature, [open an Issue](https://github.com/Induction/Induction/issues) (or join an existing one if possible).

Communicate your intent, collect feedback, and submit pull requests. Just the minimal bureaucratic process to reduce the duplication of efforts--that's all I'm looking for. As best I can, I'll try to do the same myself.

If you're interested in contributing to the design of the application, contact me directly, and we'll work something out. Design is an entirely different beast that doesn't quite lend itself to the same process of open source collaboration.

### Adapters

Adapters are being maintained and managed [as a separate repository](https://github.com/Induction/Adapters). If you wish to work on a new or existing adapter, you can do so in that project.

---

### Explore, Query, Visualize

Focus on the data, not the database. Induction is a new kind of tool designed for understanding and communicating relationships in data. Explore rows and columns, query to get exactly what you want, and visualize that data in powerful ways.

### SQL? NoSQL? It Don't Matter

Data is just data, after all. Induction supports PostgreSQL, MySQL, SQLite, Redis, and MongoDB  out-of-the-box, and has an extensible architecture that makes it easy to write adapters for anything else you can think of.

### Free As In "Free to Kick Ass"

The full source code for Induction [is available on GitHub](https://github.com/Induction/Induction). I'm excited to build something insanely great, and I invite you to join me on this codeventure. Bug reports, feature requests, patches, well-wishes, and rap demo tapes are always welcome.

### What's In A Name?

<dl>
  <dt>
    Induction <em class="pronunciation">(ən"dʌk'ʃən)</em>
  </dt>
  <dd>The generation of an electric current by a varying magnetic field</dd>
  <dd>The derivation of general principles from specific instances</dd>
</dl>

Data is like electricity: It appears in endless variety, employing adapters and transformers to become more useful. But no matter what, data is power. From data, we derive knowledge and understanding through a process of induction.

### So Who's Behind All Of This?

Induction was created by [Mattt Thompson](http://twitter.com/mattt/), with the help of his friends and colleagues at [Heroku](http://www.heroku.com/), particularly those on the [Heroku Postgres](https://postgres.heroku.com/) team.

## Requirements

Induction requires Xcode 4.2 or above, and targets Mac OS 10.7. 

Some adapters, such as for MySQL and MongoDB, require libraries not included in OS X by default. These can be installed separately using [Homebrew](http://mxcl.github.com/homebrew/) or another package manager, or by compiling from source.

## Downloads

Pre-compiled binaries of Induction are available in the [downloads](https://github.com/Induction/Induction/downloads) section of the repository. A more sustainable distribution strategy is actively being worked towards.

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

Induction is available under the MIT license. See the LICENSE file for more info.
