# Convo Database Schema

## Tables

### Users

Name    | Type | Attributes          |
--------|------|---------------------|
user_id | int  | Primary Key, Unique |

### Receipts

These rows track the receipt of messages by users.

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
