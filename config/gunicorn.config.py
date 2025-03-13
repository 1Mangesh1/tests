bind = "0.0.0.0:5000"

# Sample Worker processes
workers = 6
worker_class = "uvicorn.workers.UvicornWorker"
timeout = 180
max_requests = 1
max_requests_jitter = 5
reload = True  # Enable hot reloading
reload_extra_files = []  # Add any extra files to watch if needed

# Ignore specific file patterns for reloading
# This prevents unnecessary reloads for certain file types
reload_ignore_files = [".*\.pyc", ".*\.py~", ".*\.log"]

def post_fork(server, worker):
    server.log.info("Worker spawned (pid: %s)", worker.pid)
