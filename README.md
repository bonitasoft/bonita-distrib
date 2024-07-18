# Bonita Distrib #

This project generates the Bonita Runtime bundles.

## Requirements

>     Java JDK 17 only

This project bundles the [Maven Wrapper](https://github.com/takari/maven-wrapper), so the `mvnw` script is available at the project root.

### Dependencies

The project depends on a lot of other bonita artifacts (engine, web, ...) so you must build them first (install artifacts in your local repository).

The [Bonita Community build script](https://github.com/Bonitasoft-Community/Build-Bonita) can help in that case.

## Contribution

If you want to contribute, ask questions about the project, report bug, see the [contributing guide](https://github.com/bonitasoft/bonita-developer-resources/blob/master/CONTRIBUTING.MD).


## Build the project ##

`./mvnw package`

**_Note_**: You need to run this command before building the docker command explain in the dedicated [README](./docker/README.md)

