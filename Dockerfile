FROM heroku/heroku:16-build as build

COPY . /app/dca
WORKDIR /app/dca

# Setup buildpack
RUN mkdir -p /tmp/buildpack/heroku/go /tmp/build_cache /tmp/env
RUN curl https://codon-buildpacks.s3.amazonaws.com/buildpacks/heroku/go.tgz | tar xz -C /tmp/buildpack/heroku/go

#Execute Buildpack
RUN STACK=heroku-18 /tmp/buildpack/heroku/go/bin/compile /app/dca /tmp/build_cache /tmp/env

# Prepare final, minimal image
FROM heroku/heroku:18

COPY --from=build /app/dca /app/dca
ENV HOME /app/dca
WORKDIR /app/dca
RUN useradd -m heroku
USER heroku
CMD /app/dca/bin/go-getting-started