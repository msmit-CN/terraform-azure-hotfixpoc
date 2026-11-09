# Regression test: group tags must be merged with module tags, not replace them.
mock_provider "azurerm" {}

run "group_tags_merge_with_module_tags" {
  command = plan

  variables {
    location = "westeurope"
    tags     = { environment = "test" }
    groups = {
      alpha = {
        name = "rg-alpha"
        tags = { owner = "platform" }
      }
    }
  }

  assert {
    condition     = azurerm_resource_group.this["alpha"].tags == tomap({ environment = "test", owner = "platform" })
    error_message = "group tags must be merged with module tags, got ${jsonencode(azurerm_resource_group.this["alpha"].tags)}"
  }
}
