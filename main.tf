resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = true,
        "description" = "GET user ID via email",
        "properties" = {
            "email" = {
                "description" = "The email address from a user.",
                "type" = "string"
            }
        },
        "required" = [
            "email"
        ],
        "title" = "UserIdRequest",
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = true,
        "description" = "Returns a userID.",
        "properties" = {
            "results.id" = {
                "description" = "The User ID of an agent",
                "type" = "string"
            }
        },
        "title" = "Get a userID based on an email address given",
        "type" = "object"
    })
    
    config_request {
        request_template     = "{\r\n  \"query\": [\r\n     {\r\n        \"value\": \"$${input.email}\",\r\n        \"fields\": [\"workemail\",\"email\"],\r\n        \"type\": \"EXACT\"\r\n     }\r\n  ]\r\n}\r\n}"
        request_type         = "POST"
        request_url_template = "/api/v2/users/search"
        headers = {
			Content-Type = "application/json"
		}
    }

    config_response {
        success_template = "{\"results.id\":$${results_id}}"
        translation_map = { 
			results_id = "$.results[0].id"
		}
    }
}