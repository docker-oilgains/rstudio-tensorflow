FROM f0nzie/rstudio
MAINTAINER Alfonso R. Reyes

# install python-dev. This affects the .so library loading
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    zlib1g-dev \
    python-dev

# install RCurl and devtools
RUN install2.r --error \
     RCurl \
     devtools

# copy local file and run get-pip.py
COPY get-pip.py /home/rstudio

# install get-pip and virtualenv
RUN python /home/rstudio/get-pip.py \
	&& pip install virtualenv \
	&& install2.r --error tensorflow

# install tensorflow inside R as rstudio user
# will use Python environment under rstudio folder
USER rstudio
RUN R -e "tensorflow::install_tensorflow()"

# go back to root user, otherwise gives error
USER root
