resource "azurerm_policy_definition" "required_tag" {
  name         = "required-tag-policy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Required Tag Policy"
  description  = "Ensures that all resources include a required tag key."

  metadata = jsonencode({
    category = "Tagging"
  })

  policy_rule = file("${path.module}/policies/required-tags/policy.json")
  parameters  = file("${path.module}/policies/required-tags/parameters.json")
}

resource "azurerm_resource_group_policy_assignment" "required_tag_assignment_rg" {
  name                 = "enforce-required-tag-rg"
  policy_definition_id = azurerm_policy_definition.required_tag.id
  resource_group_id    = var.resource_group_id

  parameters = jsonencode({
    tagName = {
      value = "owner"
    }
  })
}
