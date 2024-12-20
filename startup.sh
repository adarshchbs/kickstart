#!/bin/bash

# Start Jupyter Lab
pm2 start "jupyter-lab --ip 0.0.0.0 --port $JUPYTER_PORT --allow-root --no-browser" --name jupyter-server

# Start Code Server
pm2 start "code-server --bind-addr 0.0.0.0:$CODE_SERVER_PORT" --name code-server

# Keep container running and show logs
pm2 logs
