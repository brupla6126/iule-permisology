root = ::File.dirname(__FILE__)
require ::File.join(root, 'lib/iule/permisology', 'service.rb')

PermisologyService.root = Dir.pwd
run PermisologyService::PermisologyAPIv1
