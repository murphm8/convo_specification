# Messaging API Example

## Schema

There are a couple different options for the schema of this small implementation.
Some designs would cause pain and complex schema updates if new features were requested. For example,
having a table with the body, sender, and recipient would make it so the body would have to be copied
multiple times if we wanted to allow for multiple recipients in the future. This does make the queries
more complex for the simple case, so if it was really guaranteed we would never want advanced features,
then this schema could be made simpler.

## API

## References

I referenced the following when designing my solution:

- [simple private messaging system](http://www.pixel2life.com/publish/tutorials/608/simple_private_messaging_system/)
- [Personal Message System](http://www.webestools.com/scripts_tutorials-code-source-15-personal-message-system-in-php-mysql-pm-system-private-message-discussion.html)
- [Facebook Style Messaging System Database Design](http://www.9lessons.info/2013/05/message-conversation-database-design.html)
- [Mailboxer](https://github.com/mailboxer/mailboxer)
- [simple-private-messages](https://github.com/jongilbraith/simple-private-messages)
