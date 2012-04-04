include_recipe "htauth"

node[:nginx][:apps].each do |app_name, app_attributes|
  bag = data_bag_item("amee_projects", app_name)
  app_root = "/var/www/apps/#{app_attributes[:server_name]}-#{node.chef_environment}/"
  nginx_app "#{app_name}-#{node.chef_environment}.#{bag['domain']}" do
    server_port                 app_attributes[:server_port]
    server_name                 "#{app_attributes[:server_name]}-#{node.chef_environment}.#{bag['domain']}"
    public_path                 "#{app_root}current/public"
    htauth                      app_attributes[:htauth]
    access_control              app_attributes[:access_control]
    custom_location_directives  app_attributes[:custom_location_directives]
    proxy_type                  app_attributes[:proxy_type]
    upstream_servers            app_attributes[:upstream_servers]
    custom_directives           app_attributes[:custom_directives]
    action                      app_attributes[:action]
  end

  if app_attributes[:htauth]
    htauth "nginx" do
      file "#{app_root}current/public/htpasswd"
      logins app_attributes[:htlogins]
      action :create
    end
  end
end


