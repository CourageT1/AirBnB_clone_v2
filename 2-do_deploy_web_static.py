#!/usr/bin/python3
# Fabfile to distribute an archive to a web server.
from fabric.api import env, put, run
import os

env.hosts = ['52.86.245.35', '18.234.129.196']
env.user = 'ubuntu'


def do_deploy(archive_path):
    if not os.path.exists(archive_path):
        return False
    
    put(archive_path, '/tmp/')
    filename = os.path.basename(archive_path)
    filename_noext = os.path.splitext(filename)[0]
    
    remote_release = '/data/web_static/releases/{}/'.format(filename_noext)
    run('mkdir -p {}'.format(remote_release))
    run('tar -xzf /tmp/{} -C {}'.format(filename, remote_release))
    
    run('rm /tmp/{}'.format(filename))
    run('rm -rf /data/web_static/current')
    
    run('mv {0}web_static/* {0}'.format(remote_release))
    run('rm -rf {0}web_static'.format(remote_release))
    
    run('ln -s {0} /data/web_static/current'.format(remote_release))
    
    return True
