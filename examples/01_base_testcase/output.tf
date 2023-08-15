output "id" {
  description = "The ID of the Storage Container."
  value       = module.containerone.id
}

output "has_immutability_policy" {
  description = "Is there an Immutability Policy configured on this Storage Container?"
  value       = module.containerone.has_immutability_policy
}

output "has_legal_hold" {
  description = "Is there a Legal Hold configured on this Storage Container?"
  value       = module.containerone.has_legal_hold
}

output "resource_manager_id" {
  description = "The Resource Manager ID of this Storage Container."
  value       = module.containerone.id
}

output "name" {
  description = "Resource name"
  value       = module.containerone.name
}
