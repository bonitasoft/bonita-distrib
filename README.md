# Bonita Distrib #

This project generates the Bonita Runtime bundles.

## Requirements

>     Java JDK 11 only

This project bundles the [Maven Wrapper](https://github.com/takari/maven-wrapper), so the `mvnw` script is available at the project root.

### Dependencies

The project depends on a lot of other bonita artifacts (engine, web, ...) so you must build them first (install artifacts in your local repository).

The [Bonita Community build script](https://github.com/Bonitasoft-Community/Build-Bonita) can help in that case.



## Contribution

I you want to contribute, ask questions about the project, report bug, see the [contributing guide](https://github.com/bonitasoft/bonita-developer-resources/blob/master/CONTRIBUTING.MD).



## Build the project ##

`./mvnw package`

