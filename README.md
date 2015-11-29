# Messaging API Example

## Schema

[Schema SQL](schema/schema.sql)

There are a couple different options for the schema of this small implementation. Some designs could cause pain and complex schema updates/refactoring if new features were requested. For example, having a table with the body, sender, and recipient would make it so the body would have to be copied multiple times if we wanted to allow for multiple recipients in the future. This schema does make the queries more complex for the simple case, there are some simplifications we could make if the feature set was locked.  When I design I try to imagine what features might be asked for in the future, not over designing for the current feature set, but to make sure the schema is capable of being extended with those future features. Some features we might want in the future could be multiple recipients, named mailboxes, or file attachments.

If we wanted to reduce the number of joins required when querying a single message we could also store the subject string on each row of Messages. We would still want the Threads table to make it easy to query an entire reply thread. If the Threads table did not exist we would need to do a recursive query up the parent_message_id graph of all the messages in the reply thread.

There are foreign key constraints on recipient_id (Receipts), sender_id (Messages), message_id (Receipts), thread_id (Messages), and parent_message_id (Messages).


- The constraints on recipient_id and sender_id ensure that a User cannot be deleted if he/she is the sender or receiver of any messages.
- The constraint on message_id ensures that as long as a receipt referencing a message exists, that message cannot be deleted.
- The constraint on thread_id ensures that while any messages that belong to that thread exist, the referenced row in Threads cannot be deleted.
- The constraint on parent_message_id ensures that a message that was replied to cannot be deleted unless all of its replies are deleted first.




![Message Database Schema](/schema/schema.png?raw=true)

## API

[Messaging API Doc](/api/api.md)

### Versioning

Each resource in this API is identified by a versioned URL. Example:

  https://messaging.example.com/v1/messages/:id

The prefix v1 is the version specifier. When breaking changes are made to the API this value will change and will be reflected in the version of the API docs.

### Pagination

In order to paginate through results that might update in real-time we need to use cursor based pagination. In the case of messages, pagination happens from newest to oldest. In order to avoid duplicate pages I provide the `max_id` query parameter. The server will respond with results older than the given ID (inclusive). The `Link` header provides the links for the client to move forwards and backwards along the query. Since `max_id` is inclusive, the client can subtract one from it to get all the results before that ID and not re-include the minimum id from the last query.

Example of paginating through the latest messages, 30 at a time:

  http://messaging.example.com/messages?count=30
  http://messaging.example.com/messages?count=30&max_id=256
  http://messaging.example.com/messages?count=30&max_id=200
  http://messaging.example.com/messages?count=30&max_id=133
  http://messaging.example.com/messages?count=30&max_id=96
  http://messaging.example.com/messages?count=30&max_id=33

### Caching

We can leverage HTTP features for caching on the client side:

**ETag:** The server would need to provide the [`ETag`](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.19) header. The client can make a request with the [`If-None-Match`](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.26) header containing an ETag value. The backend can then respond with a `304 Not Modified` status code if the list of messages has not changed. This allows for the client to ask for updates, and the server will only transfer large amounts of data when necessary.

**Last Modified**: The server would include the [`Last-Modified`](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.19) header The client can make a request with the [`If-Modified-Since`](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.25) header. The server will respond with `304 Not Modified` if the return value has not changed since the date and time that was provided in the header.

## References

I referenced the following when designing my solution:

- [HTTP Protocols](http://www.w3.org/)
- [Etsy API](https://www.etsy.com/developers/documentation)
- [Twitter API](https://dev.twitter.com/rest/public)
- [simple private messaging system](http://www.pixel2life.com/publish/tutorials/608/simple_private_messaging_system/)
- [Personal Message System](http://www.webestools.com/scripts_tutorials-code-source-15-personal-message-system-in-php-mysql-pm-system-private-message-discussion.html)
- [Facebook Style Messaging System Database Design](http://www.9lessons.info/2013/05/message-conversation-database-design.html)
- [Mailboxer](https://github.com/mailboxer/mailboxer)
- [simple-private-messages](https://github.com/jongilbraith/simple-private-messages)
