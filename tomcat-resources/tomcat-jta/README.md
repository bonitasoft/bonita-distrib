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

As of 2021-27-10, the changes from the original source code are the changes of the file `TransactionLifecycleListener`
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

And, the changes to XAResourceRecoveryHelper inside PoolingDataSourceFactory to the method initialiseConnection():
If the connection is not null, we close the connection, and create a new one (as the code before could never recover a connection that timed out anyway, and would keep trying indefinitely).