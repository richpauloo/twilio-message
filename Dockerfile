FROM rocker/tidyverse:latest

ARG WHEN

RUN mkdir /home/code

RUN R -e "options(repos = \
  list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages('twilio')"

COPY run.R /home/code/run.R
COPY s.csv /home/code/s.csv
COPY .Renviron /home/code/.Renviron

CMD cd /home/code \
  && R -e "source('run.R')" \
  && mv /home/code/session_info.txt /home/results/session_info.txt \
  && mv /home/code/s.csv /home/results/s.csv
