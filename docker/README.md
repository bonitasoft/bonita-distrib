Bonitasoft docker images
=========================

## Requirement

Before building the docker image, you should run the `./mvnw package` like explain in the [README](../README.md)


## Build SNAPSHOT version

```shell
./build.sh --
```

## Build TAG version

```shell
./build.sh -t bonitasoft/bonita:<VERSION> --
```


## Test

Tests uses [goss](https://github.com/aelsabbahy/goss). It needs to be installed first.

**_Note_**: No need to build image prior to running tests

```shell
cd test && ./runTests.sh
```
