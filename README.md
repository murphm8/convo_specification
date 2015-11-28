# Messaging API Example

## Schema

[Schema SQL](schema/schema.sql)

There are a couple different options for the schema of this small implementation.
Some designs could cause pain and complex schema updates/refactoring if new features were requested. For example, having a table with the body, sender, and recipient would make it so the body would have to be copied multiple times if we wanted to allow for multiple recipients in the future. This does make the queries more complex for the simple case, if it was really guaranteed we would never want advanced features then this schema could be made simpler.

If we wanted to reduce the number of joins required when querying a single message we could also store the subject string on each row of Messages. We would still want the Threads table to make it easy to query an entire reply thread. If the Threads table did not exist we would need to do a recursive query up the parent_message_id graph of all the messages in the reply thread.

There are foreign key constraints on recipient_id (Receipts), sender_id (Messages), message_id (Receipts), and thread_id (Messages).


- The constraints on recipient_id and sender_id ensure that a User cannot be deleted if he/she is the sender or receiver of any messages.
- The constraint on message_id ensures that as long as a receipt referencing a message exists, that message cannot be deleted.
- The constraint on thread_id ensures that while any messages that belong to that thread exist, the referenced row in Threads cannot be deleted.



![Message Database Schema](/schema/schema.png?raw=true)

## API

## References

I referenced the following when designing my solution:

- [simple private messaging system](http://www.pixel2life.com/publish/tutorials/608/simple_private_messaging_system/)
- [Personal Message System](http://www.webestools.com/scripts_tutorials-code-source-15-personal-message-system-in-php-mysql-pm-system-private-message-discussion.html)
- [Facebook Style Messaging System Database Design](http://www.9lessons.info/2013/05/message-conversation-database-design.html)
- [Mailboxer](https://github.com/mailboxer/mailboxer)
- [simple-private-messages](https://github.com/jongilbraith/simple-private-messages)
