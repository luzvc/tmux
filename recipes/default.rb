include_recipe "apt"

def setup_tmux(distribution, users, gist)
  update_repository distribution
  install_tmux_package

  users.each do |user|
    set_tmux_conf user, gist
  end
end

def update_repository(distribution)
  apt_repository "tmux" do
    uri          'http://ppa.launchpad.net/pi-rho/dev/ubuntu'
    distribution distribution if distribution
    components   ['main']
    keyserver    'hkp://keyserver.ubuntu.com:80'
    key          '69DFF912'
    action       :add
  end
end

def install_tmux_package
  package "tmux" do
    options "--force-yes"
    action :upgrade
  end
end

def set_tmux_conf(user, gist)
  if gist && gist.length > 0
    remote_file "Create .tmux.conf" do
      path "/home/#{user}/.tmux.conf"
      user user
      source gist
      not_if { File.exists?("/home/#{user}/.tmux.conf") }
    end
  end
end

users = node[:tmux][:users]
gist = node[:tmux][:gist]
distribution = node[:lsb][:codename]

setup_tmux(distribution, users, gist)
