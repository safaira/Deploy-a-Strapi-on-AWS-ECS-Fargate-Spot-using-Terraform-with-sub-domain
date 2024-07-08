FROM node:18 
WORKDIR /srv/
RUN apt update -y 
COPY . .
RUN npm install -y && npm install -g pm2
EXPOSE 1337
# CMD [ "npm", "start" ]
CMD ["pm2-runtime", "start", "npm", "--", "run", "start"]




