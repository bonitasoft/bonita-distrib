/*
 * Copyright © 2019 Bonitasoft S.A.
 * Bonitasoft, 32 rue Gustave Eiffel - 38000 Grenoble
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
package org.apache.juli;

import static java.util.Optional.ofNullable;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.management.ManagementFactory;
import java.lang.management.ThreadInfo;
import java.lang.management.ThreadMXBean;
import java.util.Date;
import java.util.logging.Formatter;
import java.util.logging.LogManager;
import java.util.logging.LogRecord;

/**
 * Extend the {@link java.util.logging.SimpleFormatter} with thread information
 * <p>
 * <b>Configuration:</b> The {@code BonitaSimpleFormatter} is initialized with the format string specified in the
 * {@code org.apache.juli.BonitaSimpleFormatter.format} property to format the log messages (same way to set it as
 * the for the property of {@link java.util.logging.SimpleFormatter}).
 * </p>
 * <p>
 * The formatter adds the thread information available at position <code>7</code>
 * </p>
 */
public class BonitaSimpleFormatter extends Formatter {

    private final String format = getFormatFromConfig();

    public synchronized String format(LogRecord record) {
        Date date = new Date(record.getMillis());
        String source = getSourceAsString(record);
        String message = formatMessage(record);
        String throwable = getThrownAsString(record);
        return String.format(format,
                date,
                source,
                record.getLoggerName(),
                record.getLevel().getLocalizedName(),
                message,
                throwable,
                threadInfo(record));
    }

    private static String getFormatFromConfig() {
        return getProperty("org.apache.juli.BonitaSimpleFormatter.format",
                "%1$tF %1$tT.%1$tL %1$tz %4$s (%7$s) %3$s %5$s%6$s%n");
    }

    private static String getSourceAsString(LogRecord record) {
        String source;
        if (record.getSourceClassName() != null) {
            source = record.getSourceClassName();
            if (record.getSourceMethodName() != null) {
                source += " " + record.getSourceMethodName();
            }
        } else {
            source = record.getLoggerName();
        }
        return source;
    }

    // adapt from java.util.logging.SimpleFormatter (jdk8)
    private static String getThrownAsString(LogRecord record) {
        String throwable = "";
        if (record.getThrown() != null) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            pw.println();
            record.getThrown().printStackTrace(pw);
            pw.close();
            throwable = sw.toString();
        }
        return throwable;
    }

    // Highly inspired from tomcat-juli OneLineFormatter
    // See https://github.com/apache/tomcat/blob/cc7c12993bb43bafbdcc209d145e65e32025e3ab/java/org/apache/juli/OneLineFormatter.java#L137
    private static String threadInfo(LogRecord record) {
        // If using the async handler can't get the thread name from the current thread.
        final String threadName = Thread.currentThread().getName();
        if (threadName != null && !threadName.startsWith(AsyncFileHandler.THREAD_PREFIX)) {
            return threadName;
        }

        final int threadID = record.getThreadID();
        // LogRecord has threadID but no thread name.
        // LogRecord uses an int for thread ID but thread IDs are longs.
        // If the real thread ID > (Integer.MAXVALUE / 2) LogRecord uses it's own ID in an effort to avoid clashes due to overflow.
        // See LogRecord#MIN_SEQUENTIAL_THREAD_ID
        if (threadID > Integer.MAX_VALUE / 2) {
            return "UNKNOWN Thread ID " + threadID;
        }

        return ofNullable(threadMXBean().getThreadInfo(threadID))
                .map(ThreadInfo::getThreadName)
                .orElseGet(() -> Long.toString(threadID));
    }

    private static final Object threadMxBeanLock = new Object();
    // keep an instance here as ManagementFactory.getThreadMXBean() may have synchronized block in its implementation
    private static volatile ThreadMXBean threadMxBean = null;
    private static ThreadMXBean threadMXBean() {
        // Double checked locking OK as threadMxBean is volatile
        if (threadMxBean == null) {
            synchronized (threadMxBeanLock) {
                if (threadMxBean == null) {
                    threadMxBean = ManagementFactory.getThreadMXBean();
                }
            }
        }
        return threadMxBean;
    }

    private static String getProperty(String name, String defaultValue) {
        return ofNullable(LogManager.getLogManager().getProperty(name)).orElse(defaultValue);
    }

}
