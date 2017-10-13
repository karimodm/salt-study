import argparse
import sys
from aiohttp import web

from mongo_app.main import build_app, configure_logging

app = build_app()
configure_logging(app)
