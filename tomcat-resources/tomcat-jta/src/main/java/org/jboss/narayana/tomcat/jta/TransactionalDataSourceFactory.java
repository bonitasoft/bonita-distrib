/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.jboss.narayana.tomcat.jta;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Properties;
import javax.naming.Context;
import javax.naming.Name;
import javax.naming.RefAddr;
import javax.naming.Reference;
import javax.naming.spi.ObjectFactory;
import javax.sql.XADataSource;
import javax.transaction.TransactionManager;
import javax.transaction.TransactionSynchronizationRegistry;

import org.apache.juli.logging.Log;
import org.apache.juli.logging.LogFactory;
import org.jboss.narayana.tomcat.jta.internal.PoolingDataSourceFactory;

/**
 * @author <a href="mailto:zfeng@redhat.com">Zheng Feng</a>
 */
public class TransactionalDataSourceFactory implements ObjectFactory {

    private static final Log log = LogFactory.getLog(TransactionalDataSourceFactory.class);

    private static final String PROP_TRANSACTION_MANAGER = "transactionManager";
    private static final String PROP_XA_DATASOURCE = "xaDataSource";
    private static final String PROP_TRANSACTION_SYNCHRONIZATION_REGISTRY = "transactionSynchronizationRegistry";

    @Override
    public Object getObjectInstance(Object obj, Name name, Context context, Hashtable<?, ?> environment) throws Exception {
        if (obj == null || !(obj instanceof Reference)) {
            return null;
        }

        final Reference ref = (Reference) obj;
        if (!"javax.sql.XADataSource".equals(ref.getClassName())) {
            log.fatal(String.format("The expected type of datasource was javax.sql.XADataSource and not %s.", ref.getClassName()));
            return null;
        }

        final Properties properties = new Properties();
        Enumeration<RefAddr> iter = ref.getAll();

        while (iter.hasMoreElements()) {
            RefAddr ra = iter.nextElement();
            String type = ra.getType();
            String content = ra.getContent().toString();
            properties.setProperty(type, content);
        }

        final TransactionManager transactionManager = (TransactionManager) getReferenceObject(ref, context, PROP_TRANSACTION_MANAGER);
        final XADataSource xaDataSource = (XADataSource) getReferenceObject(ref, context, PROP_XA_DATASOURCE);
        final TransactionSynchronizationRegistry tsr = (TransactionSynchronizationRegistry) getReferenceObject(ref, context, PROP_TRANSACTION_SYNCHRONIZATION_REGISTRY);

        return PoolingDataSourceFactory.createPoolingDataSource(transactionManager, xaDataSource, tsr, properties);
    }

    private Object getReferenceObject(Reference ref, Context context, String prop) throws Exception {
        final RefAddr ra = ref.get(prop);
        if (ra != null) {
            return context.lookup(ra.getContent().toString());
        } else {
            return null;
        }
    }
}
