FROM rocker/tidyverse:4.0.0

# install packages
RUN mkdir packages
COPY install_packages.R packages/
RUN Rscript packages/install_packages.R
