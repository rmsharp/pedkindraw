# A Linux box for running pedkindraw's tests the way GitHub's Ubuntu jobs do
# (pedkindraw S70, docs/planning/picture-files-plan.md section 13): Ubuntu 26.04
# (the runner's system), R 4.6, Google Chrome stable, and the packages the
# Chrome tests need, every one compiled from CRAN source (Ubuntu's own
# r-cran-* packages are built for R 4.5 and do not load in R 4.6).
# Build:  docker build -t pedkindraw-linux tools/linux
# Use:    tools/linux/runTests.sh savePedigreeDiagram
# The base image is the R-devel group's check server, an R 4.6 on Ubuntu 26.04
# for the machine's own architecture (arm64 on an Apple-silicon Mac).
FROM ghcr.io/r-devel/rcheckserver/ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      ca-certificates curl wget build-essential gfortran \
      libcurl4-openssl-dev libssl-dev \
  && rm -rf /var/lib/apt/lists/*
RUN wget -q "https://dl.google.com/linux/direct/google-chrome-stable_current_$(dpkg --print-architecture).deb" \
  && apt-get update -qq && apt-get install -y ./google-chrome-stable_current_*.deb \
  && rm -f google-chrome-stable_current_*.deb && rm -rf /var/lib/apt/lists/*
RUN Rscript -e 'options(Ncpus = 8L); pk <- c("chromote", "visNetwork", "htmlwidgets", "data.table", "quadprog", "testthat", "pkgload", "mockery", "withr"); install.packages(pk, repos = "https://cloud.r-project.org", type = "source"); miss <- setdiff(pk, rownames(installed.packages())); if (length(miss)) stop("missing: ", paste(miss, collapse = ", ")); for (p in pk) library(p, character.only = TRUE); cat("chromote", as.character(packageVersion("chromote")), "\n")'
# Chrome as root needs --no-sandbox; chromote finds it through CHROMOTE_CHROME.
RUN printf '#!/bin/sh\nexec /usr/bin/google-chrome-stable --no-sandbox "$@"\n' > /usr/local/bin/chrome-nosandbox \
  && chmod +x /usr/local/bin/chrome-nosandbox
ENV CHROMOTE_CHROME=/usr/local/bin/chrome-nosandbox
