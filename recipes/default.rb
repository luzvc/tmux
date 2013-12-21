include_recipe "apt"

package "vim"

directory "/home/vagrant/.vim/bundle" do
  owner "vagrant"
  group "vagrant"
  action :create
  recursive true
end

git "/home/vagrant/.vim/bundle/vundle" do
  user "vagrant"
  repository "https://github.com/gmarik/vundle.git"
  action :sync
end

remote_file "Create or update .vimrc" do
  path "/home/vagrant/.vimrc"
  user "vagrant"
  source "https://gist.github.com/azisaka/b943f490845705e42165/raw/vimrc"
end

execute "Install dependencies with Vundle" do
  user "vagrant"
  command "vim -c 'set shortmess=at' +BundleInstall +qa"
  environment 'HOME' => '/home/vagrant'
  timeout 500
  command "vim -c 'set shortmess=at' +BundleInstall +qa"
end

