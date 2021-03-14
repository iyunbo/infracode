FROM vault:latest

RUN mkdir -p {{ server_conf_dir }}
ADD {{ server_conf_file }} {{ server_conf_dir }}/{{ server_conf_file }}
ADD {{ server_crt_file }} {{ server_conf_dir }}/{{ server_crt_file }}
ADD {{ server_key_file }} {{ server_conf_dir }}/{{ server_key_file }}

EXPOSE {{ server_port }}

ENV SKIP_SETCAP=yes

CMD ["server", "-config", "{{ server_conf_dir }}/{{ server_conf_file }}"]