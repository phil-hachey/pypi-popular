import flask
from webargs import fields
from webargs.flaskparser import use_kwargs
from marshmallow.validate import Length

import logging
logger = logging.getLogger(__name__)

blueprint = flask.Blueprint('package', __name__)


@blueprint.record
def config(setup_state):
    app = setup_state.app
    blueprint.config = app.config


@blueprint.route('/packages')
@use_kwargs({
    'name': fields.Str(
        missing=None,
        validate=Length(min=3))
})
def get_list(name):
    return flask.jsonify([{
        'id': 'id1',
        'name': 'ansible',
        'total_downloads': 10101,
    }])


@blueprint.route('/packages/<package_id>')
def get(package_id):
    return flask.jsonify({
        'id': 'id1',
        'name': 'ansible',
        'total_downloads': 10101,
    })
