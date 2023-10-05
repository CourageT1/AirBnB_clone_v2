#!/usr/bin/python3
"""Fabric script to generate a .tgz archive from web_static folder"""

from fabric.api import local
from datetime import datetime
import os


def do_pack():
    """Packs web_static files into a .tgz archive"""
    if not os.path.exists("versions"):
        local("mkdir -p versions")
    time_format = "%Y%m%d%H%M%S"
    archive_name = "web_static_{}.tgz".format(datetime.now().strftime(time_format))
    result = local("tar -czvf versions/{} web_static".format(archive_name))
    if result.succeeded:
        return "versions/{}".format(archive_name)
    else:
        return None
