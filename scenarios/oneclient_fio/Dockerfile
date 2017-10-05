FROM onedata/oneclient:17.06.0-rc4
MAINTAINER Cristovao Cordeiro <cris@sixsq.com>

RUN apt-get install -y ioping

ADD run_app.sh /root/run_app.sh
RUN chmod +x /root/run_app.sh

ADD cron_app /etc/cron.d/cron_app
RUN crontab /etc/cron.d/cron_app
RUN chmod 0644 /etc/cron.d/cron_app

RUN systemctl enable cron

ADD run.sh /root/run.sh
