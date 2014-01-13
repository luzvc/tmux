include_recipe "apt"

apt_repository "tmux" do
  uri          'http://ppa.launchpad.net/pi-rho/dev/ubuntu'
  distribution node['lsb']['codename']
  components   ['main']
end

package "tmux"

node['tmux']['users'].each do user
  remote_file "Create .tmux.conf" do
    path "/home/#{user}/.tmux.conf"
    user user
    source "https://gist.github.com/azisaka/b943f490845705e42165/raw/tmux.conf"
    not_if { File.exists?("/home/#{user}/.tmux.conf") }
  end

  remote_file "Create .zshrc.d/tmux" do
    path "/home/#{user}/.zshrc.d/tmux"
    user user
    source "https://gist.github.com/azisaka/b943f490845705e42165/raw/zshrc"
    not_if { File.exists?("/home/#{user}/.zshrc.d/tmux") }
  end
end
