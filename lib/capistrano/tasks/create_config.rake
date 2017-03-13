namespace :config do
  desc 'Create configuration files in config, based on the .erb files in config/deploy/config.'
  task :generate do
    on roles(:app, :service) do
      execute "mkdir -p #{shared_path}/config"

      Dir["config/deploy/config/*.erb"].each do |template_file|
        content = StringIO.new(ERB.new(File.read(template_file)).result(binding))

        config_file = File.basename(template_file, '.erb')

        upload! content, "#{shared_path}/config/#{config_file}"
      end
    end
  end

  desc 'Create symlinks in the config directory pointing to the generated config files.'
  task :symlink do
    on roles(:app, :service) do
      Dir["config/deploy/config/*.erb"].map {|f| File.basename(f, '.erb')}.each do |config_file|
        execute "ln -nfs #{shared_path}/config/#{config_file} #{release_path}/config/#{config_file}"
      end
    end
  end
end

before "deploy:symlink:shared", "config:generate"
after "config:generate", "config:symlink"

