Bonitasoft docker images
=========================

## Build SNAPSHOT version

```
./build.sh --
```

## Build TAG version

```
docker build -t bonitasoft/bonita:<VERSION> .
```


## Test

Tests uses [goss](https://github.com/aelsabbahy/goss). It needs to be installed first.

**_Note_**: No need to build image prior to running tests

```
cd test && ./runTests.sh
```
