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
                api_gateway = container "Api Gateway" "Service for routing traffic"
                group "Chat service" {
                    chat_service = container "Chat service" "Service for user chatting"
                    postgres_db_chat_schema = container "Postgres Database [chat schema]" "Storage for messages and chats" {
                        tags "DatabaseTag"
                    }

                    chat_service -> postgres_db_chat_schema "Read/Write messages"
                }
                group "Auth service" {
                    auth_service = container "Auth service" "Service for user authentication/authorization"
                    postgres_db_auth_schema = container "Postgres Database [auth schema]" "Storage for user authentication data" {
                        tags "DatabaseTag"
                    }
                    auth_service -> postgres_db_auth_schema "Read/Write user authentication data"
                }
                group "Matcher service" {
                    matcher_service = container "Matcher service" "Service for user appointment matching"
                    postgres_db_matcher_schema = container "Postgres Database [matcher schema]" "Storage for appointments and walk prefferences data" {
                        tags "DatabaseTag"
                    }
                    matcher_service -> postgres_db_matcher_schema "Read/Write appointment data"
                }
                group "Club service" {
                    club_service = container "Club service" "Service for user club joining"
                    postgres_db_club_schema = container "Postgres Database [club schema]" "Storage for clubs and forms data" {
                        tags "DatabaseTag"
                    }
                    club_service -> postgres_db_club_schema "Read/Write club data"
                }
                active_mq_artemis = container "ActiveMQ Artemis" "Responsible for routing messages in Chat service instances" {
                    tags "MessageQueueTag"
                }

                matcher_service -> active_mq_artemis "Send creating chats events after matching"
                active_mq_artemis -> chat_service "Consume creating chat event and do it"
                active_mq_artemis -> chat_service "Send message for user in Chat service instances" {
                    tag "STOMPLinkTag"
                }
                chat_service -> active_mq_artemis "Send message from user" {
                    tag "STOMPLinkTag"
                }
                auth_service -> active_mq_artemis "Send info about registered users in matcher-service"
                active_mq_artemis -> matcher_service "Get info about registered users from auth-service"
            }

            app -> api_gateway "Use for sending request and receiving some data"
            api_gateway -> chat_service "Use for sending and receiving messages"
            api_gateway -> auth_service "Use for login / logout / refresh access token"
            api_gateway -> matcher_service "Use for editing appointment preferences / available time slots"
            api_gateway -> club_service "Use for joining to groups / sending form and invitations / creating and administrating groups"
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
                color black
                background #04de63
            }
            relationship "Relationship" {
                thickness 1
                color black
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
            relationship "STOMPLinkTag" {
                color green
                thickness 2
            }
        }
    }

    configuration {
        scope softwaresystem
    }
}