# Messaging API

Allows users to send, receive, and reply to messages.

## List Messages

List the authenticated user's messages

    GET /messages

List all the authenticated user's unread messages

    GET /messages/unread

List all the authenticated user's read messages

    GET /messages/read

#### Parameters

Name     | Type      | Description
---------|-----------|------------
`max_id` | `integer` | the largest id of the messages returned
`count`  | `integer` | maximum number of messages to return in the response (max: 100)


#### Response 200 OK (application/json)

    Headers:

            Link : <http://api.messagecenter.ex/messages?max_id=55&count=10>; rel="next", <http:///api.messagecenter.ex/messages?max_id=876&count=10>; rel="last"

    Body:

            [
                {
                    "id": 1,
                    "sender_id": 22,
                    "recipient_id": 92,
                    "subject": "Favorite programming language?",
                    "body": "I really like Fortran.",
                    "read": true
                },
                {
                    "id": 5,
                    "sender_id": 22,
                    "recipient_id": 92
                    "subject": "What's for dinner?",
                    "body": "I'm so hungry I could eat a horse.",
                    "read": true
                },
                {
                    "id": 6,
                    "sender_id": 92,
                    "recipient_id": 22,
                    "parent_id": 5
                    "subject": "What's for dinner?",
                    "body": "Leave my horse alone! Go make a sandwich.",
                    "read": false
                }
            ]


## Create a New Message

  This creates a new message with the authenticated user as the sender.

    POST /gists

#### Input

Name           | Type      | Description
---------------|-----------|------------
`recipient_id` | `integer` | **Required** the id of the user who should recieve this message
`subject`      | `string`  | **Required** the subject of the message (max: 140 characters)
`body`         | `string`  | **Required** the contents of the message (max: 64,000 characters)


#### Request (application/json)

        {
            "recipient_id": 92,
            "subject": "What's for dinner?",
            "body": "I'm so hungry I could eat a horse."
        }

#### Response 201 CREATED (application/json)

    Headers:

            Location: /messages/5

    Body:

            {
                "id": 5,
                "sender_id": 22,
                "recipient_id": 92,
                "subject": "What's for dinner?",
                "body": "I'm so hungry I could eat a horse.",
                "read": false
            }

#### Response 422 UNPROCESSABLE ENTITY (application/json)

            {
                "code" : 1024,
                "message" : "Validation Failed",
                "errors" : [
                {
                  "code" : 5432,
                  "field" : "subject",
                  "message" : "Subject has a maximum length of 140 characters"
                },
                {
                   "code" : 5622,
                   "field" : "body",
                   "message" : "The body cannot contain the word 'Ni'"
                }
              ]
            }

## Get a single message

    GET /messages/:id

#### Response 200 OK (application/json)

    Body:

            {
                "id": 5,
                "sender_id": 22,
                "recipient_id": 92
                "subject": "What's for dinner?",
                "body": "I'm so hungry I could eat a horse.",
                "read": false
            }

#### Response 404 NOT FOUND

## Delete a message

    DELETE /messages/:id

#### Response 204 NO CONTENT

#### Response 404 NOT FOUND

## Mark message as read

    PUT /messages/:id/read

#### Response 200 OK

#### Response 404 NOT FOUND

## Mark message as unread

    PUT /messages/:id/unread

#### Response 200 OK

#### Response 404 NOT FOUND

## Reply to a message

    POST /messages/:id/reply

#### Input

    Name   | Type     | Description
    -------|----------|------------
    `body` | `string` | **Required** the contents of the message (max: 64,000 characters)


#### Request (application/json)

            {
                "body": "Leave my horse alone! Go make a sandwich."
            }

#### Response 201 (application/json)

        {
            "id": 6,
            "sender_id": 92,
            "recipient_id": 22,
            "parent_id": 5
            "subject": "What's for dinner?",
            "body": "Leave my horse alone! Go make a sandwich.",
            "read": false
        }

## Get all the messages in the reply thread of this message

    GET /messages/:id/replies

#### Parameters

Name     | Type      | Description
---------|-----------|------------
`max_id` | `integer` | the largest id of the messages returned
`count`  | `integer` | maximum number of messages to return in the response (max: 100)

#### Response 200 OK (application/json)

    Headers:

        Link : <http://api.messagecenter.ex/messages?offset=25>; rel="next", <http:///api.messagecenter.ex/messages?offset=110>; rel="last"

    Body:
        {
            [
                {
                    "id": 5,
                    "sender_id": 22,
                    "recipient_id": 92
                    "subject": "What's for dinner?",
                    "body": "I'm so hungry I could eat a horse.",
                    "read": true
                },
                {
                    "id": 6,
                    "sender_id": 92,
                    "recipient_id": 22,
                    "parent_id": 5
                    "subject": "What's for dinner?",
                    "body": "Leave my horse alone! Go make a sandwich.",
                    "read": false
                }
            ]
        }
