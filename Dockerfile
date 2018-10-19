# define parent
FROM python:3.7

# define maintainer
LABEL maintainer="christoph.birk@googlemail.com" \
      application="python-kube-client" \
      version="1.0"

RUN pip install "urllib3>=1.21.1,<1.23" 
RUN pip install kubernetes

CMD python3 