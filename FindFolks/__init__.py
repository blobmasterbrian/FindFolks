from flask import Flask, render_template, request, redirect, abort, session, jsonify, json as json_mod, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_session import Session
import logging, os, sqlalchemy, jinja2
from flask_oauth import OAuth

oauth = OAuth()

def format_datetime(date):
    return date.strftime("%Y-%m-%d %H:%M")

def create_app(username="", password=""):
    app = Flask("FindFolks", static_folder="../static", template_folder="../templates")
    app.jinja_env.filters['datetime'] = format_datetime
    with app.app_context():
        app.config.from_object('FindFolks.config')

        from FindFolks.models import db
        db.init_app(app)
        db.create_all()

        app.db = db

        Session(app)

        from FindFolks.views import views
        from FindFolks.auth import auth

        from FindFolks.errors import init_errors
        init_errors(app)

        app.register_blueprint(views)
        app.register_blueprint(auth)

        return app
