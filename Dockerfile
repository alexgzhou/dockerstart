FROM python:3.4-alpine
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
EXPOSE 80
ENV NAME World
CMD ["python", "app.py"]