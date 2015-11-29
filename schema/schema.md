# Convo Database Schema

There are a couple different options for the schema of this small implementation. Some designs could cause pain and complex schema updates/refactoring if new features were requested. For example, having a table with the body, sender, and recipient would make it so the body would have to be copied multiple times if we wanted to allow for multiple recipients in the future.

This schema does make the queries more complex for the simple case, but there are some simplifications we could make if the feature set was locked.  When I design I try to imagine what features might be asked for in the future, and then design with those features in mind. Some features we might want in the future could be multiple recipients, named mailboxes, or file attachments.

If we wanted to reduce the number of joins required when querying a single convo we could also store the subject string on each row of Messages. We would still want the Threads table to make it easy to query an entire reply thread. If the Threads table did not exist we would need to do multiple queries up and down the parent_convo_id graph of all the convos in the reply thread.

There are foreign key constraints on recipient_id (Receipts), sender_id (Messages), convo_id (Receipts), thread_id (Messages), and parent_convo_id (Messages).


- The constraints on recipient_id and sender_id ensure that a User cannot be deleted if he/she is the sender or receiver of any convos.
- The constraint on convo_id ensures that as long as a receipt referencing a convo exists, that convo cannot be deleted.
- The constraint on thread_id ensures that while any convos that belong to that thread exist, the referenced row in Threads cannot be deleted.
- The constraint on parent_convo_id ensures that a convo that was replied to cannot be deleted unless all of its replies are deleted first.

## Tables

![Message Database Schema](schema.png?raw=true)

[Schema SQL](schema.sql)

### Users

Name    | Type | Attributes          |
--------|------|---------------------|
user_id | int  | Primary Key, Unique |

### Receipts

Name          | Type  | Attributes
--------------|-------|------------------------------------
receipt_id    | int   | Primary Key, Unique, Auto_Increment
recipient_id  | int   | Not Null, Foreign Key Users(user_id) Restrict
convo_id      | int   | Not Null, Foreign Key Convos(convo_id) Restrict
read          | bool  | Not Null, Default false
created_at    | float | Not Null
modified_at   | float | Not Null

### Convos

Name            | Type            | Attributes
----------------|-----------------|------------------------------------
convo_id        | int             | Primary Key, Unique, Auto_Increment
sender_id       | int             | Not Null, Foreign Key Users(user_id) Restrict
thread_id       | int             | Not Null, Foreign Key Threads(thread_id) Restrict
body            | varchar(64000)  | Not Null, Default false
parent_convo_id | float           | Not Null, Foreign Key Convos(convo_id) Restrict
created_at      | float           | Not Null

### Threads

Name       | Type         | Attributes
-----------|--------------|-----------
thread_id  | int          | Primary Key, Auto_Increment
subject    | varchar(140) | Not Null
created_at | float        | Not Null
