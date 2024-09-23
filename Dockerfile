# # FROM python:3.7.0

# # COPY . /

# # WORKDIR /

# # RUN pip install -r requirements.txt

# # ENV HOST 0.0.0.0

# # ENV PORT $PORT

# # CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# # '''top is origin code'''

# FROM python:3.12.2

# # COPY ./requirements.txt /requirements.txt
# # COPY ./src /app
# # WORKDIR /app

# COPY . /

# WORKDIR /

# # RUN python -m venv /py && \
# #     /py/bin/pip install --upgrade pip && \
# #     /py/bin/pip install -r /requirements.txt && \
# # #     adduser --disabled-password --no-create-home django-user

# RUN pip install --upgrade pip==24.0.0
# RUN pip install poetry

# ENV PATH="/py/bin:$PATH"
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# RUN adduser django-user
# USER django-user

# RUN poetry check
# RUN poetry install --no-interaction --no-cache --without dev

# ENV POETRY_VIRTUALENVS_IN_PROJECT=true
# ENV VIRTUAL_ENV=/CURD/.venv

# # Gunicorn as app server
# CMD exec gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 8 --timeout 0 localWebsite.wsgi:application

FROM python:3.12.2

# 複製應用程式代碼
COPY . /CRUD
WORKDIR /CRUD

# 更新 pip 並安裝 poetry
RUN pip install --upgrade pip==24.0.0
RUN pip install poetry

# 設置虛擬環境路徑為 /CRUD/.venv 並將其添加到 PATH
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV VIRTUAL_ENV=/CRUD/.venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# 創建 django-user 並將權限設置為 /CRUD 目錄
RUN adduser django-user
RUN chown -R django-user /CRUD

# 切換到 django-user
USER django-user

# 檢查並安裝依賴
RUN poetry check
RUN poetry install --no-interaction --no-cache
# RUN poetry install --no-interaction --no-cache --without dev

# Gunicorn 作為應用伺服器
CMD exec gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 8 --timeout 0 demo.wsgi:application
