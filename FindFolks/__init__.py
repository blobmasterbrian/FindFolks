from flask import Flask, render_template, request, redirect, abort, session, jsonify, json as json_mod, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_session import Session
import logging, os, sqlalchemy, jinja2
from flask_oauth import OAuth

oauth = OAuth()

# returns formatted string of date
def format_datetime(date):
    return date.strftime("%Y-%m-%d %H:%M")

# creates the application and configures the database
def create_app(username="", password=""):
    app = Flask("FindFolks", static_folder="../static", template_folder="../templates")  # 1 create an instance of the class with WSGI
    app.jinja_env.filters['datetime'] = format_datetime  # 2 links filter function (format datetime) to Jinja for use in templating
    with app.app_context():  # 3 create application context
        app.config.from_object('FindFolks.config') # 4 loads application configuration from config.py

        from FindFolks.models import db  # import alchemy object from models.py
        db.init_app(app)  # 5 configure object to app
        db.create_all()  # 5 creates all tables (prevents the intended setup.py use)

        app.db = db  # set apps database to created database

        Session(app)  # 6 creates a server side session on the app

        from FindFolks.views import views  # import views from views.py
        from FindFolks.auth import auth  # import auth from auth.py

        from FindFolks.errors import init_errors  # import init_errors from errors.py
        init_errors(app)  # initialize errors

        app.register_blueprint(views)  # 7 register blueprint for easy web rendering
        app.register_blueprint(auth)  # 7 register blueprint for easy web rendering

        return app  # return application
