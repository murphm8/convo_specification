# Messaging API

Allows users to send, receive, and reply to messages.

## List Messages

List the authenticated user's messages

    GET /messages

List all the authenticated user's unread messages

  GET /messages/unread

### Parameters

Name     | Type      | Description
---------|-----------|------------
`offset` | `integer` | the count to start at for this request (should be a multiple of count)
`count`  | `integer` | maximum number of messages to return in the response (max: 100)


+ Response 200 (application/json)

    + Headers

            Link : <http://api.messagecenter.ex/messages?offset=10>; rel="next", <http:///api.messagecenter.ex/messages?offset=110>; rel="last"

    + Body

            [
                {
                    "id": 1,
                    "sender_id": 22,
                    "recipient_id": 92,
                    "subject": "Favorite programming language?",
                    "body": "I really like Fortran."
                    "read": true
                },
                {
                    "id": 5,
                    "sender_id": 22,
                    "recipient_id": 92
                    "subject": "What's for dinner?",
                    "body": "I'm so hungry I could eat a horse."
                    "read": false
                },
            ]


### Create a New Message [POST]

This creates a new message with the logged in user as the sender.

+ Request (application/json)

        {
            "recipient_id": 92,
            "subject": "What's for dinner?",
            "body": "I'm so hungry I could eat a horse."
        }

+ Response 201 (application/json)

    + Headers

            Location: /messages/5

    + Body

            {
                "id": 5,
                "sender_id": 22,
                "recipient_id": 92,
                "subject": "What's for dinner?",
                "body": "I'm so hungry I could eat a horse."
            }

+ Response 422 (application/json)

    + Body

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
## Unread messages for the logged in user [/messages/unread]

### Get all unread messages [GET]



## Individual Message [/messages/{message_id}]

### Get the message specified by ID [GET]

+ Parameters
    + message_id (number) - ID of the message

+ Response 200 (application/json)

    + Body

            {
                "id": 5,
                "sender_id": 22,
                "recipient_id": 92
                "subject": "What's for dinner?",
                "body": "I'm so hungry I could eat a horse."
            }

### Send message to the Trash [DELETE]

+ Parameters
    + message_id (number) - ID of the message


+ Response 204

## Mark message as read
    PUT /messages/{message_id}/read

## Mark Message as unread
    PUT /messages/{message_id}/unread


## Reply to Message [/messages/{message_id}/reply]

### Create Reply [POST]

+ Parameters
    + message_id (number) - ID of the message

+ Request (application/json)

            {
                "body": "Leave my horse alone! Go make a sandwich."
            }

+ Response 201 (application/json)

        {
            "id": 6,
            "sender_id": 92,
            "recipient_id": 22,
            "parent_id": 5
            "subject": "What's for dinner?",
            "body": "Leave my horse alone! Go make a sandwich."
        }

## Replies Collection [/messages/{message_id}/replies]

### Get all the messages in the reply thread of this message [GET]

+ Parameters

      + message_id (number) - ID of the message

+ Response 200 (application/json)

        {
            [
                {
                    "id": 5,
                    "sender_id": 22,
                    "recipient_id": 92
                    "subject": "What's for dinner?",
                    "body": "I'm so hungry I could eat a horse."
                },
                {
                    "id": 6,
                    "sender_id": 92,
                    "recipient_id": 22,
                    "parent_id": 5
                    "subject": "What's for dinner?",
                    "body": "Leave my horse alone! Go make a sandwich."
                }
            ]
        }
