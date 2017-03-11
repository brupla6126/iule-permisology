
require 'araignee/architecture/storages/memory_table'
require 'cloporte/permisology/role/entities/role_memory'

include Cloporte::Permisology

Roles::Role = Roles::RoleMemory

Repository.register(Roles::Role) do |helpers|
  # helpers
  helpers[:creator] = Helpers::Creator.instance
  helpers[:deleter] = Helpers::Deleter.instance
  helpers[:finder] = Helpers::Finder.instance
  helpers[:updater] = Helpers::Updater.instance
  helpers[:validator] = Helpers::Validator.instance

  # storages
  helpers[:storage] = Storages::MemoryTable.new
end
