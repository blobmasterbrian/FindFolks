from flask import current_app as app, render_template

def init_errors(app):
    @app.errorhandler(404)  # 7 triggers function
    def page_not_found(error):
        return render_template('errors/404.html'), 404

    @app.errorhandler(403)  # 7 triggers function
    def forbidden(error):
        return render_template('errors/403.html'), 403

    @app.errorhandler(500)  # 7 triggers function
    def general_error(error):
        return render_template('errors/500.html'), 500

    @app.errorhandler(502)  # 7 triggers function
    def gateway_error(error):
        return render_template('errors/502.html'), 502
