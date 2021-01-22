RUN [ -z "$(apt-get indextargets)" ]
RUN set -xe  \
	&& echo '#!/bin/sh' > /usr/sbin/policy-rc.d  \
	&& echo 'exit 101' >> /usr/sbin/policy-rc.d  \
	&& chmod +x /usr/sbin/policy-rc.d  \
	&& dpkg-divert --local --rename --add /sbin/initctl  \
	&& cp -a /usr/sbin/policy-rc.d /sbin/initctl  \
	&& sed -i 's/^exit.*/exit 0/' /sbin/initctl  \
	&& echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup  \
	&& echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean  \
	&& echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean  \
	&& echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean  \
	&& echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages  \
	&& echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes  \
	&& echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests
RUN mkdir -p /run/systemd  \
	&& echo 'docker' > /run/systemd/container
CMD ["/bin/bash"]
LABEL org.label-schema.license=GPL-2.0 org.label-schema.vcs-url=https://github.com/rocker-org/rocker-versioned org.label-schema.vendor=Rocker Project maintainer=Carl Boettiger <cboettig@ropensci.org>
ENV R_VERSION=4.0.3
ENV TERM=xterm
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV R_HOME=/usr/local/lib/R
ENV CRAN=https://packagemanager.rstudio.com/all/__linux__/focal/latest
ENV TZ=Etc/UTC
COPY dir:e894c64aae8c392e7556d869410d205feea885dfba266e441e4cb9386ce8eeee in /rocker_scripts
	rocker_scripts/
	rocker_scripts/.wh..wh..opq
	rocker_scripts/.cuda10.1-ubuntu20.04.sh.swp
	rocker_scripts/add_ubuntugis.sh
	rocker_scripts/bh-gdal.sh
	rocker_scripts/bh-proj-gdal_only.sh
	rocker_scripts/bh-proj.sh
	rocker_scripts/config_R_cuda.sh
	rocker_scripts/default_user.sh
	rocker_scripts/dev_osgeo.sh
	rocker_scripts/experimental/
	rocker_scripts/experimental/cuda10.2-tf.sh
	rocker_scripts/experimental/install_R_binary.sh
	rocker_scripts/experimental/install_rl.sh
	rocker_scripts/install_R.sh
	rocker_scripts/install_R_ppa.sh
	rocker_scripts/install_binder.sh
	rocker_scripts/install_cuda-10.1.sh
	rocker_scripts/install_cuda-11.1.sh
	rocker_scripts/install_gdal_source.sh
	rocker_scripts/install_geospatial.sh
	rocker_scripts/install_geospatial_unstable.sh
	rocker_scripts/install_nvtop.sh
	rocker_scripts/install_pandoc.sh
	rocker_scripts/install_proj.sh
	rocker_scripts/install_python.sh
	rocker_scripts/install_rstudio.sh
	rocker_scripts/install_s6init.sh
	rocker_scripts/install_shiny_server.sh
	rocker_scripts/install_tensorflow.sh
	rocker_scripts/install_texlive.sh
	rocker_scripts/install_tidyverse.sh
	rocker_scripts/install_verse.sh
	rocker_scripts/install_wgrib2.sh
	rocker_scripts/pam-helper.sh
	rocker_scripts/rsession.sh
	rocker_scripts/userconf.sh

RUN /rocker_scripts/install_R.sh
CMD ["R"]
LABEL org.label-schema.license=GPL-2.0 org.label-schema.vcs-url=https://github.com/rocker-org/rocker-versioned org.label-schema.vendor=Rocker Project maintainer=Carl Boettiger <cboettig@ropensci.org>
ENV S6_VERSION=v1.21.7.0
ENV SHINY_SERVER_VERSION=latest
ENV PANDOC_VERSION=default
RUN /rocker_scripts/install_shiny_server.sh
EXPOSE 3838
CMD ["/init"]
LABEL org.label-schema.license=GPL-2.0 org.label-schema.vcs-url=https://github.com/rocker-org/rocker-versioned org.label-schema.vendor=Rocker Project maintainer=Carl Boettiger <cboettig@ropensci.org>
RUN /rocker_scripts/install_tidyverse.sh
/init
/init
/init

