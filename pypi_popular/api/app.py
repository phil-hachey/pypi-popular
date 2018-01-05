import flask

import routes

app = flask.Flask(__name__)

@app.route('/')
def root():
    return flask.jsonify({})

for name, blueprint in routes.__dict__.items():
    if isinstance(blueprint, flask.Blueprint):
        app.register_blueprint(blueprint)

if __name__ == "__main__":
    app.run(host='0.0.0.0')
