from flask import render_template, request, redirect, abort, jsonify, url_for, session, Blueprint
from FindFolks.models import db, Member

from itsdangerous import TimedSerializer, BadTimeSignature
from passlib.hash import bcrypt_sha256
from flask import current_app as app
from FindFolks.config import SQLALCHEMY_DATABASE_URI
from sqlalchemy import create_engine
from sqlalchemy.sql import text

import logging, time, re, os, hashlib

auth = Blueprint('auth', __name__)

# uses mailgun API to send emails (proper code, but not approved)
def sendmail(addr, text):
    # 8 simple mailgun send
    return requests.post(
        "https://api.mailgun.net/v3/sandboxa934a03bddc04f4c921855c9c6fbc28e.mailgun.org/messages",
        auth=("api", "key-886baf72f7a96c51b9f14155716d86c1"),
        data={"from": "FindFolks",
              "to": [addr],
              "subject": "Message from FindFolks",
              "text": text})

# unfinished/unused as mailgun register not approved

# @auth.route('/reset_password', methods=['POST', 'GET'])
# @auth.route('/reset_password/<data>', methods=['POST', 'GET'])
# def reset_password(data=None):
#     if data is not None and request.method == "GET":
#         return render_template('reset_password.html', mode='set')
#     if data is not None and request.method == "POST":
#         try:
#             s = TimedSerializer(app.config['SECRET_KEY'])
#             name = s.loads(data.decode('base64'), max_age=1800)
#         except BadTimeSignature:
#             return render_template('reset_password.html', errors=['Your link has expired'])
#         member = Member.query.filter_by(name=name).first()
#         member.password = bcrypt_sha256.encrypt(request.form['password'].strip())
#         db.session.commit()
#         db.session.close()
#         return redirect('/login')
#
#     if request.method == 'POST':
#         email = request.form['email'].strip()
#         member = Member.query.filter_by(email=email).first()
#         if not member:
#             return render_template('reset_password.html', errors=['Check your email'])
#         s = TimedSerializer(app.config['SECRET_KEY'])
#         token = s.dumps(member.username)
#         text = """
# Did you initiate a password reset?
#
# {0}/reset_password/{1}
#
# """.format(app.config['HOST'], token.encode('base64'))
#
#         sendmail(email, text)
#
#         return render_template('reset_password.html', errors=['Check your email'])
#     return render_template('reset_password.html')

# 2 uses auth blueprint for web rendering (function runs when weburl visited)
@auth.route('/register', methods=['POST', 'GET'])  # 7
def register():
    if request.method == 'POST':
        errors = []
        firstname = request.form['firstname']  # 10 requests form with the
        lastname = request.form['lastname']    # corressponding name
        username = request.form['username']    # from the corressponding
        email = request.form['email']          # url, register.html is
        password = request.form['password']    # rendered, therefore retrieving
        zipcode = request.form['zipcode']      # value from line 61 for zipcode
        valid_zip = True
        try:
            zipcode = int(zipcode, 10)
        except:
            valid_zip = False

        # SQL queries
        name_len = len(username) == 0
        # 9 execute SQL using sqlalchemy
        usernames = [_ for _ in db.session.execute(
            text("SELECT COUNT(*) as user_count FROM member WHERE username = :Username"),  # counts number of users with username to see if its taken
            {"Username": username}  # username gets username
            )]
        username_used = usernames[0]["user_count"]
        emails = [_ for _ in db.session.execute(
            text("SELECT COUNT(*) as email_count FROM member WHERE email = :Email"),  # same as above but for emails
            {"Email": email}  # email gets email
            )]
        email_used = emails[0]["email_count"]

        pass_short = len(password) == 0
        pass_long = len(password) > 128
        valid_email = re.match("[^@]+@[^@]+\.[^@]+", request.form['email'])

        if not valid_email:
            errors.append("That email doesn't look right")
        if not valid_zip:
            errors.append("Invalid zip code given")
        if username_used:
            errors.append('That username is already taken')
        if email_used:
            errors.append('That email has already been used')
        if pass_short:
            errors.append('Pick a longer password')
        if pass_long:
            errors.append('Pick a shorter password')
        if name_len:
            errors.append('Pick a longer username')

        # render register.html with errors from line 18 as errors populated in this file if > 0
        if len(errors) > 0:
            return render_template('register.html', errors=errors)  # 2
        else:  # add member to database
            with app.app_context():
                member = Member(username, password, firstname, lastname, email, zipcode)  # note password gets hashed after passed to class
                db.session.add(member)
                db.session.commit()
            '''
            if mailserver():
                sendmail(request.form['email'], "You've successfully registered for FindFolks")
            '''

        db.session.close()

        return redirect('/login')  # go to @auth.route('/login') if registered properly
    return render_template('register.html')

# 7
@auth.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        errors = []
        username = request.form['username']
        password = request.form['password']
        member = [_ for _ in db.session.execute(
            text("SELECT password FROM member WHERE username = :Username"),  # selects password from corresponding user
            {"Username": username}
            )]
        if len(member) == 1 and bcrypt_sha256.verify(password, member[0][0]):  # verify password using bcrypt
            try:
                session.regenerate() # NO SESSION FIXATION FOR YOU
            except:
                pass
            session['username'] = username
            session['nonce'] = hashlib.sha512(os.urandom(10)).hexdigest()  # generate sha512 hash
            db.session.close()

            logger = logging.getLogger('logins')
            logger.warn("[{0}] {1} logged in".format(time.strftime("%m/%d/%Y %X"), session['username'].encode('utf-8')))

            return redirect('/home')
        else:
            errors.append("That account doesn't seem to exist")
            db.session.close()
            return render_template('login.html', errors=errors)  # 2
    else:
        db.session.close()
        return render_template('login.html')
