FROM f0nzie/rstudio
MAINTAINER Alfonso Reyes

# install python-dev. This affects the .so library loading
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    zlib1g-dev \
    python-dev

# copy local file and run get-pip.py
COPY get-pip.py /home/rstudio

# install get-pip and virtualenv
RUN python /home/rstudio/get-pip.py
RUN pip install virtualenv

# install devtools, tensorflow and install inside R as rstudio user
USER rstudio
RUN install2.r --error \
    devtools \
    tensorflow \
## install tensorflow from within R. tensorflow installed in own environment
    && R -e "tensorflow::install_tensorflow()"

# leave rstudio user and come back as root
USER root

