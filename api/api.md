# Convo API V1

Allows users to send, receive, and reply to convos.

## Convo Object

Field        | Visibility |  Type              | Description
-------------|------------|--------------------|-------------
id           | both       | int                | unique id of the convo
sender_id    | both       | int                | id of the sender of the convo
recipient_id | both       | int                | id of the recipient of the convo
subject      | both       | string             | subject of the convo
body         | both       | string             | contents of the convo
read         | receiver   | bool               | true if the convo has been marked as read
created_at   | both       | float (epoch time) | time the convo was created at
modified_at  | receiver   | float (epoch time) | time the convo was last modified

## List Convos

List the authenticated user's convos newest first:

    GET /convos

List all the authenticated user's unread convos newest first:

    GET /convos/unread

List all the authenticated user's read convos newest first:

    GET /convos/read

List the authenticated user's sent convos newest first:

    GET /convos/sent

#### Parameters

Name     | Type      | Description
---------|-----------|------------
`max_id` | `integer` | the largest id of the convos returned
`count`  | `integer` | maximum number of convos to return in the response (default: 25 max: 100)


#### Response 200 OK (application/json)

    Headers:

            Link : <http://api.exmaple.com/v1/convos?max_id=54&count=3>; rel="next", <http:///api.example.com/v1/convos?max_id=876&count=3>; rel="last"

    Body (authenticated user's id = 92):

            [
                {
                    "id": 54,
                    "sender_id": 22,
                    "recipient_id": 92,
                    "subject": "Favorite programming language?",
                    "body": "I really like Fortran.",
                    "read": true
                    "created_at": 1095379.00
                    "modified_at": 1095379.00
                },
                {
                    "id": 55,
                    "sender_id": 22,
                    "recipient_id": 92
                    "subject": "What's for dinner?",
                    "body": "I'm so hungry I could eat a horse.",
                    "read": true
                    "created_at": 1095379200.00
                    "modified_at": 1095379200.00
                },
                {
                    "id": 62,
                    "sender_id": 92,
                    "recipient_id": 22,
                    "parent_id": 5
                    "subject": "What's for dinner?",
                    "body": "Leave my horse alone! Go make a sandwich.",
                    "created_at": 1095379300.00
                }
            ]


## Create a New Convo

  This creates a new convo with the authenticated user as the sender.

    POST /convos

#### Input

Name           | Type      | Description
---------------|-----------|------------
`recipient_id` | `integer` | **Required** the id of the user who should receive this convo
`subject`      | `string`  | **Required** the subject of the convo (max: 140 characters)
`body`         | `string`  | **Required** the contents of the convo (max: 64,000 characters)


#### Request (application/json)

        {
            "recipient_id": 92,
            "subject": "What's for dinner?",
            "body": "I'm so hungry I could eat a horse."
        }

#### Response 201 CREATED (application/json)

    Headers:

            Location: /convos/55

    Body (authenticated user's id = 22):

            {
                "id": 55,
                "sender_id": 22,
                "recipient_id": 92,
                "subject": "What's for dinner?",
                "body": "I'm so hungry I could eat a horse.",
                "created_at": 1095379200.00
            }

#### Response 422 UNPROCESSABLE ENTITY (application/json)

In the case of a full API doc all error codes would be listed to allow for developers to
be able to give their own messages in the case of certain error codes.

            {
                "code" : 1024,
                "convo" : "Validation Failed",
                "errors" : [
                {
                  "code" : 5432,
                  "field" : "subject",
                  "convo" : "Subject has a maximum length of 140 characters"
                },
                {
                   "code" : 5622,
                   "field" : "body",
                   "convo" : "The body cannot contain the word 'Ni'"
                }
              ]
            }

## Get a single convo

    GET /convos/:id

#### Response 200 OK (application/json)

    Body (authenticated user's id = 92):

            {
                "id": 55,
                "sender_id": 22,
                "recipient_id": 92
                "subject": "What's for dinner?",
                "body": "I'm so hungry I could eat a horse.",
                "read": false
                "created_at": 1095379200.00
                "modified_at": 1095379200.00
            }

#### Response 404 NOT FOUND

## Delete a convo

    DELETE /convos/:id

#### Response 204 NO CONTENT

#### Response 404 NOT FOUND

## Mark convo as read

    PUT /convos/:id/read

#### Response 204 NO CONTENT

#### Response 404 NOT FOUND

## Mark convo as unread

    PUT /convos/:id/unread

#### Response 204 NO CONTENT

#### Response 404 NOT FOUND

## Reply to a convo

    POST /convos/:id/reply

#### Input

    Name   | Type     | Description
    -------|----------|------------
    `body` | `string` | **Required** the contents of the convo (max: 64,000 characters)


#### Request (application/json)

        {
            "body": "Leave my horse alone! Go make a sandwich."
        }

#### Response 201 CREATED (application/json)

    Headers:

        Location: /convos/62

    Body (authenticated user's id = 92):

        {
            "id": 62,
            "sender_id": 92,
            "recipient_id": 22,
            "parent_id": 5
            "subject": "What's for dinner?",
            "body": "Leave my horse alone! Go make a sandwich.",
            "created_at": 1095379300.00
        }

## Get all the convos in the reply thread of this convo

    GET /convos/:id/replies

#### Parameters

Name     | Type      | Description
---------|-----------|------------
`max_id` | `integer` | the largest id of the convos returned
`count`  | `integer` | maximum number of convos to return in the response (default: 25 max: 100)

#### Response 200 OK (application/json)

    Headers:

        Link : <http://api.example.com/v1/convos?max_id=55>; rel="next", <http:///api.example.com/v1/convos?max_id=11>; rel="last"

    Body (authenticated user's id = 22):
        {
            [
                {
                    "id": 55,
                    "sender_id": 22,
                    "recipient_id": 92
                    "subject": "What's for dinner?",
                    "body": "I'm so hungry I could eat a horse.",
                    "created_at": 1095379200.00
                },
                {
                    "id": 62,
                    "sender_id": 92,
                    "recipient_id": 22,
                    "parent_id": 5
                    "subject": "What's for dinner?",
                    "body": "Leave my horse alone! Go make a sandwich.",
                    "read": true
                    "created_at": 1095379300.00
                    "modified_at": 109538111.00
                }
            ]
        }
