import asyncpg
from quart import Quart

from films import blueprint as films_blueprint
from reviews import blueprint as reviews_blueprint


def create_app():
    app = Quart(__name__)
    app.config['JSONIFY_PRETTYPRINT_REGULAR'] = False

    @app.before_first_request
    async def create_db():
        dsn = "postgresql://dvdrental@localhost:5432/dvdrental?password=dvdrental"  # noqa: E501
        # (or) os.environ['DB_DSN'])
        app.pool = await asyncpg.create_pool(dsn, max_size=20)

    app.register_blueprint(films_blueprint)
    app.register_blueprint(reviews_blueprint)

    return app


if __name__ == '__main__':
    create_app().run()
