workspace "Random Walk Architecture" "Full Architecture in C4 Notation" {
    model {
        user = person "Client" "Use app for searching user partner"
        random_walk = softwareSystem "Random Walk" "Service for searching walk partners" {
            group "UI" {
                app = container "Mobile App" "Application for interacting with UI"
            }
            group "Backend" {
                chat_service = container "Chat service" "Service for user chatting"
                auth_service = container "Auth service" "Service for user authentication/authorization"
                matcher_service = container "Matcher service" "Service for user appointment matching"
                club_service = container "Club service" "Service for user club joining"
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
            autolayout lr 0 30
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
        }
    }

    configuration {
        scope softwaresystem
    }
}