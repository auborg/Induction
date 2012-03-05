# Induction
**A Polyglot Database Client for Mac OS X**

*Induction is still in its early alpha stage of development, and has a long way to go before it's production-ready. A development roadmap will be formalized soon, and made available in the GitHub project wiki. This will define the feature set for a 1.0 release, and serve to carve up the work across contributors.*

## Writing a Database Adapter

Database adapters for Induction are designed to be easy to write. Adapters are packaged as bundles, with their primary class implementing the `DBAdapter` protocol. Here is a rundown of the roles and responsibilities of the adapter protocols (note, these interfaces are not final, and subject to evolve and change as the project matures):

### DBAdapter

Specifies a URL scheme, validates connection URLs and creates connections.

``` objective-c
@protocol DBAdapter <NSObject>
+ (NSString *)primaryURLScheme;
+ (BOOL)canConnectWithURL:(NSURL *)url;
+ (id <DBConnection>)connectionWithURL:(NSURL *)url 
                                 error:(NSError **)error;
@end
```

### DBConnection

Initializes and manages a connection client, most often a C interface to a system library.

``` objective-c
@protocol DBConnection <NSObject>
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSArray *databases;

- (id)initWithURL:(NSURL *)url;

- (BOOL)open;
- (BOOL)close;
- (BOOL)reset;
@end
```

### DBDatabase

Represents an organized collection of data, most often corresponding to a database in the target platform. 

It's principle responsibility is to populate the source list on the left side of the connection window.

``` objective-c
@protocol DBDatabase <NSObject>
@property (nonatomic, readonly) id <DBConnection> connection;
@property (nonatomic, readonly) NSOrderedSet *dataSourceGroupNames;

- (NSArray *)dataSourcesForGroupNamed:(NSString *)groupName;
@end
```

### DBDataSource

Following the [interpretation used by Yahoo YUI](http://developer.yahoo.com/yui/datasource/), this is "an abstract representation of a live set of data that presents a common predictable API for other objects to interact with." Examples of this include SQL tables, MongoDB collections, collections of Redis keys according to their type, etc.

Data sources have their responsibilities split across three different protocols, representing the "Explore", "Query", and "Visualize" features of the application. By conforming to its respective protocol, the adapter makes itself available for that feature.

``` objective-c
@protocol DBDataSource <NSObject>
- (NSUInteger)numberOfRecords;
@end
```

#### DBExplorableDataSource

``` objective-c
@protocol DBExplorableDataSource <NSObject>
- (id <DBResultSet>)resultSetForRecordsAtIndexes:(NSIndexSet *)indexes                                                          
                                           error:(NSError **)error;
@end
```

#### DBQueryableDataSource

``` objective-c
@protocol DBQueryableDataSource <NSObject>
- (id <DBResultSet>)resultSetForQuery:(NSString *)query 
                                error:(NSError **)error;
@end
```

#### DBVisualizableDataSource

```objective-c
@protocol DBVisualizableDataSource <NSObject>
- (id <DBResultSet>)resultSetForDimension:(NSExpression *)dimension
                                 measures:(NSArray *)measures
                                    error:(NSError **)error;
@end
```

### DBResultSet

Perhaps the most significant part of an adapter, this object represents a result set of data, and drives the display of information in tables and outlines. Whereas a SQL table is a `DBDataSource`, the first page of 1000 results would be a `DBResultSet`, and it is the result set that is displayed.

``` objective-c
@protocol DBResultSet <NSObject>
- (NSUInteger)numberOfRecords;
- (NSArray *)recordsAtIndexes:(NSIndexSet *)indexes;

- (NSUInteger)numberOfFields;
- (NSString *)identifierForTableColumnAtIndex:(NSUInteger)index;
@optional
- (DBValueType)valueTypeForTableColumnAtIndex:(NSUInteger)index;
- (NSCell *)dataCellForTableColumnAtIndex:(NSUInteger)index;
- (NSSortDescriptor *)sortDescriptorPrototypeForTableColumnAtIndex:(NSUInteger)index;
@end
```

### DBRecord

Records correspond to rows, or individual documents in the result set, and are represented by an object conforming to the `DBRecord` protocol. `DBResultSet` fields correspond to columns or values, which are strings that are passed to `DBRecord` objects using `valueForKey:`.

Adapters to graph or document databases can optionally specify the child records, which can be expanded using disclosure indicators in an outline view.

``` objective-c
@protocol DBRecord <NSObject>
- (id)valueForKey:(NSString *)key;
@optional
@property (nonatomic, readonly) NSArray *children;
@end
```

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

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

Induction is available under the MIT license. See the LICENSE file for more info.
