FROM python:2.7
USER root
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential libssl-dev libffi-dev python-dev

RUN set -x; \
		pip install cryptography \
	 && pip install wechatpy \
  	 && pip install redis \
  	 && pip install suds \
	 && pip install pika \
	 && pip install celery \
	 && apt-get install cron \
	 && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
#ADD ./supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisord.conf /etc/supervisord.conf
RUN mkdir -p /etc/supervisor/conf.d \
             /var/log/supervisor
VOLUME ["/etc/supervisor/conf.d","/etc/supervisor/apps","/var/log/supervisor"]
EXPOSE 9001 
#CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
ENTRYPOINT /etc/init.d/cron restart
CMD ["supervisord","-c","/etc/supervisord.conf"]
