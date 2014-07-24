include_recipe "n98-magerun"

node['n98-magerun']['modules_list'].each do |moduleName, moduleSource|
    if moduleSource == nil || moduleSource == ''
        next
    end

    module_path = "#{node['n98-magerun']['modules_dir']}/#{moduleName}"

    directory module_path do
        mode "0775"
        owner "root"
        group "root"
        action :create
    end

    git module_path do
        repository moduleSource
        revision "master"
        action :sync
        user "root"
        group "root"
    end

end
