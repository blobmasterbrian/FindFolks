from FindFolks.models import db

from urlparse import urlparse, urljoin
from functools import wraps
from flask import current_app as app, g, request, redirect, url_for, session

def init_utils(app):  # utilities initialization unused
    #app.jinja_env.globals.update()
    pass
