FROM amazonlinux
RUN yum install nginx -y
COPY nginx.conf /etc/nginx/nginx.conf
CMD ["nginx", "-g", "daemon off;"]