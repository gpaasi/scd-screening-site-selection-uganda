
FROM rocker/r-base:4.3.1

RUN apt-get update && apt-get install -y libgdal-dev libgeos-dev libproj-dev libudunits2-dev     && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('terra','dplyr','data.table','readr','sf','sp','gdistance','classInt'), repos='https://cloud.r-project.org')"

WORKDIR /work
CMD ["bash"]
