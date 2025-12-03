# Grab the latest alpine-based Python image
FROM python:3.11.7-alpine

# Install bash
RUN apk add --no-cache bash

# Copy requirements file
COPY ./webapp/requirements.txt /tmp/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -q -r /tmp/requirements.txt

# Copy application code
COPY ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Create and switch to a non-root user
RUN adduser -D myuser
USER myuser

# Expose port 
ENV PORT=5000

# Run the app (JSON notation for CMD)
CMD gunicorn --bind 0.0.0.0:$PORT wsgi
