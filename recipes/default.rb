include_recipe "apt"

package "libevent-dev"
package "libncurses-dev"
package "pkg-config"

remote_file "Create .tmux.conf" do
  path "/home/vagrant/.tmux.conf"
  user "vagrant"
  source "https://gist.github.com/azisaka/b943f490845705e42165/raw/tmux.conf"
  creates "/home/vagrant/.tmux.conf"
end

remote_file "Create .zshrc.d/tmux" do
  path "/home/vagrant/.zshrc.d/tmux"
  user "vagrant"
  source "https://gist.github.com/azisaka/b943f490845705e42165/raw/zshrc"
  creates "/home/vagrant/.zshrc.d/tmux"
end

bash "Compile tmux" do
  code %Q{
    cd /tmp
    tar xzvf /tmp/tmux-1.8.tar.gz
    mv /tmp/tmux-1.8 /usr/local/src
    autoreconf -fis
    ./configure --prefix /usr/local/tmux-1.8
    make
    make install
  }
  action :nothing
  notifies "remote_file[Create .tmux.conf]"
end

remote_file "Download tmux" do
  path "/tmp/tmux-1.8.tar.gz"
  user "vagrant"
  source "http://downloads.sourceforge.net/project/tmux/tmux/tmux-1.8/tmux-1.8.tar.gz"
  not_if { File.exist?("/usr/local/src/tmux-1.8") }
  notifies "bash[Compile tmux]"
end
