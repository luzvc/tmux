include_recipe "apt"

package "libevent-dev"
package "libncurses-dev"
package "pkg-config"
package "build-essential"

bash "Compile tmux" do
  code %Q{
    cd /tmp
    tar xzvf /tmp/tmux-1.8.tar.gz
    rm /tmp/tmux-1.8.tar.gz
    mv /tmp/tmux-1.8 /usr/local/src
    cd /usr/local/src/tmux-1.8
    autoreconf -fis
    ./configure --prefix /usr/local/tmux-1.8
    make
    make install
  }
  action :nothing
  notifies :create, "remote_file[Create .tmux.conf]"
end

remote_file "Download tmux" do
  path "/tmp/tmux-1.8.tar.gz"
  source "http://downloads.sourceforge.net/project/tmux/tmux/tmux-1.8/tmux-1.8.tar.gz"
  not_if { File.exist?("/usr/local/src/tmux-1.8") }
  notifies :run, "bash[Compile tmux]"
end

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
