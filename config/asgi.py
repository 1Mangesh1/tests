"""
ASGI config for RBP API project.
It exposes the ASGI callable as a module-level variable named ``application``.
For more information on this file, see
https://docs.djangoproject.com/en/dev/howto/deployment/asgi/
"""

import os
import sys
from pathlib import Path


from django.core.asgi import get_asgi_application

# This allows easy placement of apps within the interior
# review_board_api directory.
ROOT_DIR = Path(__file__).resolve(strict=True).parent.parent
sys.path.append(str(ROOT_DIR / "my_awesome_project"))

# If DJANGO_SETTINGS_MODULE is unset, default to the local settings
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings.local")

# This application object is used by any ASGI server configured to use this file.
django_application = get_asgi_application()


async def application(scope, receive, send):
    if scope["type"] == "http":
        await django_application(scope, receive, send)
    else:
        raise NotImplementedError(f"Unknown scope type {scope['type']}")
