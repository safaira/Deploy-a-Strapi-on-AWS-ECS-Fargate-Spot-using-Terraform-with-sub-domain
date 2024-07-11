FROM node:18.0
WORKDIR /srv/
RUN apt update -y 
COPY . .
RUN apt install npm -y && npm install -g pm2
EXPOSE 1337
# CMD [ "npm", "start" ]
CMD ["pm2-runtime", "start", "npm", "--", "run", "start"]




FROM node:18.0.0  
WORKDIR /srv/
RUN apt update -y && apt install npm -y
COPY . /srv/
EXPOSE 1337
CMD [ "npm", "start" ]

sudo apt update -y && sudo apt install docker.io -y && sudo usermod -a -G docker ubuntu && sudo reboot
git clone https://github.com/safaira/strapi.git
docker build .
docker run -d --name strapi 