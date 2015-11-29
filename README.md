# Convo API Example

## Schema

[Schema Doc](schema/schema.md)
[Schema SQL](schema/schema.sql)

There are a couple different options for the schema of this small implementation. Some designs could cause pain and complex schema updates/refactoring if new features were requested. For example, having a table with the body, sender, and recipient would make it so the body would have to be copied multiple times if we wanted to allow for multiple recipients in the future.

This schema does make the queries more complex for the simple case, but there are some simplifications we could make if the feature set was locked.  When I design I try to imagine what features might be asked for in the future, and then design with those features in mind. Some features we might want in the future could be multiple recipients, named mailboxes, or file attachments.

If we wanted to reduce the number of joins required when querying a single convo we could also store the subject string on each row of Messages. We would still want the Threads table to make it easy to query an entire reply thread. If the Threads table did not exist we would need to do multiple queries up and down the parent_convo_id graph of all the convos in the reply thread.

There are foreign key constraints on recipient_id (Receipts), sender_id (Messages), convo_id (Receipts), thread_id (Messages), and parent_convo_id (Messages).


- The constraints on recipient_id and sender_id ensure that a User cannot be deleted if he/she is the sender or receiver of any convos.
- The constraint on convo_id ensures that as long as a receipt referencing a convo exists, that convo cannot be deleted.
- The constraint on thread_id ensures that while any convos that belong to that thread exist, the referenced row in Threads cannot be deleted.
- The constraint on parent_convo_id ensures that a convo that was replied to cannot be deleted unless all of its replies are deleted first.




![Message Database Schema](/schema/schema.png?raw=true)

## API

[Convo API Doc](/api/api.md)

### Versioning

Each resource in this API is identified by a versioned URL. Example:

    https://api.example.com/v1/convos/:id

The prefix v1 is the version specifier. When breaking changes are made to the API this value will change and will be reflected in the version of the API docs.

### Pagination

In order to paginate through results that might update in real-time we need to use cursor based pagination. In the case of convos, pagination happens from newest to oldest. In order to avoid duplicate pages I provide the `max_id` query parameter. The server will respond with results older than the given ID (inclusive). The `Link` header provides the links for the client to move forwards and backwards along the query. Since `max_id` is inclusive, the client can subtract one from it to get all the results before that ID and not re-include the minimum id from the last query.

Example of paginating through the latest convos, 30 at a time:

    http://messaging.example.com/convos?count=30
    http://messaging.example.com/convos?count=30&max_id=256
    http://messaging.example.com/convos?count=30&max_id=200
    http://messaging.example.com/convos?count=30&max_id=133
    http://messaging.example.com/convos?count=30&max_id=96
    http://messaging.example.com/convos?count=30&max_id=33

### Caching

We can leverage HTTP features for caching on the client side:

**ETag:** The server would need to provide the [`ETag`](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.19) header. In the simplist case for a user's convos the Etag could be the count of that user's convos. The client can make a request with the [`If-None-Match`](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.26) header containing an ETag value. The backend can then respond with a `304 Not Modified` status code if the list of convos has not changed. This allows for the client to ask for updates, and the server will only transfer large amounts of data when necessary.

**Last Modified**: The server would include the [`Last-Modified`](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.19) header. The client can make a request with the [`If-Modified-Since`](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.25) header. The server will respond with `304 Not Modified` if the return value has not changed since the date and time that was provided in the header.

## References

I referenced the following when designing my solution:

- [HTTP Protocols](http://www.w3.org/)
- [GitHub API](https://developer.github.com/v3/)
- [Etsy API](https://www.etsy.com/developers/documentation)
- [Twitter API](https://dev.twitter.com/rest/public)
- [simple private messaging system](http://www.pixel2life.com/publish/tutorials/608/simple_private_messaging_system/)
- [Personal Message System](http://www.webestools.com/scripts_tutorials-code-source-15-personal-convo-system-in-php-mysql-pm-system-private-convo-discussion.html)
- [Facebook Style Messaging System Database Design](http://www.9lessons.info/2013/05/convo-conversation-database-design.html)
- [Mailboxer](https://github.com/mailboxer/mailboxer)
- [simple-private-convos](https://github.com/jongilbraith/simple-private-convos)
