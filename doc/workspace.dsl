workspace "Random Walk Architecture" "Full Architecture in C4 Notation" {
    model {
        user = person "Client" "Use app for searching user partner"
        random_walk = softwareSystem "Random Walk" "Service for searching walk partners"
        google_oauth_provider = softwareSystem "OAuth Google provider" "Authorization provider for simple and fast login"

        user -> random_walk "Uses"
        random_walk -> google_oauth_provider "Uses for authorization"
    }

    configuration {
        scope softwaresystem
    }

    views {
        systemContext random_walk "Context" {
            include *
            autolayout lr
        }

        container random_walk "Container" {
            include *
            autolayout lr
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
        }
    }
}