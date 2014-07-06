magerun_path = "#{node['n98-magerun']['install_dir']}/#{node['n98-magerun']['install_file']}"

remote_file magerun_path do
  source node['n98-magerun']['url']
  path magerun_path
  owner 'root'
  group 'root'
  mode '0775'
  backup false
  action :nothing
end.run_action(:create)

if node['n98-magerun']['unstable']
  execute "#{magerun_path} self-update --unstable"
end

if node['n98-magerun']['auto_update']
    execute "#{magerun_path} self-update"
end

directory node['n98-magerun']['source_dir'] do
    mode "0777"
    owner "ubuntu"
    group "ubuntu"
    action :create
    recursive true
end

directory node['n98-magerun']['modules_dir'] do
    mode "0777"
    owner "ubuntu"
    group "ubuntu"
    action :create
    recursive true
end

git node['n98-magerun']['source_dir'] do
   repository node['n98-magerun']['git_url']
   revision node['n98-magerun']['git_revision']
   action :sync
   user "ubuntu"
   group "ubuntu"
end

bash 'install_n98-magerun_autocomplete' do
    cwd node['n98-magerun']['source_dir']
    code <<-EOF
        cp autocompletion/bash/bash_complete /etc/bash_completion.d/n98-magerun.phar
    EOF
    not_if do
     ::File.exists?("/etc/bash_completion.d/n98-magerun.phar")
    end
    creates "/etc/bash_completion.d/n98-magerun.phar"
end
