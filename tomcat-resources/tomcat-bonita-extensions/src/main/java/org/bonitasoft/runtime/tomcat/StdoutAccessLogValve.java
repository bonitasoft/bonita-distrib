package org.bonitasoft.runtime.tomcat;;

import java.io.CharArrayWriter;

import org.apache.catalina.valves.AbstractAccessLogValve;


/**
 * <p>Tomcat access log valve implementation that generates access logs to standard output.
 *
 * Inspired from: https://github.com/Scout24/tomcat-stdout-accesslog
 * Usage: <Valve className="org.bonitasoft.runtime.tomcat.StdoutAccessLogValve" pattern="%h %l %u %t &quot;%r&quot; %s %b"/>
 * </p>
 **/
public class StdoutAccessLogValve extends AbstractAccessLogValve {

    @Override
    protected void log(CharArrayWriter message) {
        System.out.println(message.toString());
    }

}
