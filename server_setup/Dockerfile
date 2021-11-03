FROM rstudio/rstudio-server-pro:latest

# Set default environment variables -------------------------------------------#

ENV RSP_LAUNCHER false
ENV RSP_TESTUSER ""

ENV PW_SEED ""
ENV GH_REPO ""
ENV N_USERS 200
ENV USER_PREFIX train

# Install additional system packages ------------------------------------------#

RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends \
        libxml2-dev \
        vim \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
# Install R packages ----------------------------------------------------------#

RUN R -e 'install.packages("devtools", repos="https://packagemanager.rstudio.com/cran/__linux__/bionic/latest")' && \
    R -e 'install.packages("tidyverse", repos="https://packagemanager.rstudio.com/cran/__linux__/bionic/latest")' && \
    R -e 'install.packages("rmarkdown", repos="https://packagemanager.rstudio.com/cran/__linux__/bionic/latest")'

COPY start_rsp_train.sh /usr/local/bin/start_rsp_train.sh
RUN chmod +x /usr/local/bin/start_rsp_train.sh
COPY create_users_table.R /usr/local/bin/create_users_table.R
RUN chmod +x /usr/local/bin/create_users_table.R

CMD start_rsp_train.sh --n-users $N_USERS --pw-seed $PW_SEED --user-prefix $USER_PREFIX --gh-repo $GH_REPO --r-packages $R_PACKAGES --r-packages-gh $R_PACKAGES_GH