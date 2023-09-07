FROM thinker007/docker-wine:latest

USER root
RUN apt update && apt install -y \
    locales \
    mesa-utils \
    procps \
    pev \
    sudo \
    vim \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -fr /tmp/* \
  && apt --no-install-recommends install wget winbind samba  -y \
  && wget --no-check-certificate -O /bin/dumb-init "https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64"


COPY wine/simsun.ttc  /home/user/.wine/drive_c/windows/Fonts/simsun.ttc
COPY wine/微信.lnk /home/user/.wine/drive_c/users/Public/Desktop/微信.lnk
COPY wine/system.reg  /home/user/.wine/system.reg
COPY wine/user.reg  /home/user/.wine/user.reg
COPY wine/userdef.reg /home/user/.wine/userdef.reg

COPY wine/simsun.ttc  /home/user/.wine64/drive_c/windows/Fonts/simsun.ttc
COPY wine/微信.lnk /home/user/.wine64/drive_c/users/Public/Desktop/微信.lnk
COPY wine/system.reg  /home/user/.wine64/system.reg
COPY wine/user.reg  /home/user/.wine64/user.reg
COPY wine/userdef.reg /home/user/.wine64/userdef.reg


ENV \
  LANG=zh_CN.UTF-8 \
  LC_ALL=zh_CN.UTF-8

COPY --chown=user:group container_root/ /
COPY [A-Z]* /
COPY VERSION /VERSION.docker-wechat

RUN chown user /home \
  && localedef -i zh_CN -c -f UTF-8 zh_CN.UTF-8 \
  && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && echo '127.0.0.1 dldir1.qq.com' >> /etc/hosts

USER user
RUN bash -x /setup.sh
ENTRYPOINT [ "/bin/dumb-init", "--" ]
CMD ["/usr/bin/entrypoint"]
CMD [ "/entrypoint.sh" ]

#
# Huan(202004): VOLUME should be put to the END of the Dockerfile
#   because it will frezz the contents in the volume directory
#   which means the content in the directory will lost all changes after the VOLUME command
#
RUN mkdir -p "/home/user/WeChat Files" "/home/user/.wine/drive_c/users/user/Application Data" \
  && chown user:group "/home/user/WeChat Files" "/home/user/.wine/drive_c/users/user/Application Data"
VOLUME [\
  "/home/user/WeChat Files", \
  "/home/user/.wine/drive_c/users/user/Application Data" \
]

LABEL \
    org.opencontainers.image.authors="Huan LI (李卓桓) <zixia@zixia.net>" \
    org.opencontainers.image.description="DoChat(盒装微信) is a Dockerized WeChat(微信) PC Windows Client for Linux." \
    org.opencontainers.image.documentation="https://github.com/huan/docker-wechat/#readme" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.source="git@github.com:huan/docker-wechat.git" \
    org.opencontainers.image.title="DoChat" \
    org.opencontainers.image.url="https://github.com/huan/docker-wechat" \
    org.opencontainers.image.vendor="Huan LI (李卓桓)"
