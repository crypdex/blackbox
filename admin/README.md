# BlackboxOS Admin

A small server that performs limited admin functions for the BlackboxOS.

This app runs outside of the Docker stack in order to have closer access to the host's OS level functions. More specifically:

- `git` is used to update the deployment by pulling the latest tag
- `docker` and `docker-compose` are used to restart the stack



## Building

See the `Makefile` in the parent directory.

## History 

The first pass at keeping the core system updated worked by mounting this directory in the API container. There were a couple of drawbacks with this approach.

First, using `docker-compose` or any related functions is really tricky. That is, its weird to have the a container invoking it's hosts docker to perform things. 

Second, as a workaround for invoking host functions, a `systemd` timer was used to look for a `restart` file. This is very much like the Passenger servers back in the day and also super counter-intuitive.

## Future

These functions could also be achieved from inside a container, but that is a 🐇 🕳 for another day (and breaks Docker's isolation imperative). See above.