# Bonita tomcat-jta module

## Purpose

This module is a copy of the Jboss repository https://github.com/web-servers/narayana-tomcat/tree/master/tomcat-jta
([precise commit to-date](https://github.com/web-servers/narayana-tomcat/commit/4432f7b69b2bd3c63511bddac9070b33daa607e6)).

As of today, the code that we need is not yet released (version `1.0.1.Final-SNAPSHOT`), so we had to
"fork" this repository to package it in bonita-distrib.


## License

We copied the LGPL file called LICENSE at the root of the original repository to respect the restrictions and limitations
of the LGPL terms.


## Changes from the original sources

As of 2019-03-06, the only changes from the original source code is the changes of the file `TransactionLifecycleListener`
line 84:

from  
`} else if (Lifecycle.BEFORE_STOP_EVENT.equals(event.getType())) {`  
to  
`} else if (Lifecycle.AFTER_STOP_EVENT.equals(event.getType())) {`

to be compliant with Bonita Engine lifecycle.

line 31:

from  
`private static final Logger LOGGER = Logger.getLogger(TransactionLifecycleListener.class.getSimpleName());`  
to  
`private static final Logger LOGGER = Logger.getLogger(TransactionLifecycleListener.class.getName());`