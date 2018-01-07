import flask

import routes

from pypi_popular.core.settings import settings

app = flask.Flask(__name__)

@app.route('/')
def root():
    return flask.jsonify({})

for name, blueprint in routes.__dict__.items():
    if isinstance(blueprint, flask.Blueprint):
        app.register_blueprint(blueprint)

if __name__ == "__main__":
    settings_dct = settings()
    debug = settings_dct.get('FLASK_DEBUG', False)
    app.run(host='0.0.0.0', debug=bool(debug))
