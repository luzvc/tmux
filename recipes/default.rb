include_recipe "apt"

apt_repository "tmux" do
  uri          'http://ppa.launchpad.net/pi-rho/dev/ubuntu'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'hkp://keyserver.ubuntu.com:80'
  key          '69DFF912'
  action       :add
end

package "tmux" do
  options "--force-yes"
  action :upgrade
end

node['tmux']['users'].each do |user|
  remote_file "Create .tmux.conf" do
    path "/home/#{user}/.tmux.conf"
    user user
    source "#{node['tmux']['gist']}"
    not_if { File.exists?("/home/#{user}/.tmux.conf") }
  end
end
