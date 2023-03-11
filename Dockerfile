FROM node:16  AS builder

ARG tmdb_key 
ENV VITE_TMDB_KEY=$tmdb_key

WORKDIR /usr/src/app

COPY package*.json ./
COPY vite.config.js ./
COPY .npmrc ./
RUN  npm install

COPY ./src ./src
COPY index.html ./
COPY ./public ./public

RUN  npm run build

FROM node:16 

WORKDIR /usr/src/app

COPY package*.json ./
COPY vite.config.js ./
COPY .npmrc ./

RUN npm ci --omit=dev
RUN npm install -g http-server

COPY --from=builder /usr/src/app/dist ./dist

CMD http-server -p 80 ./dist
