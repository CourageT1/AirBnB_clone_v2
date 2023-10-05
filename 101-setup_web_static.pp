# web_server_setup.pp

# Install Nginx if not already installed
package { 'nginx':
  ensure => installed,
}

# Create necessary directories and files
file { '/data/web_static/releases/test/':
  ensure => directory,
  mode   => '0755',
}

file { '/data/web_static/shared/':
  ensure => directory,
  mode   => '0755',
}

file { '/data/web_static/releases/test/index.html':
  ensure  => present,
  mode    => '0644',
  content => "Hello, this is a test HTML file.\n",
}

# Create symbolic link, deleting it if it already exists
file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test/',
  force  => true,
}

# Set ownership to ubuntu user and group recursively
file { '/data/':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  recurse => true,
}

# Configure Nginx to serve content and restart Nginx
file { '/etc/nginx/sites-available/default':
  ensure  => present,
  content => "server {
    listen 80;
    server_name _;
    location /hbnb_static {
        alias /data/web_static/current/;
        index index.html;
    }
    error_page 404 /404.html;
    location = /404.html {
        root /usr/share/nginx/html;
        internal;
    }
}
",
  require => Package['nginx'],
  notify  => Service['nginx'],
}

service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
}
