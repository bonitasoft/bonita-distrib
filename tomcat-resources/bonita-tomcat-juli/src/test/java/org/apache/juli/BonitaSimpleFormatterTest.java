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

import static org.assertj.core.api.Assertions.assertThat;

import java.util.concurrent.TimeUnit;
import java.util.logging.ConsoleHandler;
import java.util.logging.Logger;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.contrib.java.lang.system.RestoreSystemProperties;
import org.junit.contrib.java.lang.system.SystemErrRule;

public class BonitaSimpleFormatterTest {

    @Rule
    public final RestoreSystemProperties restoreSystemProperties = new RestoreSystemProperties();
    @Rule
    public final SystemErrRule systemErrRule = new SystemErrRule().enableLog();

    @Test
    public void should_logs_contain_thread_name() throws InterruptedException {
        // given:
        Logger logger = loggerWithConsoleHandler("MyLogger.withThreadName");

        // when:
        logger.info("A message in the test thread.");

        Thread thread = new Thread(() -> logger.warning("A warning message within the tread"));
        thread.setName("Thread_name_should_be_displayed");
        thread.start();
        TimeUnit.MILLISECONDS.sleep(100);

        // then:
        assertThat(systemErrRule.getLog()).as("logs")
                .contains("MyLogger.withThreadName", "(Thread_name_should_be_displayed)");
    }

    // =================================================================================================================
    // UTILS
    // =================================================================================================================

    private static Logger loggerWithConsoleHandler(String loggerName) {
        Logger logger = Logger.getLogger(loggerName);
        logger.setUseParentHandlers(false);

        ConsoleHandler handler = new ConsoleHandler();
        handler.setFormatter(new BonitaSimpleFormatter());
        logger.addHandler(handler);

        return logger;
    }

}
