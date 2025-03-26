# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install project dependencies using Poetry
RUN pip install poetry && poetry config virtualenvs.create false && poetry install --no-dev

# Expose port (modify if your app serves on a different port)
EXPOSE 8000

# Run the application (modify to your entrypoint)
CMD ["python", "scripts/main.py"]
