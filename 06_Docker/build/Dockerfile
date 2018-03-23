FROM ubuntu:16.04
MAINTAINER Carles San Agustin

ADD xescudero.sh /xescudero.sh
RUN /bin/bash /xescudero.sh

CMD ["/usr/bin/node", "/opt/ait/server/start.js"]
