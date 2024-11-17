workspace "Random Walk Architecture" "Full Architecture in C4 Notation" {
    model {
        properties {
            "structurizr.groupSeparator" "/"
        }
        user = person "Client" "Use app for searching user partner"
        random_walk = softwareSystem "Random Walk" "Service for searching walk partners" {
            group "UI" {
                app = container "Mobile App" "Application for interacting with UI" {
                    tags "MobileAppTag"
                }
            }
            group "Backend" {
                chat_service = container "Chat service" "Service for user chatting"
                auth_service = container "Auth service" "Service for user authentication/authorization"
                matcher_service = container "Matcher service" "Service for user appointment matching"
                club_service = container "Club service" "Service for user club joining"
                group "Infrastructure" {
                    postgres_db = container "Postgres Database" "Storage for user authentication data, messages, appointments and clubs" {
                        tags "DatabaseTag"
                    }
                    active_mq_artemis = container "ActiveMQ Artemis" "Responsible for routing messages in Chat service instances" {
                        tags "MessageQueueTag"
                    }
                }

                chat_service -> postgres_db "Read/Write messages"
                auth_service -> postgres_db "Read/Write user authentication data"
                matcher_service -> postgres_db "Read/Write appointment data"
                club_service -> postgres_db "Read/Write club data"
                chat_service -> active_mq_artemis "Send message from user"
                active_mq_artemis -> chat_service "Send message for user in Chat service instances"
            }

            app -> chat_service "Use for sending and receiving messages"
            app -> auth_service "Use for login / logout / refresh access token"
            app -> matcher_service "Use for editing appointment preferences / available time slots"
            app -> club_service "Use for joining to groups / sending form and invitations / creating and administrating groups"
        }
        google_oauth_provider = softwareSystem "OAuth Google provider" "Authorization provider for simple and fast login"

        user -> random_walk "Uses"
        random_walk -> google_oauth_provider "Uses for authorization"
    }

    views {
        systemContext random_walk "Context" {
            include *
            autolayout lr
        }

        container random_walk "Container" {
            include *
            autolayout lr 400 150
        }

        theme default

        styles {
            element "Software System" {
                color black
                background #93fc51
            }
            element "Person" {
                color black
                background #51fc9b
            }
            element "Container" {
                background #04de63
            }
            relationship "Relationship" {
                thickness 1
                color yellow
            }
            element "MobileAppTag" {
                shape MobileDevicePortrait
            }
            element "DatabaseTag" {
                shape Cylinder
                width 250
                background purple
                strokeWidth 10
            }
            element "MessageQueueTag" {
                shape Pipe
                background red
                strokeWidth 10
                width 500
            }
        }
    }

    configuration {
        scope softwaresystem
    }
}